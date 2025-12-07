import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';

/// Leave a tournament (team leaves)
///
/// Parameters:
/// - [tournamentId]: The ID of the tournament
/// - [teamId]: The ID of the team leaving
Future<bool> leaveTournament({
  required String tournamentId,
  required String teamId,
}) async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');

    if (accessToken == null || accessToken.isEmpty) {
      if (kDebugMode) {
        debugPrint('leaveTournament: No access token found');
      }
      return false;
    }

    if (kDebugMode) {
      debugPrint('leaveTournament: Calling API...');
      debugPrint('  - Tournament ID: $tournamentId');
      debugPrint('  - Team ID: $teamId');
      debugPrint(
          '  - Endpoint: /api/tournament/$tournamentId/team/$teamId/leave');
    }

    final response = await APIService.instance.request(
      '/api/tournament/$tournamentId/team/$teamId/leave',
      DioMethod.post,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (kDebugMode) {
      debugPrint('leaveTournament: Response received');
      debugPrint('  - Status code: ${response.statusCode}');
      debugPrint('  - Response data: ${response.data}');
    }

    if (response.statusCode == 200 || response.statusCode == 204) {
      if (kDebugMode) {
        debugPrint('leaveTournament: Successfully left tournament');
      }
      return true;
    } else {
      if (kDebugMode) {
        debugPrint(
            'leaveTournament: Failed with status ${response.statusCode}');
        debugPrint('  - Response message: ${response.statusMessage}');
        debugPrint('  - Response data: ${response.data}');
      }
      return false;
    }
  } catch (e) {
    if (kDebugMode) {
      debugPrint('leaveTournament: Error occurred: $e');
    }
    return false;
  }
}
