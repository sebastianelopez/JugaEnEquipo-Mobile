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
    // Parse games - API returns games with only id and name
    List<GameModel> gamesList = [];
    if (json['games'] != null && json['games'] is List) {
      gamesList = (json['games'] as List<dynamic>)
          .map((game) {
            // Handle games that may or may not have image field
            if (game is Map<String, dynamic>) {
              return GameModel(
                id: game['id'] as String,
                name: game['name'] as String,
                image: game['image'] as String? ?? '',
              );
            }
            return null;
          })
          .whereType<GameModel>()
          .toList();
    }

    return TeamModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      image: json['image'] as String?,
      creatorId: json['creatorId'] as String,
      leaderId: json['leaderId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      deletedAt: json['deletedAt'] != null 
          ? DateTime.parse(json['deletedAt'] as String) 
          : null,
      games: gamesList,
      // Backward compatibility fields
      membersIds: json['membersIds'] as List<String>?,
      verified: json['verified'] as bool?,
    );
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
