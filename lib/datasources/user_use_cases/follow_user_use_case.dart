import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';

Future<bool> followUser(String userId) async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');

    final response = await APIService.instance.request(
      '/api/user/$userId/follow',
      DioMethod.put,
      contentType: 'application/json',
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    // Handle the response
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (kDebugMode) {
        debugPrint('followUser: API call successful: ${response.data}');
      }
      return true;
    } else {
      // Error: Handle the error response
      if (kDebugMode) {
        debugPrint('followUser: API call failed: ${response.statusMessage}');
      }
      return false;
    }
  } catch (e) {
    // Error: Handle network errors
    if (kDebugMode) {
      debugPrint('followUser: Network error occurred: $e');
    }
    return false;
  }
}
