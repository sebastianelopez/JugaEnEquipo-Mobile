import 'package:flutter/foundation.dart';

class GameModel {
  final String id;
  final String name;
  final String? image;
  final String? description;
  final int? minPlayersQuantity;
  final int? maxPlayersQuantity;
  final String? createdAt;

  GameModel({
    required this.id,
    required this.name,
    this.image,
    this.description,
    this.minPlayersQuantity,
    this.maxPlayersQuantity,
    this.createdAt,
  });

  factory GameModel.fromJson(Map<String, dynamic> json) {
    try {
      return GameModel(
        id: json['id']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        image: json['image']?.toString(),
        description: json['description']?.toString(),
        minPlayersQuantity: json['minPlayersQuantity'] is int
            ? json['minPlayersQuantity'] as int
            : (json['minPlayersQuantity'] is String
                ? int.tryParse(json['minPlayersQuantity'] as String)
                : null),
        maxPlayersQuantity: json['maxPlayersQuantity'] is int
            ? json['maxPlayersQuantity'] as int
            : (json['maxPlayersQuantity'] is String
                ? int.tryParse(json['maxPlayersQuantity'] as String)
                : null),
        createdAt: json['createdAt']?.toString(),
      );
    } catch (e, stackTrace) {
      debugPrint('GameModel.fromJson error: $e');
      debugPrint('GameModel.fromJson stackTrace: $stackTrace');
      debugPrint('GameModel.fromJson json: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      if (image != null) 'image': image,
      if (description != null) 'description': description,
      if (minPlayersQuantity != null) 'minPlayersQuantity': minPlayersQuantity,
      if (maxPlayersQuantity != null) 'maxPlayersQuantity': maxPlayersQuantity,
      if (createdAt != null) 'createdAt': createdAt,
    };
  }
}
