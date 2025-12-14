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
        // Handle response structure: {"data": {...}} or direct object
        dynamic responseData = response.data;
        Map<String, dynamic>? teamData;

        if (responseData is Map<String, dynamic>) {
          // Check if response has a "data" wrapper
          if (responseData.containsKey('data')) {
            teamData = responseData['data'] as Map<String, dynamic>?;
          } else {
            // Response is the team object directly
            teamData = responseData;
          }
        }

        if (teamData == null) {
          if (kDebugMode) {
            debugPrint(
                'getTeamById: Could not extract team data from response');
          }
          return null;
        }

        if (kDebugMode) {
          debugPrint(
              'getTeamById: Parsing team data: id=${teamData['id']}, name=${teamData['name']}, image=${teamData['image']}');
        }

        return TeamModel.fromJson(teamData);
      } catch (e, stackTrace) {
        if (kDebugMode) {
          debugPrint('getTeamById: Error parsing response: $e');
          debugPrint('getTeamById: Stack trace: $stackTrace');
          debugPrint('getTeamById: Response data: ${response.data}');
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
