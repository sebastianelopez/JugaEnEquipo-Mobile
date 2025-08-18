import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';
import 'package:jugaenequipo/datasources/models/chat/chat_message_model.dart';

Future<List<ChatMessageModel>> getConversationMessages(
    String conversationId) async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');

    final response = await APIService.instance.request(
      '/api/conversation/$conversationId/messages',
      DioMethod.get,
      contentType: 'application/json',
      headers: {
        if (accessToken != null) 'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data['data'] as List<dynamic>? ?? [];
      return data
          .map((e) => ChatMessageModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    if (kDebugMode) {
      debugPrint('getConversationMessages: status ${response.statusCode}');
    }
    return [];
  } catch (e) {
    if (kDebugMode) {
      debugPrint('getConversationMessages error: $e');
    }
    return [];
  }
}
