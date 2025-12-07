import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';

class GameRankModel {
  final String id;
  final String rankId;
  final String rankName;
  final String? rankDescription;
  final int level;

  GameRankModel({
    required this.id,
    required this.rankId,
    required this.rankName,
    this.rankDescription,
    required this.level,
  });

  factory GameRankModel.fromJson(Map<String, dynamic> json) {
    return GameRankModel(
      id: json['id'] as String,
      rankId: json['rankId'] as String,
      rankName: json['rankName'] as String,
      rankDescription: json['rankDescription'] as String?,
      level: json['level'] as int,
    );
  }
}

/// Get ranks for a specific game
///
/// Parameters:
/// - [gameId]: The ID of the game
Future<List<GameRankModel>?> getGameRanks({
  required String gameId,
}) async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');

    if (accessToken == null || accessToken.isEmpty) {
      if (kDebugMode) {
        debugPrint('getGameRanks: No access token found');
      }
      return null;
    }

    final response = await APIService.instance.request(
      '/api/game/$gameId/ranks',
      DioMethod.get,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      if (kDebugMode) {
        debugPrint('getGameRanks: API call successful');
      }

      if (response.data == null) {
        if (kDebugMode) {
          debugPrint('getGameRanks: Response data is null');
        }
        return null;
      }

      final data = response.data['data'];
      if (data == null || data is! List) {
        if (kDebugMode) {
          debugPrint('getGameRanks: Response data is not a list');
        }
        return null;
      }

      try {
        final ranks = data
            .map((rank) => GameRankModel.fromJson(rank as Map<String, dynamic>))
            .toList();

        // Sort by level
        ranks.sort((a, b) => a.level.compareTo(b.level));

        return ranks;
      } catch (e) {
        if (kDebugMode) {
          debugPrint('getGameRanks: Error parsing response: $e');
        }
        return null;
      }
    } else {
      if (kDebugMode) {
        debugPrint(
            'getGameRanks: API call failed with status ${response.statusCode}');
      }
      return null;
    }
  } catch (e) {
    if (kDebugMode) {
      debugPrint('getGameRanks: Network error occurred: $e');
    }
    return null;
  }
}
