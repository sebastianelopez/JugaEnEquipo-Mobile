import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';

Future<bool> updateUserBackgroundImage(String base64Image) async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');

    final response = await APIService.instance.request(
      '/api/user/background-image',
      DioMethod.put,
      param: {
        'image': base64Image,
      },
      contentType: 'application/json',
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (kDebugMode) {
        debugPrint('updateUserBackgroundImage: Background image updated successfully');
      }
      return true;
    } else {
      if (kDebugMode) {
        debugPrint('updateUserBackgroundImage: API call failed: ${response.statusMessage}');
      }
      return false;
    }
  } catch (e) {
    if (kDebugMode) {
      debugPrint('updateUserBackgroundImage: Network error occurred: $e');
    }
    return false;
  }
}

