import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';

Future<bool> markMessageAsRead({
  required String conversationId,
  required String messageId,
}) async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');

    final response = await APIService.instance.request(
      '/conversation/$conversationId/message/$messageId/mark-as-read',
      DioMethod.put,
      contentType: 'application/json',
      headers: {
        if (accessToken != null) 'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      if (kDebugMode) {
        debugPrint('markMessageAsRead: Successfully marked message $messageId as read in conversation $conversationId');
      }
      return true;
    }

    if (kDebugMode) {
      debugPrint('markMessageAsRead: status ${response.statusCode}');
      debugPrint('markMessageAsRead: response ${response.data}');
    }
    return false;
  } catch (e) {
    if (kDebugMode) {
      debugPrint('markMessageAsRead error: $e');
    }
    return false;
  }
}

