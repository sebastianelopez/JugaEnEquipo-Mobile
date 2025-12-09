import 'package:flutter/material.dart';
import 'package:jugaenequipo/presentation/notifications/business_logic/notifications_provider.dart';
import 'package:jugaenequipo/presentation/notifications/widgets/widgets.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';

class NotificationsList extends StatelessWidget {
  const NotificationsList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationsProvider>(
      builder: (context, provider, child) {
        final filteredNotifications = provider.filteredNotifications;

        if (provider.isLoading && filteredNotifications.isEmpty) {
          return _buildLoadingState(context);
        }

        if (filteredNotifications.isEmpty && !provider.isLoading) {
          return _buildEmptyState(context);
        }

        return RefreshIndicator(
          color: AppTheme.primary,
          onRefresh: provider.refresh,
          child: ListView.builder(
            controller: provider.scrollController,
            itemCount:
                filteredNotifications.length + (provider.hasMore ? 1 : 0),
            padding: EdgeInsets.only(top: 16.h),
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              if (index >= filteredNotifications.length) {
                // Loading indicator at the bottom
                return Padding(
                  padding: EdgeInsets.all(16.h),
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppTheme.primary),
                    ),
                  ),
                );
              }

              final n = filteredNotifications[index];
              return Dismissible(
                key: ValueKey(n.id),
                background: Container(
                  color: AppTheme.primary.withOpacity(0.1),
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 20.w),
                  child: Icon(
                    Icons.check_circle,
                    color: AppTheme.primary,
                    size: 24.h,
                  ),
                ),
                direction: DismissDirection.endToStart,
                confirmDismiss: (_) async {
                  await provider.markAsRead(n.id);
                  return false; // keep item, only mark read
                },
                child: NotificationsListItem(
                  notification: n,
                  notificationContent: _formatNotificationContent(n, context),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
          ),
          SizedBox(height: 16.h),
          Text(
            AppLocalizations.of(context)!.notificationsPageLabel,
            style: TextStyle(
              fontSize: 16.sp,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return RefreshIndicator(
      color: AppTheme.primary,
      onRefresh: () async {
        final provider =
            Provider.of<NotificationsProvider>(context, listen: false);
        await provider.refresh();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.notifications_none,
                  size: 64.h,
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                ),
                SizedBox(height: 16.h),
                Text(
                  AppLocalizations.of(context)!.notificationsPageLabel,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'No tienes notificaciones',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatNotificationContent(
      NotificationModel notification, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // If message is provided, use it
    if (notification.message != null && notification.message!.isNotEmpty) {
      return notification.message!;
    }

    // Otherwise format based on type using localized strings
    switch (notification.type) {
      case 'post_liked':
        return l10n.notificationPostLiked(notification.username);
      case 'new_follower':
        return l10n.notificationNewFollower(notification.username);
      case 'post_commented':
        return l10n.notificationPostCommented(notification.username);
      case 'post_shared':
        return l10n.notificationPostShared(notification.username);
      case 'team_invite':
        return l10n.notificationInviteToTeam(notification.username, 'team');
      case 'application_accepted':
        return l10n.notificationApplicationAccepted('role', 'team');
      case 'tournament_request_received':
        return l10n
            .notificationTournamentRequestReceived(notification.username);
      case 'user_mentioned':
        return l10n.notificationUserMentioned(notification.username);
      case 'team_request_received':
        return l10n.notificationTeamRequestReceived(notification.username);
      case 'team_request_accepted':
        return l10n.notificationTeamRequestAccepted(notification.username);
      case 'tournament_request_accepted':
        return l10n
            .notificationTournamentRequestAccepted(notification.username);
      case 'post_moderated':
        return l10n.notificationPostModerated(notification.username);
      default:
        return 'New notification from <b>${notification.username}</b>.';
    }
  }
}
