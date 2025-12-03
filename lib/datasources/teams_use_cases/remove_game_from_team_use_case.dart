import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';

/// Remove a game from a team
/// 
/// Parameters:
/// - [teamId]: The ID of the team
/// - [gameId]: The ID of the game to remove
Future<Result> removeGameFromTeam(String teamId, String gameId) async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');

    if (accessToken == null || accessToken.isEmpty) {
      if (kDebugMode) {
        debugPrint('removeGameFromTeam: No access token found');
      }
      return Result.error;
    }

    final response = await APIService.instance.request(
      '/api/team/$teamId/game/$gameId',
      DioMethod.delete,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      if (kDebugMode) {
        debugPrint('removeGameFromTeam: API call successful');
      }
      return Result.success;
    } else if (response.statusCode == 401) {
      if (kDebugMode) {
        debugPrint('removeGameFromTeam: Unauthorized - invalid token');
      }
      return Result.unauthorized;
    } else {
      if (kDebugMode) {
        debugPrint(
            'removeGameFromTeam: API call failed with status ${response.statusCode}: ${response.statusMessage}');
      }
      return Result.error;
    }
  } catch (e) {
    if (kDebugMode) {
      debugPrint('removeGameFromTeam: Network error occurred: $e');
    }
    return Result.error;
  }
}

