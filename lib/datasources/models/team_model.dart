import 'package:jugaenequipo/datasources/models/models.dart';

class TeamModel {
  final String id;
  final String name;
  final List<String> membersIds;
  final String? teamImage;
  final List<GameModel> games;
  final bool verified;

  TeamModel({
    required this.id,
    required this.name,
    required this.membersIds,
    this.teamImage,
    required this.games,
    required this.verified,
  });

  factory TeamModel.fromJson(Map<String, dynamic> json) {
    return TeamModel(
        id: json['id'] as String,
        name: json['name'] as String,
        membersIds: json['membersIds'] as List<String>,
        teamImage:
            json['teamImage'] != null ? json['teamImage'] as String : null,
        games: (json['games'] as List<dynamic>)
            .map((game) => GameModel.fromJson(game))
            .toList(),
        verified: json['verified'] as bool);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'membersIds': membersIds,
      'teamImage': teamImage,
      'games': games.map((game) => game.toJson()).toList(),
      'verified': verified,
    };
  }
}
