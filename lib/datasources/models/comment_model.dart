import 'package:jugaenequipo/datasources/models/models.dart';

class CommentModel {
  final UserModel user;
  final String? copy;
  final String? image;
  final String createdAt;
  final String updatedAt;
  final String deletedAt;

  CommentModel({
    required this.user,
    this.copy,
    this.image,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });
}
