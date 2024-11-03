class CommentModel {
  final String id;
  final String userId;
  final String? copy;
  final String? image;
  final String createdAt;
  final String updatedAt;
  final String deletedAt;

  CommentModel({
    required this.id,
    required this.userId,
    this.copy,
    this.image,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
        id: json['id'] as String,
        userId: json['userId'] as String,
        copy: json['copy'] as String,
        image: json['image'] as String,
        createdAt: json['createdAt'] as String,
        updatedAt: json['updatedAt'] as String,
        deletedAt: json['deletedAt'] as String);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'copy': copy,
      'image': image,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt
    };
  }
}
