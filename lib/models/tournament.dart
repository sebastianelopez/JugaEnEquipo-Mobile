import 'package:jugaenequipo/models/models.dart';

class Tournament {
  final String title;
  final bool isOfficial;
  final Game game;
  final List<User>? registeredPlayers;

  Tournament({
    required this.title,
    required this.isOfficial,
    required this.game,
    this.registeredPlayers,
  });
}
