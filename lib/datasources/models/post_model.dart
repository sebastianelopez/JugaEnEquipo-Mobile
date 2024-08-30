import 'package:jugaenequipo/datasources/models/models.dart';

class PostModel {
  final UserModel user;
  final String postDate;
  final String? copy;
  final List<String>? images;
  final int likes;
  final int shares;
  final int comments;

  PostModel({
    required this.user,
    required this.postDate,
    this.copy,
    this.images,
    required this.likes,
    required this.comments,
    required this.shares,
  });
}
