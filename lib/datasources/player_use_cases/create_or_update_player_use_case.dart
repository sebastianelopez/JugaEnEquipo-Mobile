import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:uuid/uuid.dart';

var uuid = const Uuid();

/// Creates or updates a player profile
///
/// [playerId] - The ID of the player profile (use UUID for new profiles)
/// [gameId] - The ID of the game
/// [gameRoleIds] - List of game role IDs (optional)
/// [accountData] - Account data (steamId for Steam, or region/username/tag for RIOT)
Future<Result> createOrUpdatePlayer({
  required String playerId,
  required String gameId,
  List<String>? gameRoleIds,
  AccountData? accountData,
}) async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');

    final Map<String, dynamic> body = {
      'gameId': gameId,
      'gameRoleIds': gameRoleIds ?? [],
    };

    if (accountData != null) {
      body['accountData'] = accountData.toJson();
    }

    final response = await APIService.instance.request(
      '/api/player/$playerId',
      DioMethod.put,
      param: body,
      contentType: 'application/json',
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (kDebugMode) {
        debugPrint(
            'createOrUpdatePlayer - API call successful: ${response.data}');
      }
      return Result.success;
    } else {
      if (kDebugMode) {
        debugPrint(
            'createOrUpdatePlayer - API call failed: ${response.statusMessage}');
        debugPrint('createOrUpdatePlayer - Response: ${response.data}');
      }
      return Result.error;
    }
  } catch (e) {
    if (kDebugMode) {
      debugPrint('createOrUpdatePlayer - Network error occurred: $e');
    }
    return Result.error;
  }
}
