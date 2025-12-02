import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';

Future<bool> addSocialNetwork(String socialNetworkId, String username) async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');

    final response = await APIService.instance.request(
      '/api/user/social-network/$socialNetworkId/username/$username',
      DioMethod.put,
      contentType: 'application/json',
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (kDebugMode) {
        debugPrint('addSocialNetwork: Social network added successfully');
      }
      return true;
    } else {
      if (kDebugMode) {
        debugPrint('addSocialNetwork: API call failed: ${response.statusMessage}');
      }
      return false;
    }
  } catch (e) {
    if (kDebugMode) {
      debugPrint('addSocialNetwork: Network error occurred: $e');
    }
    return false;
  }
}

