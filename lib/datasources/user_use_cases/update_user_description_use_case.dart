import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';

Future<bool> updateUserDescription(String description) async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');

    final response = await APIService.instance.request(
      '/api/user/description',
      DioMethod.patch,
      param: {
        'description': description,
      },
      contentType: 'application/json',
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      if (kDebugMode) {
        debugPrint('updateUserDescription: Description updated successfully');
      }
      return true;
    } else {
      if (kDebugMode) {
        debugPrint('updateUserDescription: API call failed: ${response.statusMessage}');
      }
      return false;
    }
  } catch (e) {
    if (kDebugMode) {
      debugPrint('updateUserDescription: Network error occurred: $e');
    }
    return false;
  }
}

