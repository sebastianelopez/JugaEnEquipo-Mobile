import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';

/// Accept a team request
/// 
/// Parameters:
/// - [requestId]: The ID of the request to accept
Future<Result> acceptTeamRequest(String requestId) async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');

    if (accessToken == null || accessToken.isEmpty) {
      if (kDebugMode) {
        debugPrint('acceptTeamRequest: No access token found');
      }
      return Result.error;
    }

    final response = await APIService.instance.request(
      '/api/team/request/$requestId/accept',
      DioMethod.put,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      if (kDebugMode) {
        debugPrint('acceptTeamRequest: API call successful');
      }
      return Result.success;
    } else if (response.statusCode == 401) {
      if (kDebugMode) {
        debugPrint('acceptTeamRequest: Unauthorized - invalid token');
      }
      return Result.unauthorized;
    } else {
      if (kDebugMode) {
        debugPrint(
            'acceptTeamRequest: API call failed with status ${response.statusCode}: ${response.statusMessage}');
      }
      return Result.error;
    }
  } catch (e) {
    if (kDebugMode) {
      debugPrint('acceptTeamRequest: Network error occurred: $e');
    }
    return Result.error;
  }
}

