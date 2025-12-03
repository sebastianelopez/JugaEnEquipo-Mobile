import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';

/// Get team background image URL
///
/// Parameters:
/// - [teamId]: The ID of the team
/// Returns the background image URL or null if not found
Future<String?> getTeamBackgroundImage(String teamId) async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');

    if (accessToken == null || accessToken.isEmpty) {
      if (kDebugMode) {
        debugPrint('getTeamBackgroundImage: No access token found');
      }
      return null;
    }

    final response = await APIService.instance.request(
      '/api/team/$teamId/background-image',
      DioMethod.get,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      if (kDebugMode) {
        debugPrint('getTeamBackgroundImage: API call successful');
      }

      if (response.data == null) {
        if (kDebugMode) {
          debugPrint('getTeamBackgroundImage: Response data is null');
        }
        return null;
      }

      try {
        if (response.data is Map<String, dynamic>) {
          final data = response.data['data'];
          if (data is Map<String, dynamic>) {
            return data['backgroundImage'] as String?;
          }
        }
        return null;
      } catch (e) {
        if (kDebugMode) {
          debugPrint('getTeamBackgroundImage: Error parsing response: $e');
        }
        return null;
      }
    } else if (response.statusCode == 404) {
      if (kDebugMode) {
        debugPrint('getTeamBackgroundImage: Background image not found');
      }
      return null;
    } else {
      if (kDebugMode) {
        debugPrint(
            'getTeamBackgroundImage: API call failed with status ${response.statusCode}: ${response.statusMessage}');
      }
      return null;
    }
  } catch (e) {
    if (kDebugMode) {
      debugPrint('getTeamBackgroundImage: Network error occurred: $e');
    }
    return null;
  }
}
