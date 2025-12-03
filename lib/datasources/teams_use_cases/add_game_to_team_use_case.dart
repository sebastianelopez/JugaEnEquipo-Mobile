import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';

/// Add a game to a team
/// 
/// Parameters:
/// - [teamId]: The ID of the team
/// - [gameId]: The ID of the game to add
Future<Result> addGameToTeam(String teamId, String gameId) async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');

    if (accessToken == null || accessToken.isEmpty) {
      if (kDebugMode) {
        debugPrint('addGameToTeam: No access token found');
      }
      return Result.error;
    }

    final response = await APIService.instance.request(
      '/api/team/$teamId/game/$gameId',
      DioMethod.put,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      if (kDebugMode) {
        debugPrint('addGameToTeam: API call successful');
      }
      return Result.success;
    } else if (response.statusCode == 401) {
      if (kDebugMode) {
        debugPrint('addGameToTeam: Unauthorized - invalid token');
      }
      return Result.unauthorized;
    } else {
      if (kDebugMode) {
        debugPrint(
            'addGameToTeam: API call failed with status ${response.statusCode}: ${response.statusMessage}');
      }
      return Result.error;
    }
  } catch (e) {
    if (kDebugMode) {
      debugPrint('addGameToTeam: Network error occurred: $e');
    }
    return Result.error;
  }
}

