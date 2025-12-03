import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';
import 'package:jugaenequipo/datasources/models/models.dart';

/// Get all requests for a team
/// 
/// Parameters:
/// - [teamId]: The ID of the team
Future<List<TeamRequestModel>?> getTeamRequests(String teamId) async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');

    if (accessToken == null || accessToken.isEmpty) {
      if (kDebugMode) {
        debugPrint('getTeamRequests: No access token found');
      }
      return null;
    }

    final response = await APIService.instance.request(
      '/api/team/requests',
      DioMethod.get,
      param: {'teamId': teamId},
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      if (kDebugMode) {
        debugPrint('getTeamRequests: API call successful');
      }

      if (response.data == null) {
        if (kDebugMode) {
          debugPrint('getTeamRequests: Response data is null');
        }
        return null;
      }

      // API returns { "requests": [...] }
      final data = response.data['requests'] ?? response.data['data'];
      if (data == null || data is! List) {
        if (kDebugMode) {
          debugPrint('getTeamRequests: Response data is not a list. Response structure: ${response.data}');
        }
        return null;
      }

      try {
        final requests = data
            .map((request) =>
                TeamRequestModel.fromJson(request as Map<String, dynamic>))
            .toList();
        
        if (kDebugMode) {
          debugPrint('getTeamRequests: Successfully parsed ${requests.length} requests');
        }
        
        return requests;
      } catch (e) {
        if (kDebugMode) {
          debugPrint('getTeamRequests: Error parsing response: $e');
        }
        return null;
      }
    } else {
      if (kDebugMode) {
        debugPrint(
            'getTeamRequests: API call failed with status ${response.statusCode}: ${response.statusMessage}');
      }
      return null;
    }
  } catch (e) {
    if (kDebugMode) {
      debugPrint('getTeamRequests: Network error occurred: $e');
    }
    return null;
  }
}

