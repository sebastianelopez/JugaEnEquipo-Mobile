import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:jugaenequipo/utils/utils.dart';

/// Get teams with optional pagination parameters
///
/// Parameters:
/// - [limit]: Maximum number of results to return
/// - [offset]: Number of results to skip for pagination
Future<List<TeamModel>?> getInitialTeams({
  int? limit,
  int? offset,
}) async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');

    if (accessToken == null || accessToken.isEmpty) {
      if (kDebugMode) {
        debugPrint('getInitialTeams: No access token found');
      }
      return null;
    }

    // Build query parameters
    final Map<String, dynamic> queryParams = {};
    if (limit != null) queryParams['limit'] = limit.toString();
    if (offset != null) queryParams['offset'] = offset.toString();

    final response = await APIService.instance.request(
      '/api/teams',
      DioMethod.get,
      param: queryParams.isNotEmpty ? queryParams : null,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    // Manage data
    if (response.statusCode == 200) {
      debugLog(
          'getInitialTeams - API call successful: ${response.data['data']}');

      // Validate response structure
      if (response.data == null) {
        if (kDebugMode) {
          debugPrint('getInitialTeams: Response data is null');
        }
        return null;
      }

      final data = response.data['data'];

      // Debug: Check if data is a list
      if (data is List) {
        debugLog('Data is a list');
        try {
          final teams = data
              .map((team) => TeamModel.fromJson(team as Map<String, dynamic>))
              .toList();
          debugLog('Parsed teams: $teams');
          return teams;
        } catch (e) {
          if (kDebugMode) {
            debugPrint('getInitialTeams: Error parsing teams: $e');
          }
          return null;
        }
      } else {
        debugLog('Data is not a list');
        return null;
      }
    } else if (response.statusCode == 401) {
      // Unauthorized
      if (kDebugMode) {
        debugPrint('getInitialTeams: Unauthorized - invalid token');
      }
      return null;
    } else {
      // Error: Manage error response
      debugLog(
          'getInitialTeams - API call failed with status ${response.statusCode}: ${response.statusMessage}');
      return null;
    }
  } catch (e) {
    // Error: Manage network errors
    debugLog('getInitialTeams - Network error occurred: $e');
    return null;
  }
}
