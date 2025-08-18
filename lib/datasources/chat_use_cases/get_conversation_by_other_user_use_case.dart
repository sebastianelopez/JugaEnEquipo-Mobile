import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';

Future<String?> getConversationIdByOtherUser(String userId) async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');

    final response = await APIService.instance.request(
      '/api/conversation/by-other-user/$userId',
      DioMethod.get,
      contentType: 'application/json',
      headers: {
        if (accessToken != null) 'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return response.data['data']['id'] as String?;
    }

    if (kDebugMode) {
      debugPrint('getConversationIdByOtherUser: status ${response.statusCode}');
    }
    return null;
  } catch (e) {
    if (kDebugMode) {
      debugPrint('getConversationIdByOtherUser error: $e');
    }
    return null;
  }
}
