import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';
import 'package:jugaenequipo/datasources/models/models.dart';

/// Get a team by its ID
Future<TeamModel?> getTeamById(String teamId) async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');

    if (accessToken == null || accessToken.isEmpty) {
      if (kDebugMode) {
        debugPrint('getTeamById: No access token found');
      }
      return null;
    }

    final response = await APIService.instance.request(
      '/api/team/$teamId',
      DioMethod.get,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    // Manage the response
    if (response.statusCode == 200) {
      if (kDebugMode) {
        debugPrint('getTeamById: API call successful');
      }

      // Validate response structure
      if (response.data == null) {
        if (kDebugMode) {
          debugPrint('getTeamById: Response data is null');
        }
        return null;
      }

      try {
        return TeamModel.fromJson(response.data as Map<String, dynamic>);
      } catch (e) {
        if (kDebugMode) {
          debugPrint('getTeamById: Error parsing response: $e');
        }
        return null;
      }
    } else if (response.statusCode == 401) {
      // Unauthorized
      if (kDebugMode) {
        debugPrint('getTeamById: Unauthorized - invalid token');
      }
      return null;
    } else if (response.statusCode == 404) {
      // Not found
      if (kDebugMode) {
        debugPrint('getTeamById: Team not found');
      }
      return null;
    } else {
      // Error: Manage the error response
      if (kDebugMode) {
        debugPrint(
            'getTeamById: API call failed with status ${response.statusCode}: ${response.statusMessage}');
      }
      return null;
    }
  } catch (e) {
    // Error: Manage network errors
    if (kDebugMode) {
      debugPrint('getTeamById: Network error occurred: $e');
    }
    return null;
  }
}

