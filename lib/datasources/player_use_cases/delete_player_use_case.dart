import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';

/// Deletes a player profile
Future<Result> deletePlayer(String playerId) async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');

    final response = await APIService.instance.request(
      '/api/player/$playerId',
      DioMethod.delete,
      contentType: 'application/json',
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      if (kDebugMode) {
        debugPrint('deletePlayer - API call successful');
      }
      return Result.success;
    } else {
      if (kDebugMode) {
        debugPrint('deletePlayer - API call failed: ${response.statusMessage}');
      }
      return Result.error;
    }
  } catch (e) {
    if (kDebugMode) {
      debugPrint('deletePlayer - Network error occurred: $e');
    }
    return Result.error;
  }
}

