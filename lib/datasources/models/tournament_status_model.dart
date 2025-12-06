class TournamentStatusModel {
  final String id;
  final String name;

  TournamentStatusModel({
    required this.id,
    required this.name,
  });

  factory TournamentStatusModel.fromJson(Map<String, dynamic> json) {
    return TournamentStatusModel(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
