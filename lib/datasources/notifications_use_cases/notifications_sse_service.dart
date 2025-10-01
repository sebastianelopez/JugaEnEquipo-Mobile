import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:jugaenequipo/datasources/api_service.dart';
import 'package:jugaenequipo/datasources/models/models.dart';

/// SSE client for notifications via Mercure
class NotificationsSSEService {
  static const String mercureBaseUrl = 'https://mercure.jugaenequipo.com';
  static const String topicBase = 'https://api.jugaenequipo.com/notification/';

  CancelToken? _cancelToken;
  StreamSubscription<List<int>>? _subscription;

  void disconnect() {
    try {
      _subscription?.cancel();
      _subscription = null;
      _cancelToken?.cancel('Manual disconnect');
      _cancelToken = null;
    } catch (_) {}
  }

  /// Connect to Mercure for notifications
  /// Emits NotificationModel parsed from event data
  Stream<NotificationModel> connect() async* {
    disconnect();

    final encodedTopic = Uri.encodeComponent(topicBase);
    final url = '$mercureBaseUrl/.well-known/mercure?topic=$encodedTopic';

    _cancelToken = CancelToken();

    final response = await APIService.instance.request(
      url,
      DioMethod.get,
      contentType: 'text/event-stream',
      responseType: ResponseType.stream,
      headers: const {
        'Accept': 'text/event-stream',
        'Cache-Control': 'no-cache',
        'Connection': 'keep-alive',
      },
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
      controller.addError(error);
    }, onDone: () {
      controller.close();
    }, cancelOnError: true);

    yield* controller.stream;
  }

  NotificationModel _notificationFromJsonSafe(Map<String, dynamic> json) {
    UserModel user;
    final dynamic userJson = json['user'];
    if (userJson is Map<String, dynamic>) {
      try {
        user = UserModel.fromJson(userJson);
      } catch (_) {
        user = _fallbackUser(userJson);
      }
    } else {
      user = _fallbackUser(json);
    }

    final String id = (json['id'] ?? '').toString();
    final String content = (json['content'] ??
            json['message'] ??
            json['notificationContent'] ??
            '')
        .toString();
    final bool isRead = (json['read'] as bool?) ??
        (json['isRead'] as bool?) ??
        (json['isNotificationRead'] as bool?) ??
        false;
    final String createdAt =
        (json['createdAt'] ?? json['date'] ?? '').toString();

    return NotificationModel(
      id: id,
      user: user,
      notificationContent: content,
      isNotificationRead: isRead,
      date: createdAt,
    );
  }

  UserModel _fallbackUser(Map<String, dynamic> json) {
    return UserModel(
      id: (json['userId'] ?? json['id'] ?? '').toString(),
      firstName: (json['firstname'] ?? json['firstName'] ?? '').toString(),
      lastName: (json['lastname'] ?? json['lastName'] ?? '').toString(),
      userName: (json['username'] ?? json['userName'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      teamId: json['teamId']?.toString(),
      profileImage: (json['profileImage'] ?? json['avatar'] ?? '').toString(),
    );
  }
}

