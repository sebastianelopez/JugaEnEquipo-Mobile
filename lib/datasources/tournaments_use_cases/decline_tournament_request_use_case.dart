import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';

/// Decline a tournament request
/// 
/// Parameters:
/// - [requestId]: The ID of the request to decline
Future<bool> declineTournamentRequest({
  required String requestId,
}) async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');

    if (accessToken == null || accessToken.isEmpty) {
      if (kDebugMode) {
        debugPrint('declineTournamentRequest: No access token found');
      }
      return false;
    }

    final response = await APIService.instance.request(
      '/api/tournament/request/$requestId/decline',
      DioMethod.put,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      if (kDebugMode) {
        debugPrint('declineTournamentRequest: Successfully declined request');
      }
      return true;
    } else {
      if (kDebugMode) {
        debugPrint(
            'declineTournamentRequest: Failed with status ${response.statusCode}');
      }
      return false;
    }
  } catch (e) {
    if (kDebugMode) {
      debugPrint('declineTournamentRequest: Error occurred: $e');
    }
    return false;
  }
}

