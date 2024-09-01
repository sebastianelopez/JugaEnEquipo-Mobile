import 'package:jugaenequipo/datasources/models/models.dart';

class NotificationModel {
  final String id;
  final UserModel user;
  final String notificationContent;
  final bool isNotificationRead;
  final String date;

  NotificationModel(
      {required this.id,
      required this.user,
      required this.notificationContent,
      required this.isNotificationRead,
      required this.date});

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
        id: json['id'] as String,
        user: json['user'] as UserModel,
        notificationContent: json['notificationContent'] as String,
        isNotificationRead: json['isNotificationRead'] as bool,
        date: json['date'] as String);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user,
      'notificationContent': notificationContent,
      'isNotificationRead': isNotificationRead,
      'date': date
    };
  }
}
