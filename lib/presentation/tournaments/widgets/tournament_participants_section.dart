import 'package:flutter/material.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TournamentParticipantsSection extends StatelessWidget {
  final TournamentModel tournament;

  const TournamentParticipantsSection({
    super.key,
    required this.tournament,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final participantsCount = tournament.registeredTeams;
    final progress = participantsCount / tournament.maxTeams;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.people,
                  color: AppTheme.primary,
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  l10n.tournamentParticipantsLabel,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                '$participantsCount/${tournament.maxTeams}',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primary,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8.h,
            backgroundColor:
                Theme.of(context).colorScheme.surface.withOpacity(0.3),
            valueColor: AlwaysStoppedAnimation<Color>(
              progress >= 1.0 ? AppTheme.success : AppTheme.primary,
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          '${(progress * 100).toStringAsFixed(0)}% de capacidad',
          style: TextStyle(
            fontSize: 12.sp,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}
