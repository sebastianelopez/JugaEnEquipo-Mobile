import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';
import 'package:jugaenequipo/datasources/models/follow/follow_model.dart';

Future<FollowModel?> getFollowers(String id) async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');
    final response = await APIService.instance.request(
      '/api/user/$id/followers',
      DioMethod.get,
      contentType: 'application/json',
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    // Manage the response
    if (response.statusCode == 200) {
      if (kDebugMode) {
        debugPrint('getFollowers: API call successful: ${response.data}');
      }
      return FollowModel.fromJson(response.data);
    } else {
      // Error: Manage the error response
      if (kDebugMode) {
        debugPrint('getFollowers: API call failed: ${response.statusMessage}');
      }
      return null;
    }
  } catch (e) {
    // Error: Manage network errors
    if (kDebugMode) {
      debugPrint('getFollowers: Network error occurred: $e');
    }
    return null;
  }
}
