import 'package:jugaenequipo/models/models.dart';

class User {
  final String id;
  final String firstName;
  final String lastName;
  final String userName;
  final Team? team;
  final String email;
  final String? profileImage;

  User(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.userName,
      this.team,
      required this.email,
      this.profileImage});
}
