import 'package:jugaenequipo/datasources/models/models.dart';

class TeamModel {
  final String name;
  final List<UserModel> members;

  TeamModel({
    required this.name,
    required this.members,
  });
}
