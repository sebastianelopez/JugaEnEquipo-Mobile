import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';

Future<bool> removeSocialNetwork(String socialNetworkId) async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');

    final response = await APIService.instance.request(
      '/api/user/social-network/$socialNetworkId',
      DioMethod.delete,
      contentType: 'application/json',
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      if (kDebugMode) {
        debugPrint('removeSocialNetwork: Social network removed successfully');
      }
      return true;
    } else {
      if (kDebugMode) {
        debugPrint('removeSocialNetwork: API call failed: ${response.statusMessage}');
      }
      return false;
    }
  } catch (e) {
    if (kDebugMode) {
      debugPrint('removeSocialNetwork: Network error occurred: $e');
    }
    return false;
  }
}

