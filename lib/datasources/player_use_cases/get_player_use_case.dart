import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';
import 'package:jugaenequipo/datasources/models/models.dart';

/// Gets a player profile by ID
Future<PlayerModel?> getPlayerById(String playerId) async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');

    final response = await APIService.instance.request(
      '/api/player/$playerId',
      DioMethod.get,
      contentType: 'application/json',
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      if (kDebugMode) {
        debugPrint('getPlayerById - API call successful: ${response.data}');
      }
      if (response.data['data'] != null) {
        return PlayerModel.fromJson(response.data['data'] as Map<String, dynamic>);
      }
      return null;
    } else {
      if (kDebugMode) {
        debugPrint('getPlayerById - API call failed: ${response.statusMessage}');
      }
      return null;
    }
  } catch (e) {
    if (kDebugMode) {
      debugPrint('getPlayerById - Network error occurred: $e');
    }
    return null;
  }
}

