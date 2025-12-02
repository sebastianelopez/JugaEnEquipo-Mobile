import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';
import 'package:jugaenequipo/datasources/models/models.dart';

/// Search teams with optional query parameters
///
/// Parameters:
/// - [userId]: Filter teams by user ID (member, creator, or leader)
/// - [mine]: If true, returns only teams where the current user is a member
/// - [gameId]: Filter teams by game ID
/// - [tournamentId]: Filter teams by tournament ID
/// - [leaderId]: Filter teams by leader ID
/// - [creatorId]: Filter teams by creator ID
/// - [limit]: Maximum number of results to return
/// - [offset]: Number of results to skip (for pagination)
Future<List<TeamModel>?> searchTeams({
  String? name,
  String? userId,
  bool? mine,
  String? gameId,
  String? tournamentId,
  String? leaderId,
  String? creatorId,
  int? limit,
  int? offset,
}) async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');

    if (accessToken == null || accessToken.isEmpty) {
      if (kDebugMode) {
        debugPrint('searchTeams: No access token found');
      }
      return null;
    }

    // Build query parameters
    final Map<String, dynamic> queryParams = {};
    if (userId != null) queryParams['userId'] = userId;
    if (mine != null) queryParams['mine'] = mine.toString();
    if (gameId != null) queryParams['gameId'] = gameId;
    if (tournamentId != null) queryParams['tournamentId'] = tournamentId;
    if (leaderId != null) queryParams['leaderId'] = leaderId;
    if (creatorId != null) queryParams['creatorId'] = creatorId;
    if (limit != null) queryParams['limit'] = limit;
    if (offset != null) queryParams['offset'] = offset;
    if (name != null) queryParams['name'] = name;

    final response = await APIService.instance.request(
      '/api/teams',
      DioMethod.get,
      param: queryParams.isNotEmpty ? queryParams : null,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    // Manage the response
    if (response.statusCode == 200) {
      if (kDebugMode) {
        debugPrint('searchTeams: API call successful');
      }

      // Validate response structure
      if (response.data == null) {
        if (kDebugMode) {
          debugPrint('searchTeams: Response data is null');
        }
        return null;
      }

      final data = response.data['data'];
      if (data == null || data is! List) {
        if (kDebugMode) {
          debugPrint('searchTeams: Response data is not a list');
        }
        return null;
      }

      try {
        final teams = data
            .map((team) => TeamModel.fromJson(team as Map<String, dynamic>))
            .toList();
        return teams;
      } catch (e) {
        if (kDebugMode) {
          debugPrint('searchTeams: Error parsing response: $e');
        }
        return null;
      }
    } else if (response.statusCode == 401) {
      // Unauthorized
      if (kDebugMode) {
        debugPrint('searchTeams: Unauthorized - invalid token');
      }
      return null;
    } else {
      // Error: Manage the error response
      if (kDebugMode) {
        debugPrint(
            'searchTeams: API call failed with status ${response.statusCode}: ${response.statusMessage}');
      }
      return null;
    }
  } catch (e) {
    // Error: Manage network errors
    if (kDebugMode) {
      debugPrint('searchTeams: Network error occurred: $e');
    }
    return null;
  }
}
