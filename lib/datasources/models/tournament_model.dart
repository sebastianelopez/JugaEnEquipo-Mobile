import 'package:jugaenequipo/datasources/models/models.dart';

class TournamentModel {
  final String id;
  final String title;
  final bool isOfficial;
  final GameModel game;
  final List<String>? registeredPlayersIds;

  TournamentModel({
    required this.id,
    required this.title,
    required this.isOfficial,
    required this.game,
    this.registeredPlayersIds,
  });

  factory TournamentModel.fromJson(Map<String, dynamic> json) {
    return TournamentModel(
        id: json['id'] as String,
        title: json['title'] as String,
        isOfficial: json['isOfficial'] as bool,
        game: json['game'] as GameModel,
        registeredPlayersIds: json['registeredPlayersIds'] as List<String>);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isOfficial': isOfficial,
      'game': game,
      'registeredPlayersIds': registeredPlayersIds
    };
  }
}
