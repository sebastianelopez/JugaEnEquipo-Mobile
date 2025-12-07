import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';
import 'package:jugaenequipo/datasources/models/models.dart';

/// Get all tournament requests
///
/// Optional parameters:
/// - [tournamentId]: Filter requests by tournament ID
/// - [teamId]: Filter requests by team ID
Future<List<TournamentRequestModel>?> getTournamentRequests({
  String? tournamentId,
  String? teamId,
}) async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');

    if (accessToken == null || accessToken.isEmpty) {
      if (kDebugMode) {
        debugPrint('getTournamentRequests: No access token found');
      }
      return null;
    }

    final Map<String, dynamic> queryParams = {};
    if (tournamentId != null) queryParams['tournamentId'] = tournamentId;
    if (teamId != null) queryParams['teamId'] = teamId;

    final response = await APIService.instance.request(
      '/api/tournament/requests',
      DioMethod.get,
      param: queryParams.isNotEmpty ? queryParams : null,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      if (kDebugMode) {
        debugPrint('getTournamentRequests: API call successful');
      }

      if (response.data == null) {
        if (kDebugMode) {
          debugPrint('getTournamentRequests: Response data is null');
        }
        return null;
      }

      // The API returns {requests: [...]} instead of {data: [...]}
      final data = response.data['requests'] ?? response.data['data'];
      if (data == null || data is! List) {
        if (kDebugMode) {
          debugPrint('getTournamentRequests: Response data is not a list');
          debugPrint(
              'getTournamentRequests: Response structure: ${response.data}');
        }
        return null;
      }

      try {
        final requests = data
            .map((request) => TournamentRequestModel.fromJson(
                request as Map<String, dynamic>))
            .toList();
        return requests;
      } catch (e) {
        if (kDebugMode) {
          debugPrint('getTournamentRequests: Error parsing response: $e');
        }
        return null;
      }
    } else {
      if (kDebugMode) {
        debugPrint(
            'getTournamentRequests: API call failed with status ${response.statusCode}');
      }
      return null;
    }
  } catch (e) {
    if (kDebugMode) {
      debugPrint('getTournamentRequests: Network error occurred: $e');
    }
    return null;
  }
}
