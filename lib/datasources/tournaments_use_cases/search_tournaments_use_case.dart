import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';
import 'package:jugaenequipo/datasources/models/models.dart';

/// Search tournaments with optional query parameters
///
/// Parameters:
/// - [upcoming]: If true, returns only upcoming tournaments
/// - [gameId]: Filter tournaments by game ID
/// - [region]: Filter tournaments by region
/// - [isOfficial]: Filter tournaments by official status
/// - [responsibleId]: Filter tournaments by responsible user ID
/// - [limit]: Maximum number of results to return
/// - [offset]: Number of results to skip for pagination
Future<List<TournamentModel>?> searchTournaments({
  bool? upcoming,
  String? gameId,
  String? region,
  bool? isOfficial,
  String? responsibleId,
  int? limit,
  int? offset,
}) async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');

    if (accessToken == null || accessToken.isEmpty) {
      if (kDebugMode) {
        debugPrint('searchTournaments: No access token found');
      }
      return null;
    }

    // Build query parameters
    final Map<String, dynamic> queryParams = {};
    if (upcoming != null) queryParams['upcoming'] = upcoming.toString();
    if (gameId != null) queryParams['gameId'] = gameId;
    if (region != null) queryParams['region'] = region;
    if (isOfficial != null) queryParams['isOfficial'] = isOfficial.toString();
    if (responsibleId != null) queryParams['responsibleId'] = responsibleId;
    if (limit != null) queryParams['limit'] = limit.toString();
    if (offset != null) queryParams['offset'] = offset.toString();

    final response = await APIService.instance.request(
      '/api/tournaments',
      DioMethod.get,
      param: queryParams.isNotEmpty ? queryParams : null,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    // Manage the response
    if (response.statusCode == 200) {
      if (kDebugMode) {
        debugPrint('searchTournaments: API call successful');
        debugPrint(
            'searchTournaments: Response data type: ${response.data.runtimeType}');
      }

      // Validate response structure
      if (response.data == null) {
        if (kDebugMode) {
          debugPrint('searchTournaments: Response data is null');
        }
        return null;
      }

      if (kDebugMode) {
        debugPrint(
            'searchTournaments: Response data keys: ${response.data.keys}');
      }

      final data = response.data['data'];
      if (data == null) {
        if (kDebugMode) {
          debugPrint('searchTournaments: Response data["data"] is null');
          debugPrint('searchTournaments: Full response: ${response.data}');
        }
        return null;
      }

      if (data is! List) {
        if (kDebugMode) {
          debugPrint(
              'searchTournaments: Response data["data"] is not a list, type: ${data.runtimeType}');
          debugPrint('searchTournaments: Data content: $data');
        }
        return null;
      }

      if (kDebugMode) {
        debugPrint(
            'searchTournaments: Found ${data.length} tournaments in response');
      }

      try {
        final tournaments = <TournamentModel>[];
        for (var i = 0; i < data.length; i++) {
          try {
            final tournamentData = data[i];
            if (kDebugMode && i == 0) {
              debugPrint(
                  'searchTournaments: Parsing tournament ${i + 1}, data: $tournamentData');
            }
            final tournament = TournamentModel.fromJson(
                tournamentData as Map<String, dynamic>);
            tournaments.add(tournament);
            if (kDebugMode && i == 0) {
              debugPrint(
                  'searchTournaments: Successfully parsed tournament: ${tournament.name}');
            }
          } catch (e, stackTrace) {
            if (kDebugMode) {
              debugPrint(
                  'searchTournaments: Error parsing tournament item ${i + 1}: $e');
              debugPrint('searchTournaments: Stack trace: $stackTrace');
              debugPrint('searchTournaments: Tournament data: ${data[i]}');
            }
            // Continue with next tournament instead of failing completely
          }
        }
        if (kDebugMode) {
          debugPrint(
              'searchTournaments: Successfully parsed ${tournaments.length} out of ${data.length} tournaments');
        }
        // Retornar la lista (puede estar vacía si todos fallaron al parsearse)
        return tournaments;
      } catch (e, stackTrace) {
        if (kDebugMode) {
          debugPrint('searchTournaments: Error parsing response: $e');
          debugPrint('searchTournaments: Stack trace: $stackTrace');
        }
        return null;
      }
    } else if (response.statusCode == 401) {
      // Unauthorized
      if (kDebugMode) {
        debugPrint('searchTournaments: Unauthorized - invalid token');
      }
      return null;
    } else {
      // Error: Manage the error response
      if (kDebugMode) {
        debugPrint(
            'searchTournaments: API call failed with status ${response.statusCode}: ${response.statusMessage}');
      }
      return null;
    }
  } catch (e) {
    // Error: Manage network errors
    if (kDebugMode) {
      debugPrint('searchTournaments: Network error occurred: $e');
    }
    return null;
  }
}
