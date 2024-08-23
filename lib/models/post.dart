import 'package:jugaenequipo/models/models.dart';

class Post {
  final User user;
  final String postDate;
  final String? copy;
  final List<String>? images;
  final int likes;
  final int shares;
  final int comments;

  Post({
    required this.user,
    required this.postDate,
    this.copy,
    this.images,
    required this.likes,
    required this.comments,
    required this.shares,
  });
}
