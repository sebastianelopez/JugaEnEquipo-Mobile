import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';

/// Request access to join a team
/// 
/// Parameters:
/// - [teamId]: The ID of the team to request access to
Future<Result> requestTeamAccess(String teamId) async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');

    if (accessToken == null || accessToken.isEmpty) {
      if (kDebugMode) {
        debugPrint('requestTeamAccess: No access token found');
      }
      return Result.error;
    }

    final response = await APIService.instance.request(
      '/api/team/$teamId/request-access',
      DioMethod.put,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 204) {
      if (kDebugMode) {
        debugPrint('requestTeamAccess: API call successful');
      }
      return Result.success;
    } else if (response.statusCode == 401) {
      if (kDebugMode) {
        debugPrint('requestTeamAccess: Unauthorized - invalid token');
      }
      return Result.unauthorized;
    } else {
      if (kDebugMode) {
        debugPrint(
            'requestTeamAccess: API call failed with status ${response.statusCode}: ${response.statusMessage}');
      }
      return Result.error;
    }
  } catch (e) {
    if (kDebugMode) {
      debugPrint('requestTeamAccess: Network error occurred: $e');
    }
    return Result.error;
  }
}

