import 'package:jugaenequipo/datasources/models/models.dart';

class TournamentModel {
  final String title;
  final bool isOfficial;
  final GameModel game;
  final List<UserModel>? registeredPlayers;

  TournamentModel({
    required this.title,
    required this.isOfficial,
    required this.game,
    this.registeredPlayers,
  });
}
