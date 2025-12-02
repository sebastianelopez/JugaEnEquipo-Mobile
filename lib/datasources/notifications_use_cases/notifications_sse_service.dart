import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:jugaenequipo/utils/utils.dart';

/// SSE client for notifications via Mercure
class NotificationsSSEService {
  static const String mercureBaseUrl = 'https://mercure.jugaenequipo.com';
  static const String hostBaseUrl = 'https://api.jugaenequipo.com';
  static const String topicBase = '$hostBaseUrl/notification/';

  final Dio _dio = Dio();
  CancelToken? _cancelToken;
  StreamSubscription<List<int>>? _subscription;

  NotificationsSSEService() {
    _dio.options = BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 0), // No timeout for SSE streams
      sendTimeout: const Duration(seconds: 30),
    );
  }

  void disconnect() {
    try {
      _subscription?.cancel();
      _subscription = null;

      // Cancel token without throwing error
      if (_cancelToken != null && !_cancelToken!.isCancelled) {
        _cancelToken!.cancel('Manual disconnect');
      }
      _cancelToken = null;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('NotificationsSSEService: Disconnect error (ignored): $e');
      }
    }
  }

  /// Connect to Mercure for notifications
  /// Emits NotificationModel parsed from event data
  /// Requires current user ID to subscribe to the correct topic
  Stream<NotificationModel> connect() async* {
    disconnect();

    // Get current user ID from token
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');

    if (accessToken == null) {
      if (kDebugMode) {
        debugPrint('NotificationsSSEService: No access token found');
      }
      return;
    }

    final currentUserId = decodeUserIdByToken(accessToken);
    final topic = '$topicBase$currentUserId';
    final encodedTopic = Uri.encodeComponent(topic);

    final url = '$mercureBaseUrl/.well-known/mercure?topic=$encodedTopic';

    if (kDebugMode) {
      debugPrint('NotificationsSSEService: Connecting to Mercure');
      debugPrint('NotificationsSSEService: Topic: $topic');
      debugPrint('NotificationsSSEService: URL: $url');
    }

    _cancelToken = CancelToken();

    try {
      final response = await _dio.get(
        url,
        options: Options(
          responseType: ResponseType.stream,
          headers: {
            'Accept': 'text/event-stream',
            'Cache-Control': 'no-cache',
            'Connection': 'keep-alive',
          },
        ),
        cancelToken: _cancelToken,
      );

      final stream = response.data is Stream<List<int>>
          ? response.data as Stream<List<int>>
          : (response.requestOptions.responseType == ResponseType.stream
              ? (response.data.stream as Stream<List<int>>)
              : const Stream<List<int>>.empty());

      final controller = StreamController<NotificationModel>();
      final buffer = StringBuffer();

      _subscription = stream.listen((chunk) {
        try {
          buffer.write(utf8.decode(chunk));
          String data = buffer.toString();
          final parts = data.split('\n\n');
          buffer
            ..clear()
            ..write(parts.isNotEmpty ? parts.removeLast() : '');

          for (final part in parts) {
            final lines = part.split('\n');
            for (final line in lines) {
              if (line.startsWith('data:')) {
                final jsonStr = line.substring(5).trim();
                if (jsonStr.isEmpty) continue;
                final Map<String, dynamic> jsonMap = json.decode(jsonStr);
                controller.add(_notificationFromJsonSafe(jsonMap));
              }
            }
          }
        } catch (e) {
          if (kDebugMode) {
            debugPrint('Notifications SSE parse error: $e');
          }
        }
      }, onError: (error) {
        // Don't propagate cancellation errors as they are expected
        if (error is DioException && error.type == DioExceptionType.cancel) {
          if (kDebugMode) {
            debugPrint('NotificationsSSEService: Stream cancelled (expected)');
          }
        } else {
          controller.addError(error);
        }
      }, onDone: () {
        controller.close();
      }, cancelOnError: true);

      yield* controller.stream;
    } catch (e) {
      // Don't rethrow cancellation errors as they are expected when disconnecting
      if (e is DioException && e.type == DioExceptionType.cancel) {
        if (kDebugMode) {
          debugPrint(
              'NotificationsSSEService: Connection cancelled (expected)');
        }
        return;
      }

      if (kDebugMode) {
        debugPrint('NotificationsSSEService: Connection error: $e');
      }
      rethrow;
    }
  }

  NotificationModel _notificationFromJsonSafe(Map<String, dynamic> json) {
    return NotificationModel.fromJson(json);
  }
}
