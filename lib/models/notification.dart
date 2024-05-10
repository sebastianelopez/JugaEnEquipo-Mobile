import 'package:jugaenequipo/models/models.dart';

class NotificationItem {
  final User user;
  final String notificationContent;
  final bool isNotificationRead;
  final String date;

  NotificationItem(
      {required this.user,
      required this.notificationContent,
      required this.isNotificationRead,
      required this.date});
}
