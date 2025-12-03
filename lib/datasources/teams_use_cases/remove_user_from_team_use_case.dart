import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';

/// Remove a user from a team
/// 
/// Parameters:
/// - [teamId]: The ID of the team
/// - [userId]: The ID of the user to remove
Future<Result> removeUserFromTeam(String teamId, String userId) async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');

    if (accessToken == null || accessToken.isEmpty) {
      if (kDebugMode) {
        debugPrint('removeUserFromTeam: No access token found');
      }
      return Result.error;
    }

    final response = await APIService.instance.request(
      '/api/team/$teamId/user/$userId',
      DioMethod.delete,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      if (kDebugMode) {
        debugPrint('removeUserFromTeam: API call successful');
      }
      return Result.success;
    } else if (response.statusCode == 401) {
      if (kDebugMode) {
        debugPrint('removeUserFromTeam: Unauthorized - invalid token');
      }
      return Result.unauthorized;
    } else {
      if (kDebugMode) {
        debugPrint(
            'removeUserFromTeam: API call failed with status ${response.statusCode}: ${response.statusMessage}');
      }
      return Result.error;
    }
  } catch (e) {
    if (kDebugMode) {
      debugPrint('removeUserFromTeam: Network error occurred: $e');
    }
    return Result.error;
  }
}

