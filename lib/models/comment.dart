import 'package:jugaenequipo/models/models.dart';

class Comment {
  final User user;
  final String? copy;
  final String? image;
  final String createdAt;
  final String updatedAt;
  final String deletedAt;

  Comment({
    required this.user,
    this.copy,
    this.image,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });
}
