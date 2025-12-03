import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';
import 'package:jugaenequipo/datasources/models/models.dart';

/// Get all games for a team
/// 
/// Parameters:
/// - [teamId]: The ID of the team
Future<List<TeamGameModel>?> getTeamGames(String teamId) async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');

    if (accessToken == null || accessToken.isEmpty) {
      if (kDebugMode) {
        debugPrint('getTeamGames: No access token found');
      }
      return null;
    }

    final response = await APIService.instance.request(
      '/api/team/$teamId/games',
      DioMethod.get,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      if (kDebugMode) {
        debugPrint('getTeamGames: API call successful');
      }

      if (response.data == null) {
        if (kDebugMode) {
          debugPrint('getTeamGames: Response data is null');
        }
        return null;
      }

      final data = response.data['data'];
      if (data == null || data is! List) {
        if (kDebugMode) {
          debugPrint('getTeamGames: Response data is not a list');
        }
        return null;
      }

      try {
        final games = data
            .map((game) =>
                TeamGameModel.fromJson(game as Map<String, dynamic>))
            .toList();
        return games;
      } catch (e) {
        if (kDebugMode) {
          debugPrint('getTeamGames: Error parsing response: $e');
        }
        return null;
      }
    } else {
      if (kDebugMode) {
        debugPrint(
            'getTeamGames: API call failed with status ${response.statusCode}: ${response.statusMessage}');
      }
      return null;
    }
  } catch (e) {
    if (kDebugMode) {
      debugPrint('getTeamGames: Network error occurred: $e');
    }
    return null;
  }
}

