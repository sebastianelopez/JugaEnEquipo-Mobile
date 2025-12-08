import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';
import 'package:jugaenequipo/datasources/models/models.dart';

/// Search games with optional query parameters
///
/// Parameters:
/// - [limit]: Maximum number of results to return
/// - [offset]: Number of results to skip for pagination
Future<List<GameModel>?> searchGames({
  int? limit,
  int? offset,
}) async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');

    if (accessToken == null || accessToken.isEmpty) {
      if (kDebugMode) {
        debugPrint('searchGames: No access token found');
      }
      return null;
    }

    // Build query parameters
    final Map<String, dynamic> queryParams = {};
    if (limit != null) queryParams['limit'] = limit.toString();
    if (offset != null) queryParams['offset'] = offset.toString();

    final response = await APIService.instance.request(
      '/api/games',
      DioMethod.get,
      param: queryParams.isNotEmpty ? queryParams : null,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    // Manage the response
    if (response.statusCode == 200) {
      if (kDebugMode) {
        debugPrint('searchGames: API call successful');
      }

      // Validate response structure
      if (response.data == null) {
        if (kDebugMode) {
          debugPrint('searchGames: Response data is null');
        }
        return null;
      }

      final data = response.data['data'];
      if (data == null || data is! List) {
        if (kDebugMode) {
          debugPrint('searchGames: Response data is not a list');
        }
        return null;
      }

      try {
        final games = data
            .map((game) => GameModel.fromJson(game as Map<String, dynamic>))
            .toList();
        return games;
      } catch (e) {
        if (kDebugMode) {
          debugPrint('searchGames: Error parsing response: $e');
        }
        return null;
      }
    } else if (response.statusCode == 401) {
      // Unauthorized
      if (kDebugMode) {
        debugPrint('searchGames: Unauthorized - invalid token');
      }
      return null;
    } else {
      // Error: Manage the error response
      if (kDebugMode) {
        debugPrint(
            'searchGames: API call failed with status ${response.statusCode}: ${response.statusMessage}');
      }
      return null;
    }
  } catch (e) {
    // Error: Manage network errors
    if (kDebugMode) {
      debugPrint('searchGames: Network error occurred: $e');
    }
    return null;
  }
}


