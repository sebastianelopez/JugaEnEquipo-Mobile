class CommentModel {
  final String id;
  final String? user;
  //final String? userImage;
  final String? copy;
  //final String? image;
  final String createdAt;
  final String? updatedAt;
  final String? deletedAt;

  CommentModel({
    required this.id,
    required this.user,
    this.copy,
    //this.image,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] as String,
      user: json['user'] as String,
      copy: json['comment'] as String,
      //image: json['image'] as String,
      createdAt: json['createdAt'] as String,
      // updatedAt: json['updatedAt'] as String,
      // deletedAt: json['deletedAt'] as String
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user,
      'comment': copy,
      //'image': image,
      'createdAt': createdAt,
      //'updatedAt': updatedAt,
      //'deletedAt': deletedAt
    };
  }
}
