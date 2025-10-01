import 'package:flutter/material.dart';
import 'package:jugaenequipo/presentation/notifications/business_logic/notifications_provider.dart';
import 'package:jugaenequipo/presentation/notifications/widgets/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class NotificationsList extends StatelessWidget {
  const NotificationsList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final notificationsProvider = Provider.of<NotificationsProvider>(context);
    final items = notificationsProvider.notifications.isEmpty
        ? notificationsProvider.getMockNotifications(context)
        : notificationsProvider.notifications;

    return ListView.builder(
      itemCount: items.length,
      shrinkWrap: true,
      padding: EdgeInsets.only(top: 16.h),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final n = items[index];
        return Dismissible(
          key: ValueKey(n.id),
          background: Container(color: Colors.transparent),
          direction: DismissDirection.endToStart,
          confirmDismiss: (_) async {
            await notificationsProvider.markAsRead(n.id);
            return false; // keep item, only mark read
          },
          child: NotificationsListItem(
            user: n.user,
            notificationContent: n.notificationContent,
            date: n.date,
            isNotificationRead: n.isNotificationRead,
          ),
        );
      },
    );
  }
}
