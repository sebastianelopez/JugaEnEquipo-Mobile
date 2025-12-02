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
    return GameModel(
      id: json['id'] as String,
      name: json['name'] as String,
      image: json['image'] as String?,
      description: json['description'] as String?,
      minPlayersQuantity: json['minPlayersQuantity'] as int?,
      maxPlayersQuantity: json['maxPlayersQuantity'] as int?,
      createdAt: json['createdAt'] as String?,
    );
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
