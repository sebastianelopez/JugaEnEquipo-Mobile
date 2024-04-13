import 'package:jugaenequipo/models/models.dart';

class Comment {
  final User user;
  final String? copy;
  final String? image;
  final String commentDate;

  Comment(
      {required this.user, this.copy, this.image, required this.commentDate});
}
