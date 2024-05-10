import 'package:flutter/material.dart';
import 'package:jugaenequipo/presentation/notifications/business_logic/notifications_provider.dart';
import 'package:jugaenequipo/presentation/notifications/widgets/widgets.dart';
import 'package:provider/provider.dart';

class NotificationsList extends StatelessWidget {
  const NotificationsList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final notificationsProvider = Provider.of<NotificationsProvider>(context);
    final notificationMocks =
        notificationsProvider.getMockNotifications(context);

    return ListView.builder(
      itemCount: notificationMocks.length,
      shrinkWrap: true,
      padding: const EdgeInsets.only(top: 16),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return NotificationsListItem(
          user: notificationMocks[index].user,
          notificationContent: notificationMocks[index].notificationContent,
          date: notificationMocks[index].date,
          isNotificationRead: (index == 0 || index == 3) ? true : false,
        );
      },
    );
  }
}
