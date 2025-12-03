import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';

/// Delete a team
/// 
/// Parameters:
/// - [teamId]: The ID of the team to delete
Future<Result> deleteTeam(String teamId) async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');

    if (accessToken == null || accessToken.isEmpty) {
      if (kDebugMode) {
        debugPrint('deleteTeam: No access token found');
      }
      return Result.error;
    }

    final response = await APIService.instance.request(
      '/api/team/$teamId',
      DioMethod.delete,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      if (kDebugMode) {
        debugPrint('deleteTeam: API call successful');
      }
      return Result.success;
    } else if (response.statusCode == 401) {
      if (kDebugMode) {
        debugPrint('deleteTeam: Unauthorized - invalid token');
      }
      return Result.unauthorized;
    } else {
      if (kDebugMode) {
        debugPrint(
            'deleteTeam: API call failed with status ${response.statusCode}: ${response.statusMessage}');
      }
      return Result.error;
    }
  } catch (e) {
    if (kDebugMode) {
      debugPrint('deleteTeam: Network error occurred: $e');
    }
    return Result.error;
  }
}

