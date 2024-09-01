class GameModel {
  final String id;
  final String name;
  final String image;

  GameModel({
    required this.id,
    required this.name,
    required this.image,
  });

  factory GameModel.fromJson(Map<String, dynamic> json) {
    return GameModel(
        id: json['id'] as String,
        name: json['name'] as String,
        image: json['image'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'image': image};
  }
}
