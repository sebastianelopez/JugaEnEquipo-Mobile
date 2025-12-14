import 'package:jugaenequipo/datasources/models/models.dart';

class NotificationModel {
  final String id;
  final String type;
  final String userId;
  final String username;
  final String? profileImage;
  final String? postId;
  final String? tournamentId;
  final String? tournamentName;
  final String? teamId;
  final String? teamName;
  final String? message;
  final String date;
  final bool isNotificationRead;

  NotificationModel({
    required this.id,
    required this.type,
    required this.userId,
    required this.username,
    this.profileImage,
    this.postId,
    this.tournamentId,
    this.tournamentName,
    this.teamId,
    this.teamName,
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
      profileImage: profileImage,
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
      profileImage: json['profileImage'] as String?,
      postId: json['postId'] as String?,
      tournamentId: json['tournamentId'] as String?,
      tournamentName: json['tournamentName'] as String?,
      teamId: json['teamId'] as String?,
      teamName: json['teamName'] as String?,
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
    String? profileImage,
    String? postId,
    String? tournamentId,
    String? tournamentName,
    String? teamId,
    String? teamName,
    String? message,
    String? date,
    bool? isNotificationRead,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      type: type ?? this.type,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      profileImage: profileImage ?? this.profileImage,
      postId: postId ?? this.postId,
      tournamentId: tournamentId ?? this.tournamentId,
      tournamentName: tournamentName ?? this.tournamentName,
      teamId: teamId ?? this.teamId,
      teamName: teamName ?? this.teamName,
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
      'profileImage': profileImage,
      'postId': postId,
      'tournamentId': tournamentId,
      'tournamentName': tournamentName,
      'teamId': teamId,
      'teamName': teamName,
      'message': message,
      'date': date,
      'isNotificationRead': isNotificationRead,
    };
  }
}
