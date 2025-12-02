import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';
import 'package:jugaenequipo/datasources/models/models.dart';

Future<List<SocialNetworkModel>?> getUserSocialNetworks(String userId) async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');

    final response = await APIService.instance.request(
      '/api/user/$userId/social-networks',
      DioMethod.get,
      contentType: 'application/json',
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      if (kDebugMode) {
        debugPrint('getUserSocialNetworks: API call successful: ${response.data}');
      }

      final data = response.data['data'];
      if (data is List) {
        return data
            .map<SocialNetworkModel>((dynamic json) =>
                SocialNetworkModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      if (kDebugMode) {
        debugPrint('getUserSocialNetworks: Unexpected data format');
      }
      return null;
    } else {
      if (kDebugMode) {
        debugPrint('getUserSocialNetworks: API call failed: ${response.statusCode} ${response.statusMessage}');
      }
      return null;
    }
  } catch (e) {
    if (kDebugMode) {
      debugPrint('getUserSocialNetworks: Network error occurred: $e');
    }
    return null;
  }
}

