import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';

/// Assign a responsible user to a tournament
/// 
/// Parameters:
/// - [tournamentId]: The ID of the tournament
/// - [userId]: The ID of the user to assign as responsible
Future<bool> assignTournamentResponsible({
  required String tournamentId,
  required String userId,
}) async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');

    if (accessToken == null || accessToken.isEmpty) {
      if (kDebugMode) {
        debugPrint('assignTournamentResponsible: No access token found');
      }
      return false;
    }

    final response = await APIService.instance.request(
      '/api/tournament/$tournamentId/responsible/$userId',
      DioMethod.put,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      if (kDebugMode) {
        debugPrint('assignTournamentResponsible: Successfully assigned responsible');
      }
      return true;
    } else {
      if (kDebugMode) {
        debugPrint(
            'assignTournamentResponsible: Failed with status ${response.statusCode}');
      }
      return false;
    }
  } catch (e) {
    if (kDebugMode) {
      debugPrint('assignTournamentResponsible: Error occurred: $e');
    }
    return false;
  }
}

