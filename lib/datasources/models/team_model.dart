import 'package:flutter/foundation.dart';
import 'package:jugaenequipo/datasources/models/models.dart';

class TeamModel {
  final String id;
  final String name;
  final String? description;
  final String? image;
  final String creatorId;
  final String leaderId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final List<GameModel> games;

  // Optional fields for backward compatibility
  final List<String>? membersIds;
  final bool? verified;

  TeamModel({
    required this.id,
    required this.name,
    this.description,
    this.image,
    required this.creatorId,
    required this.leaderId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.games,
    this.membersIds,
    this.verified,
  });

  factory TeamModel.fromJson(Map<String, dynamic> json) {
    // Parse games - API returns games with id, name, description, minPlayersQuantity, maxPlayersQuantity, createdAt
    List<GameModel> gamesList = [];
    if (json['games'] != null) {
      try {
        if (json['games'] is List) {
          final gamesData = json['games'] as List<dynamic>;
          gamesList = [];

          for (var i = 0; i < gamesData.length; i++) {
            try {
              final gameData = gamesData[i];
              if (gameData is Map<String, dynamic>) {
                // Use GameModel.fromJson to properly parse all fields
                gamesList.add(GameModel.fromJson(gameData));
              }
            } catch (e) {
              // Skip invalid game entry, log error
              debugPrint(
                  'TeamModel.fromJson: Error parsing game at index $i: $e');
              continue;
            }
          }
        }
      } catch (e, stackTrace) {
        // If parsing games fails, use empty list
        debugPrint('TeamModel.fromJson: Error parsing games list: $e');
        debugPrint('TeamModel.fromJson: Stack trace: $stackTrace');
        gamesList = [];
      }
    }

    // Parse membersIds safely - handle various formats
    List<String>? membersIdsList;
    if (json['membersIds'] != null) {
      try {
        if (json['membersIds'] is List) {
          membersIdsList = (json['membersIds'] as List<dynamic>)
              .map((id) {
                try {
                  return id.toString();
                } catch (e) {
                  return null;
                }
              })
              .whereType<String>()
              .toList();
        } else if (json['membersIds'] is Map) {
          // Handle case where membersIds might be a Map with string keys
          final membersMap = json['membersIds'] as Map;
          membersIdsList = membersMap.values.map((v) => v.toString()).toList();
        }
      } catch (e) {
        membersIdsList = null;
      }
    }

    try {
      return TeamModel(
        id: json['id']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        description: json['description']?.toString(),
        image: json['image']?.toString(),
        creatorId: json['creatorId']?.toString() ?? '',
        leaderId: json['leaderId']?.toString() ?? '',
        createdAt: DateTime.parse(
            json['createdAt']?.toString() ?? DateTime.now().toIso8601String()),
        updatedAt: DateTime.parse(
            json['updatedAt']?.toString() ?? DateTime.now().toIso8601String()),
        deletedAt: json['deletedAt'] != null
            ? DateTime.tryParse(json['deletedAt']?.toString() ?? '')
            : null,
        games: gamesList,
        // Backward compatibility fields
        membersIds: membersIdsList,
        verified: json['verified'] is bool ? json['verified'] as bool? : null,
      );
    } catch (e, stackTrace) {
      // Log the error with full context
      debugPrint('TeamModel.fromJson error: $e');
      debugPrint('TeamModel.fromJson stackTrace: $stackTrace');
      debugPrint('TeamModel.fromJson json keys: ${json.keys.toList()}');
      debugPrint('TeamModel.fromJson json: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      if (description != null) 'description': description,
      if (image != null) 'image': image,
      'creatorId': creatorId,
      'leaderId': leaderId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      if (deletedAt != null) 'deletedAt': deletedAt!.toIso8601String(),
      'games': games.map((game) => game.toJson()).toList(),
      if (membersIds != null) 'membersIds': membersIds,
      if (verified != null) 'verified': verified,
    };
  }

  // Getters for backward compatibility
  String? get teamImage => image;
}
