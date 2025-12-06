import 'package:flutter/material.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TournamentOfficialStatus extends StatelessWidget {
  final TournamentModel tournament;

  const TournamentOfficialStatus({
    super.key,
    required this.tournament,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        Icon(
          tournament.isOfficial ? Icons.verified : Icons.info_outline,
          color: tournament.isOfficial ? AppTheme.primary : AppTheme.warning,
          size: 24.sp,
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tournament.isOfficial
                    ? l10n.tournamentOfficialLabel
                    : l10n.tournamentCommunityLabel,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              Text(
                tournament.isOfficial
                    ? l10n.tournamentOfficialDescription
                    : l10n.tournamentCommunityDescription,
                style: TextStyle(
                  fontSize: 14.sp,
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
