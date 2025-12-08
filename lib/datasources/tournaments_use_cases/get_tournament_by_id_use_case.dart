import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';
import 'package:jugaenequipo/datasources/models/models.dart';

/// Get a tournament by its ID
Future<TournamentModel?> getTournamentById(String tournamentId) async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');

    if (accessToken == null || accessToken.isEmpty) {
      if (kDebugMode) {
        debugPrint('getTournamentById: No access token found');
      }
      return null;
    }

    final response = await APIService.instance.request(
      '/api/tournament/$tournamentId',
      DioMethod.get,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    // Manage the response
    if (response.statusCode == 200) {
      if (kDebugMode) {
        debugPrint('getTournamentById: API call successful');
        debugPrint('getTournamentById: Response data: ${response.data}');
      }

      // Validate response structure
      if (response.data == null) {
        if (kDebugMode) {
          debugPrint('getTournamentById: Response data is null');
        }
        return null;
      }

      try {
        // Try to get data from 'data' field first, otherwise use response.data directly
        final tournamentData = response.data is Map<String, dynamic> &&
                response.data.containsKey('data')
            ? response.data['data'] as Map<String, dynamic>
            : response.data as Map<String, dynamic>;

        if (kDebugMode) {
          debugPrint(
              'getTournamentById: Parsing tournament data: $tournamentData');
        }

        return TournamentModel.fromJson(tournamentData);
      } catch (e, stackTrace) {
        if (kDebugMode) {
          debugPrint('getTournamentById: Error parsing response: $e');
          debugPrint('getTournamentById: Stack trace: $stackTrace');
        }
        return null;
      }
    } else if (response.statusCode == 401) {
      // Unauthorized
      if (kDebugMode) {
        debugPrint('getTournamentById: Unauthorized - invalid token');
      }
      return null;
    } else if (response.statusCode == 404) {
      // Not found
      if (kDebugMode) {
        debugPrint('getTournamentById: Tournament not found');
      }
      return null;
    } else {
      // Error: Manage the error response
      if (kDebugMode) {
        debugPrint(
            'getTournamentById: API call failed with status ${response.statusCode}: ${response.statusMessage}');
      }
      return null;
    }
  } catch (e) {
    // Error: Manage network errors
    if (kDebugMode) {
      debugPrint('getTournamentById: Network error occurred: $e');
    }
    return null;
  }
}
