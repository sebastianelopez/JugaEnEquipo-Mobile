import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';

/// Decline a team request
/// 
/// Parameters:
/// - [requestId]: The ID of the request to decline
Future<Result> declineTeamRequest(String requestId) async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');

    if (accessToken == null || accessToken.isEmpty) {
      if (kDebugMode) {
        debugPrint('declineTeamRequest: No access token found');
      }
      return Result.error;
    }

    final response = await APIService.instance.request(
      '/api/team/request/$requestId/decline',
      DioMethod.put,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      if (kDebugMode) {
        debugPrint('declineTeamRequest: API call successful');
      }
      return Result.success;
    } else if (response.statusCode == 401) {
      if (kDebugMode) {
        debugPrint('declineTeamRequest: Unauthorized - invalid token');
      }
      return Result.unauthorized;
    } else {
      if (kDebugMode) {
        debugPrint(
            'declineTeamRequest: API call failed with status ${response.statusCode}: ${response.statusMessage}');
      }
      return Result.error;
    }
  } catch (e) {
    if (kDebugMode) {
      debugPrint('declineTeamRequest: Network error occurred: $e');
    }
    return Result.error;
  }
}

