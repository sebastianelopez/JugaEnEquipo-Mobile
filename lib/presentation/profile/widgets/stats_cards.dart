import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';

class StatsCards extends StatelessWidget {
  final List<GameStat> stats;

  const StatsCards({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    if (stats.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.statisticsLabel,
            style: TextStyle(
              fontSize: 16.h,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 12.w,
            runSpacing: 12.h,
            children:
                stats.map((stat) => _buildStatCard(context, stat)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, GameStat stat) {
    return Container(
      width: (MediaQuery.of(context).size.width - 64.w) / 2,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppTheme.primary.withOpacity( 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withOpacity( 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (stat.gameImage != null)
                Container(
                  width: 32.w,
                  height: 32.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    image: DecorationImage(
                      image: stat.gameImage!.startsWith('http://') ||
                              stat.gameImage!.startsWith('https://')
                          ? NetworkImage(stat.gameImage!)
                          : AssetImage(stat.gameImage!) as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              if (stat.gameImage != null) SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  stat.gameName,
                  style: TextStyle(
                    fontSize: 14.h,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          if (stat.username != null)
            Row(
              children: [
                Icon(
                  Icons.person,
                  size: 14.h,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withOpacity( 0.6),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Text(
                    stat.username!,
                    style: TextStyle(
                      fontSize: 12.h,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity( 0.7),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          if (stat.rankImage != null) ...[
            SizedBox(height: 8.h),
            Row(
              children: [
                Text(
                  'Rank: ',
                  style: TextStyle(
                    fontSize: 12.h,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity( 0.7),
                  ),
                ),
                Image(
                  height: 20.h,
                  width: 20.h,
                  image: stat.rankImage!.startsWith('http://') ||
                          stat.rankImage!.startsWith('https://')
                      ? NetworkImage(stat.rankImage!)
                      : AssetImage(stat.rankImage!) as ImageProvider,
                ),
              ],
            ),
          ],
          if (stat.roles != null && stat.roles!.isNotEmpty) ...[
            SizedBox(height: 8.h),
            Wrap(
              spacing: 4.w,
              runSpacing: 4.h,
              children: stat.roles!.map((role) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppTheme.accent.withOpacity( 0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    role,
                    style: TextStyle(
                      fontSize: 10.h,
                      color: AppTheme.accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class GameStat {
  final String gameName;
  final String? gameImage;
  final String? username;
  final String? rankImage;
  final List<String>? roles;

  GameStat({
    required this.gameName,
    this.gameImage,
    this.username,
    this.rankImage,
    this.roles,
  });
}
