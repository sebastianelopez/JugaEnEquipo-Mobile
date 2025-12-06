import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';

/// Delete a tournament
/// 
/// Parameters:
/// - [tournamentId]: The ID of the tournament to delete
Future<bool> deleteTournament({
  required String tournamentId,
}) async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');

    if (accessToken == null || accessToken.isEmpty) {
      if (kDebugMode) {
        debugPrint('deleteTournament: No access token found');
      }
      return false;
    }

    final response = await APIService.instance.request(
      '/api/tournament/$tournamentId',
      DioMethod.delete,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      if (kDebugMode) {
        debugPrint('deleteTournament: Successfully deleted tournament');
      }
      return true;
    } else {
      if (kDebugMode) {
        debugPrint(
            'deleteTournament: Failed with status ${response.statusCode}');
      }
      return false;
    }
  } catch (e) {
    if (kDebugMode) {
      debugPrint('deleteTournament: Error occurred: $e');
    }
    return false;
  }
}



