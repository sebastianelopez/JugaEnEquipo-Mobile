import 'package:jugaenequipo/datasources/models/models.dart';

class NotificationModel {
  final UserModel user;
  final String notificationContent;
  final bool isNotificationRead;
  final String date;

  NotificationModel(
      {required this.user,
      required this.notificationContent,
      required this.isNotificationRead,
      required this.date});
}
