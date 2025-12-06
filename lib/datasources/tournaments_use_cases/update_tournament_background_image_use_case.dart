import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';

/// Update tournament background image
/// 
/// Parameters:
/// - [tournamentId]: The ID of the tournament
/// - [imageBase64]: Base64 encoded image string (with data URI prefix: "data:image/png;base64,...")
Future<bool> updateTournamentBackgroundImage({
  required String tournamentId,
  required String imageBase64,
}) async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');

    if (accessToken == null || accessToken.isEmpty) {
      if (kDebugMode) {
        debugPrint('updateTournamentBackgroundImage: No access token found');
      }
      return false;
    }

    final response = await APIService.instance.request(
      '/api/tournament/$tournamentId/background-image',
      DioMethod.put,
      param: {
        'image': imageBase64,
      },
      contentType: 'application/json',
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      if (kDebugMode) {
        debugPrint('updateTournamentBackgroundImage: Successfully updated image');
      }
      return true;
    } else {
      if (kDebugMode) {
        debugPrint(
            'updateTournamentBackgroundImage: Failed with status ${response.statusCode}');
      }
      return false;
    }
  } catch (e) {
    if (kDebugMode) {
      debugPrint('updateTournamentBackgroundImage: Error occurred: $e');
    }
    return false;
  }
}



