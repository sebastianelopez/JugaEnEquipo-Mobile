import 'package:flutter/foundation.dart';

class CommentModel {
  final String id;
  final String? userId;
  final String? username;
  final String? profileImage;
  final String? comment;
  final String createdAt;
  final String? updatedAt;
  final String? deletedAt;

  CommentModel({
    required this.id,
    this.userId,
    this.username,
    this.profileImage,
    this.comment,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    try {
      return CommentModel(
        id: json['id']?.toString() ?? '',
        userId: json['userId']?.toString(),
        username: json['username']?.toString(),
        profileImage: json['profileImage']?.toString(),
        comment: json['comment']?.toString(),
        createdAt: json['createdAt']?.toString() ?? '',
        updatedAt: json['updatedAt']?.toString(),
        deletedAt: json['deletedAt']?.toString(),
      );
    } catch (e) {
      debugPrint('Error parsing CommentModel: $e');
      debugPrint('JSON data: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'username': username,
      'profileImage': profileImage,
      'comment': comment,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt,
    };
  }
}
