import 'package:jugaenequipo/datasources/models/models.dart';

class NotificationModel {
  final String id;
  final String type;
  final String userId;
  final String username;
  final String? postId;
  final String? message;
  final String date;
  final bool isNotificationRead;

  NotificationModel({
    required this.id,
    required this.type,
    required this.userId,
    required this.username,
    this.postId,
    this.message,
    required this.date,
    this.isNotificationRead = false,
  });

  // Helper getter for UserModel (created from userId and username)
  UserModel get user {
    return UserModel(
      id: userId,
      firstName: '',
      lastName: '',
      userName: username,
      email: '',
      profileImage: null,
    );
  }

  // Helper getter for formatted notification content
  String get notificationContent {
    // This will be formatted based on type in the use case
    return message ?? '';
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      type: json['type'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      username: json['username'] as String? ?? '',
      postId: json['postId'] as String?,
      message: json['message'] as String?,
      date: json['date'] as String? ?? '',
      isNotificationRead: json['read'] as bool? ??
          json['isRead'] as bool? ??
          json['isNotificationRead'] as bool? ??
          false,
    );
  }

  NotificationModel copyWith({
    String? id,
    String? type,
    String? userId,
    String? username,
    String? postId,
    String? message,
    String? date,
    bool? isNotificationRead,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      type: type ?? this.type,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      postId: postId ?? this.postId,
      message: message ?? this.message,
      date: date ?? this.date,
      isNotificationRead: isNotificationRead ?? this.isNotificationRead,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'userId': userId,
      'username': username,
      'postId': postId,
      'message': message,
      'date': date,
      'isNotificationRead': isNotificationRead,
    };
  }
}
