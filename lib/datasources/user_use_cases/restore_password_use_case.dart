import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';

Future<bool> restorePassword(String userId, String newPassword, String confirmationNewPassword) async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');

    final response = await APIService.instance.request(
      '/api/user/$userId/restore',
      DioMethod.put,
      param: {
        'newPassword': newPassword,
        'confirmationNewPassword': confirmationNewPassword,
      },
      contentType: 'application/json',
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      if (kDebugMode) {
        debugPrint('restorePassword: Password restored successfully');
      }
      return true;
    } else {
      if (kDebugMode) {
        debugPrint('restorePassword: API call failed: ${response.statusMessage}');
      }
      return false;
    }
  } catch (e) {
    if (kDebugMode) {
      debugPrint('restorePassword: Network error occurred: $e');
    }
    return false;
  }
}

