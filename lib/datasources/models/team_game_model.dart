class TeamGameModel {
  final String id;
  final String teamId;
  final String gameId;
  final String gameName;
  final DateTime addedAt;

  TeamGameModel({
    required this.id,
    required this.teamId,
    required this.gameId,
    required this.gameName,
    required this.addedAt,
  });

  factory TeamGameModel.fromJson(Map<String, dynamic> json) {
    return TeamGameModel(
      id: json['id'] as String,
      teamId: json['teamId'] as String,
      gameId: json['gameId'] as String,
      gameName: json['gameName'] as String,
      addedAt: DateTime.parse(json['addedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'teamId': teamId,
      'gameId': gameId,
      'gameName': gameName,
      'addedAt': addedAt.toIso8601String(),
    };
  }
}

