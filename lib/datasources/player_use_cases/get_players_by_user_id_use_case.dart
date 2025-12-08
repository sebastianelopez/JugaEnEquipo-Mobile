import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';
import 'package:jugaenequipo/datasources/models/models.dart';

/// Gets all player profiles for a specific user
Future<List<PlayerModel>?> getPlayersByUserId(String userId) async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');

    final response = await APIService.instance.request(
      '/api/players',
      DioMethod.get,
      param: {'userId': userId},
      contentType: 'application/json',
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      if (kDebugMode) {
        debugPrint('getPlayersByUserId - API call successful: ${response.data}');
      }
      if (response.data['data'] != null) {
        final data = response.data['data'] as List;
        return data
            .map((json) => PlayerModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      return [];
    } else {
      if (kDebugMode) {
        debugPrint('getPlayersByUserId - API call failed: ${response.statusMessage}');
      }
      return null;
    }
  } catch (e) {
    if (kDebugMode) {
      debugPrint('getPlayersByUserId - Network error occurred: $e');
    }
    return null;
  }
}

