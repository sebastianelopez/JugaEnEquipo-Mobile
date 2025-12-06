import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';

/// Request access for a team to join a tournament
/// 
/// Parameters:
/// - [tournamentId]: The ID of the tournament
/// - [teamId]: The ID of the team requesting access
Future<bool> requestTournamentAccess({
  required String tournamentId,
  required String teamId,
}) async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');

    if (accessToken == null || accessToken.isEmpty) {
      if (kDebugMode) {
        debugPrint('requestTournamentAccess: No access token found');
      }
      return false;
    }

    final response = await APIService.instance.request(
      '/api/tournament/$tournamentId/team/$teamId/request-access',
      DioMethod.put,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (kDebugMode) {
        debugPrint('requestTournamentAccess: Successfully requested access');
      }
      return true;
    } else {
      if (kDebugMode) {
        debugPrint(
            'requestTournamentAccess: Failed with status ${response.statusCode}');
      }
      return false;
    }
  } catch (e) {
    if (kDebugMode) {
      debugPrint('requestTournamentAccess: Error occurred: $e');
    }
    return false;
  }
}



