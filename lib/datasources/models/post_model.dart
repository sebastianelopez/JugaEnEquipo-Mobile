import 'package:jugaenequipo/datasources/models/models.dart';

class PostModel {
  final String id;
  final UserModel? user;
  final String? copy;
  final List<ResourceModel>? resources;
  final int? likes;
  final int? shares;
  final int? comments;
  final String createdAt;
  final String? updatedAt;
  final String? deletedAt;

  PostModel({
    required this.id,
    this.user,
    this.copy,
    this.resources,
    this.likes,
    this.comments,
    this.shares,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] as String,
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      copy: json['body'] as String?,
      resources: json['resources'] != null
          ? (json['resources'] as List)
              .map((item) => ResourceModel.fromJson(item))
              .toList()
          : null,
      likes: json['likes'] as int?,
      shares: json['shares'] as int?,
      comments: json['comments'] as int?,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String?,
      deletedAt: json['deletedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user?.toJson(),
      'copy': copy,
      'resources': resources,
      'likes': likes,
      'shares': shares,
      'comments': comments,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt
    };
  }
}
