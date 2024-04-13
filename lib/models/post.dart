import 'package:jugaenequipo/models/models.dart';

class Post {
  final User user;
  final String postDate;
  final String? copy;
  final String? image;
  int likes = 0;
  final List<Comment> comments;

  Post(
      {required this.user,
      required this.postDate,
      this.copy,
      this.image,
      required this.likes,
      required this.comments});
}
