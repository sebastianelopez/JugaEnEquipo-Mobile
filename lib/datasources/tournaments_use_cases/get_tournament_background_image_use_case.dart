import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';

/// Get tournament background image URL
/// 
/// Parameters:
/// - [tournamentId]: The ID of the tournament
/// Returns the image URL or null if not found
Future<String?> getTournamentBackgroundImage({
  required String tournamentId,
}) async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');

    if (accessToken == null || accessToken.isEmpty) {
      if (kDebugMode) {
        debugPrint('getTournamentBackgroundImage: No access token found');
      }
      return null;
    }

    final response = await APIService.instance.request(
      '/api/tournament/$tournamentId/background-image',
      DioMethod.get,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      if (kDebugMode) {
        debugPrint('getTournamentBackgroundImage: API call successful');
      }

      if (response.data == null) {
        return null;
      }

      // The response might be a direct URL or wrapped in a data object
      if (response.data is String) {
        return response.data as String;
      } else if (response.data is Map && response.data['image'] != null) {
        return response.data['image'] as String;
      } else if (response.data is Map && response.data['data'] != null) {
        final data = response.data['data'];
        if (data is String) {
          return data;
        } else if (data is Map && data['image'] != null) {
          return data['image'] as String;
        }
      }

      return null;
    } else {
      if (kDebugMode) {
        debugPrint(
            'getTournamentBackgroundImage: Failed with status ${response.statusCode}');
      }
      return null;
    }
  } catch (e) {
    if (kDebugMode) {
      debugPrint('getTournamentBackgroundImage: Error occurred: $e');
    }
    return null;
  }
}

