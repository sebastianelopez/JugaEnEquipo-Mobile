import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';

/// Accept a tournament request
/// 
/// Parameters:
/// - [requestId]: The ID of the request to accept
Future<bool> acceptTournamentRequest({
  required String requestId,
}) async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');

    if (accessToken == null || accessToken.isEmpty) {
      if (kDebugMode) {
        debugPrint('acceptTournamentRequest: No access token found');
      }
      return false;
    }

    final response = await APIService.instance.request(
      '/api/tournament/request/$requestId/accept',
      DioMethod.put,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      if (kDebugMode) {
        debugPrint('acceptTournamentRequest: Successfully accepted request');
      }
      return true;
    } else {
      if (kDebugMode) {
        debugPrint(
            'acceptTournamentRequest: Failed with status ${response.statusCode}');
      }
      return false;
    }
  } catch (e) {
    if (kDebugMode) {
      debugPrint('acceptTournamentRequest: Error occurred: $e');
    }
    return false;
  }
}

