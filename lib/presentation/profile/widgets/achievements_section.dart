import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';

class AchievementsSection extends StatelessWidget {
  final List<Achievement> achievements;

  const AchievementsSection({super.key, required this.achievements});

  @override
  Widget build(BuildContext context) {
    if (achievements.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.achievementsAwardsLabel,
            style: TextStyle(
              fontSize: 16.h,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 12.w,
            runSpacing: 12.h,
            children: achievements.map((achievement) {
              return _buildAchievementCard(context, achievement);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementCard(BuildContext context, Achievement achievement) {
    return Container(
      width: (MediaQuery.of(context).size.width - 64.w) / 2,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppTheme.warning.withOpacity( 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.warning.withOpacity( 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 48.w,
            height: 48.h,
            decoration: BoxDecoration(
              color: AppTheme.warning.withOpacity( 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              achievement.icon,
              color: AppTheme.warning,
              size: 24.h,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            achievement.title,
            style: TextStyle(
              fontSize: 12.h,
              fontWeight: FontWeight.w700,
              color: AppTheme.warning,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (achievement.subtitle != null) ...[
            SizedBox(height: 4.h),
            Text(
              achievement.subtitle!,
              style: TextStyle(
                fontSize: 10.h,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withOpacity( 0.7),
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}

class Achievement {
  final String title;
  final String? subtitle;
  final IconData icon;

  Achievement({
    required this.title,
    this.subtitle,
    required this.icon,
  });

  // Factory method to create from Map (for API data)
  factory Achievement.fromMap(Map<String, dynamic> map) {
    final iconCode = map['iconCode'] as int?;
    IconData iconData;

    // Map icon codes to IconData
    switch (iconCode) {
      case 0xe86c: // emoji_events
        iconData = Icons.emoji_events;
        break;
      case 0xe838: // star
        iconData = Icons.star;
        break;
      case 0xe7ef: // people
        iconData = Icons.people;
        break;
      case 0xe04b: // videocam
        iconData = Icons.videocam;
        break;
      default:
        iconData = Icons.star;
    }

    return Achievement(
      title: map['title'] as String,
      subtitle: map['subtitle'] as String?,
      icon: iconData,
    );
  }
}
