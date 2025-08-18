import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';

Future<bool> sendMessage({
  required String conversationId,
  required String messageId,
  required String content,
}) async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');

    final response = await APIService.instance.request(
      '/api/conversation/$conversationId/message/$messageId',
      DioMethod.put,
      contentType: 'application/json',
      param: {
        'content': content,
      },
      headers: {
        if (accessToken != null) 'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return true;
    }

    if (kDebugMode) {
      debugPrint('sendMessage: status ${response.statusCode}');
    }
    return false;
  } catch (e) {
    if (kDebugMode) {
      debugPrint('sendMessage error: $e');
    }
    return false;
  }
}
