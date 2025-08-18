import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:jugaenequipo/datasources/api_service.dart';
import 'package:jugaenequipo/datasources/models/chat/chat_message_model.dart';

/// Minimal SSE client using Dio's streaming response.
/// Connects to Mercure without auth, as per reference implementation.
class ChatSSEService {
  static const String mercureBaseUrl = 'https://mercure.jugaenequipo.com';

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

  /// Connect to SSE and yield ChatMessageModel as they arrive
  Stream<ChatMessageModel> connect({required String conversationId}) async* {
    disconnect();

    final topicUrl =
        'https://api.jugaenequipo.com/conversation/$conversationId';
    final encodedTopic = Uri.encodeComponent(topicUrl);
    final url = '$mercureBaseUrl/.well-known/mercure?topic=$encodedTopic';

    _cancelToken = CancelToken();

    final response = await APIService.instance.request(
      // Full URL because Mercure is different host
      // We bypass baseUrl by using Dio directly through a GET with full path
      url,
      DioMethod.get,
      contentType: 'text/event-stream',
      responseType: ResponseType.stream,
      headers: {
        'Accept': 'text/event-stream',
        'Cache-Control': 'no-cache',
        'Connection': 'keep-alive',
      },
    );

    // Access the underlying stream of bytes
    final stream = response.data is Stream<List<int>>
        ? response.data as Stream<List<int>>
        : (response.requestOptions.responseType == ResponseType.stream
            ? (response.data.stream as Stream<List<int>>)
            : const Stream<List<int>>.empty());

    final controller = StreamController<ChatMessageModel>();
    final buffer = StringBuffer();

    _subscription = stream.listen((chunk) {
      try {
        buffer.write(utf8.decode(chunk));
        String data = buffer.toString();
        // SSE messages are separated by double newlines
        final parts = data.split('\n\n');
        // Keep the last partial in buffer
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
              controller.add(ChatMessageModel.fromJson(jsonMap));
            }
          }
        }
      } catch (e) {
        if (kDebugMode) {
          debugPrint('SSE parse error: $e');
        }
      }
    }, onError: (error) {
      controller.addError(error);
    }, onDone: () {
      controller.close();
    }, cancelOnError: true);

    yield* controller.stream;
  }
}
