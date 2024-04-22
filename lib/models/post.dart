import 'package:jugaenequipo/models/models.dart';

class Post {
  final User user;
  final String postDate;
  final String? copy;
  final String? image;
  final List<User> peopleWhoLikeIt;
  final List<Comment> comments;

  Post(
      {required this.user,
      required this.postDate,
      this.copy,
      this.image,
      required this.peopleWhoLikeIt,
      required this.comments});
}
