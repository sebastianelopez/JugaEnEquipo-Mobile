import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';

Future<bool> markNotificationAsRead(String notificationId) async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');

    final response = await APIService.instance.request(
      '/api/notification/$notificationId/mark-as-read',
      DioMethod.put,
      contentType: 'application/json',
      headers: {
        if (accessToken != null) 'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      return true;
    }

    if (kDebugMode) {
      debugPrint('markNotificationAsRead: status ${response.statusCode}');
    }
    return false;
  } catch (e) {
    if (kDebugMode) {
      debugPrint('markNotificationAsRead error: $e');
    }
    return false;
  }
}
