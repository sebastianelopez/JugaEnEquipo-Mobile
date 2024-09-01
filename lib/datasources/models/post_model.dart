import 'package:jugaenequipo/datasources/models/models.dart';

class PostModel {
  final String id;
  final UserModel user;
  final String postDate;
  final String? copy;
  final List<String>? images;
  final int likes;
  final int shares;
  final int comments;

  PostModel({
    required this.id,
    required this.user,
    required this.postDate,
    this.copy,
    this.images,
    required this.likes,
    required this.comments,
    required this.shares,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
        id: json['id'] as String,
        user: json['user'] as UserModel,
        postDate: json['postDate'] as String,
        copy: json['copy'] as String,
        images: json['images'] as List<String>,
        likes: json['likes'] as int,
        shares: json['shares'] as int,
        comments: json['comments'] as int);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user,
      'postDate': postDate,
      'copy': copy,
      'images': images,
      'likes': likes,
      'shares': shares,
      'comments': comments
    };
  }
}
