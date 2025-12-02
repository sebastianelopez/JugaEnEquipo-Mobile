import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';
import 'package:jugaenequipo/datasources/models/follow/follow_model.dart';

Future<FollowModel?> getFollowings(String id) async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');

    if (accessToken == null || accessToken.isEmpty) {
      if (kDebugMode) {
        debugPrint('getFollowings: No access token found');
      }
      return null;
    }

    final response = await APIService.instance.request(
      '/api/user/$id/followings',
      DioMethod.get,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    // Manage the response
    if (response.statusCode == 200) {
      if (kDebugMode) {
        debugPrint('getFollowings: API call successful');
      }

      // Validate response structure
      if (response.data == null) {
        if (kDebugMode) {
          debugPrint('getFollowings: Response data is null');
        }
        return null;
      }

      try {
        return FollowModel.fromJson(response.data);
      } catch (e) {
        if (kDebugMode) {
          debugPrint('getFollowings: Error parsing response: $e');
        }
        return null;
      }
    } else if (response.statusCode == 401) {
      // Unauthorized
      if (kDebugMode) {
        debugPrint('getFollowings: Unauthorized - invalid token');
      }
      return null;
    } else {
      // Error: Manage the error response
      if (kDebugMode) {
        debugPrint(
            'getFollowings: API call failed with status ${response.statusCode}: ${response.statusMessage}');
      }
      return null;
    }
  } catch (e) {
    // Error: Manage network errors
    if (kDebugMode) {
      debugPrint('getFollowings: Network error occurred: $e');
    }
    return null;
  }
}
