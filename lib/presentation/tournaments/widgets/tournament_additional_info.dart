import 'package:flutter/material.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class TournamentAdditionalInfo extends StatelessWidget {
  final TournamentModel tournament;

  const TournamentAdditionalInfo({
    super.key,
    required this.tournament,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.tournamentAdditionalInfoLabel,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 16.h),
        _buildInfoRow(
          context,
          Icons.calendar_today,
          l10n.tournamentStartDateLabel,
          dateFormat.format(tournament.startAt),
        ),
        SizedBox(height: 8.h),
        _buildInfoRow(
          context,
          Icons.event,
          l10n.tournamentFormEndDate,
          dateFormat.format(tournament.endAt),
        ),
        SizedBox(height: 8.h),
        _buildInfoRow(
          context,
          Icons.location_on,
          l10n.tournamentLocationLabel,
          tournament.region,
        ),
        if (tournament.prize != null && tournament.prize!.isNotEmpty) ...[
          SizedBox(height: 8.h),
          _buildInfoRow(
            context,
            Icons.emoji_events,
            l10n.tournamentPrizePoolLabel,
            tournament.prize!,
          ),
        ],
        if (tournament.rules != null && tournament.rules!.isNotEmpty) ...[
          SizedBox(height: 16.h),
          Text(
            'Rules',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            tournament.rules!,
            style: TextStyle(
              fontSize: 14.sp,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildInfoRow(
      BuildContext context, IconData icon, String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: AppTheme.accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              icon,
              size: 20.sp,
              color: AppTheme.accent,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

