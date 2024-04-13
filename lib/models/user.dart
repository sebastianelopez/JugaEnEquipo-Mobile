import 'package:jugaenequipo/models/models.dart';

class User {
  final String name;
  final Team? team;
  final String mail;
  final String? profileImage;

  User({required this.name, this.team, required this.mail, this.profileImage});
}
