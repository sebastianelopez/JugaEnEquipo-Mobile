import 'package:flutter/material.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:jugaenequipo/datasources/teams_use_cases/get_team_by_id_use_case.dart';
import 'package:jugaenequipo/datasources/tournaments_use_cases/get_tournament_by_id_use_case.dart';
import 'package:jugaenequipo/presentation/tournaments/screen/tournament_detail_screen.dart';
import 'package:jugaenequipo/share_preferences/preferences.dart';
import 'package:jugaenequipo/utils/utils.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';

class NotificationsListItem extends StatelessWidget {
  final NotificationModel notification;
  final String notificationContent;

  const NotificationsListItem({
    super.key,
    required this.notification,
    required this.notificationContent,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleNotificationTap(context),
      child: Container(
        padding:
            EdgeInsets.only(left: 16.h, right: 16.h, top: 10.h, bottom: 10.h),
        decoration: BoxDecoration(
          color: notification.isNotificationRead
              ? Colors.transparent
              : AppTheme.primary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: notification.isNotificationRead
                ? Colors.transparent
                : Colors.white.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: notification.isNotificationRead
              ? null
              : [
                  BoxShadow(
                    color: AppTheme.primary.withOpacity(0.1),
                    blurRadius: 12,
                    spreadRadius: 0,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: (notification.user.profileImage != null &&
                            notification.user.profileImage!.isNotEmpty &&
                            (notification.user.profileImage!
                                    .startsWith('http://') ||
                                notification.user.profileImage!
                                    .startsWith('https://')))
                        ? Image.network(
                            notification.user.profileImage!,
                            errorBuilder: (context, error, stackTrace) =>
                                Image.asset(
                              'assets/error.png',
                            ),
                          ).image
                        : const AssetImage('assets/user_image.jpg')
                            as ImageProvider,
                    maxRadius: 20.h,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Html(
                          data: notificationContent,
                          style: {
                            'b': Style(
                                fontWeight: FontWeight.bold,
                                color: Preferences.isDarkmode
                                    ? Colors.grey.shade100
                                    : Colors.grey.shade900,
                                fontSize: FontSize(13.h)),
                            'body': Style(
                              color: Preferences.isDarkmode
                                  ? Colors.grey.shade300
                                  : Colors.grey.shade700,
                              fontSize: FontSize(13.h),
                            ),
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Text(
              formatTimeElapsed(DateTime.parse(notification.date), context),
              style: TextStyle(
                  fontSize: 12.h,
                  fontWeight: notification.isNotificationRead
                      ? FontWeight.bold
                      : FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }

  /// Handles navigation based on notification type
  Future<void> _handleNotificationTap(BuildContext context) async {
    // Hide keyboard
    FocusScope.of(context).unfocus();

    final localizations = AppLocalizations.of(context);
    if (localizations == null) return;

    switch (notification.type) {
      case 'tournament_request_received':
        // Navigate to tournament detail
        if (notification.tournamentId != null &&
            notification.tournamentId!.isNotEmpty) {
          await _navigateToTournament(context, notification.tournamentId!);
        }
        break;

      case 'team_request_received':
        // Navigate to team profile
        if (notification.teamId != null && notification.teamId!.isNotEmpty) {
          await _navigateToTeam(context, notification.teamId!);
        }
        break;

      case 'user_mentioned':
      case 'post_liked':
      case 'post_commented':
      case 'post_shared':
        // Navigate to post detail if postId is available
        if (notification.postId != null && notification.postId!.isNotEmpty) {
          _navigateToPostDetail(context, notification.postId!);
        } else {
          _navigateToUserProfile(context, notification.userId);
        }
        break;

      case 'new_follower':
        // Navigate to user profile
        _navigateToUserProfile(context, notification.userId);
        break;

      case 'post_moderated':
        // Navigate to user profile
        _navigateToUserProfile(context, notification.userId);
        break;

      default:
        // For other types, navigate to chat or user profile
        Navigator.of(context).pushNamed('chat', arguments: notification.user);
        break;
    }
  }

  /// Navigate to tournament detail screen
  Future<void> _navigateToTournament(
      BuildContext context, String tournamentId) async {
    final localizations = AppLocalizations.of(context)!;

    try {
      debugPrint('Navigating to tournament with ID: $tournamentId');

      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
          ),
        ),
      );

      // Load tournament
      final tournament = await getTournamentById(tournamentId);

      debugPrint(
          'Tournament loaded: ${tournament != null ? tournament.name : 'null'}');

      // Remove loading indicator
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      if (tournament != null && context.mounted) {
        debugPrint('Navigating to TournamentDetailScreen');
        // Navigate to tournament detail
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                TournamentDetailScreen(tournament: tournament),
          ),
        );
      } else if (context.mounted) {
        debugPrint('Tournament is null, showing error message');
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations.errorLoadingUserProfile),
            backgroundColor: Theme.of(context).colorScheme.error,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e, stackTrace) {
      debugPrint('Error navigating to tournament: $e');
      debugPrint('Stack trace: $stackTrace');
      // Remove loading indicator if still showing
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations.errorLoadingUserProfile),
            backgroundColor: Theme.of(context).colorScheme.error,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  /// Navigate to team profile screen
  Future<void> _navigateToTeam(BuildContext context, String teamId) async {
    final localizations = AppLocalizations.of(context)!;

    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
          ),
        ),
      );

      // Load team
      final team = await getTeamById(teamId);

      // Remove loading indicator
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      if (team != null && context.mounted) {
        // Navigate to team profile using the profile route
        Navigator.pushNamed(
          context,
          'profile',
          arguments: {'teamId': teamId},
        );
      } else if (context.mounted) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations.teamNotFound),
            backgroundColor: Theme.of(context).colorScheme.error,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      // Remove loading indicator if still showing
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations.teamNotFound),
            backgroundColor: Theme.of(context).colorScheme.error,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  /// Navigate to user profile screen
  void _navigateToUserProfile(BuildContext context, String userId) {
    Navigator.pushNamed(
      context,
      'profile',
      arguments: {'userId': userId},
    );
  }

  /// Navigate to post detail screen
  void _navigateToPostDetail(BuildContext context, String postId) {
    Navigator.pushNamed(
      context,
      'post-detail',
      arguments: {'postId': postId},
    );
  }
}
