import 'package:jugaenequipo/datasources/models/models.dart';

class TeamModel {
  final String id;
  final String name;
  final List<String> membersIds;
  final String? teamImage;
  final GameModel game;
  final bool verified;

  TeamModel({
    required this.id,
    required this.name,
    required this.membersIds,
    this.teamImage,
    required this.game,
    required this.verified,
  });

  factory TeamModel.fromJson(Map<String, dynamic> json) {
    return TeamModel(
        id: json['id'] as String,
        name: json['name'] as String,
        membersIds: json['membersIds'] as List<String>,
        teamImage:
            json['teamImage'] != null ? json['teamImage'] as String : null,
        game: GameModel.fromJson(json['game']),
        verified: json['verified'] as bool);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'membersIds': membersIds,
      'teamImage': teamImage,
      'verified': verified,
    };
  }
}
