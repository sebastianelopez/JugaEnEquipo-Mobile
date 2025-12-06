import 'package:flutter/material.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';
import 'package:jugaenequipo/presentation/tournaments/widgets/participating_team_item.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TournamentTeamsModal extends StatelessWidget {
  final List<TeamModel> teams;

  const TournamentTeamsModal({
    super.key,
    required this.teams,
  });

  static void show(BuildContext context, List<TeamModel> teams) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TournamentTeamsModal(teams: teams),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 12.h),
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          // Header
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.tournamentParticipantsListLabel,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    '${teams.length}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Teams list
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              itemCount: teams.length,
              separatorBuilder: (context, index) => SizedBox(height: 8.h),
              itemBuilder: (context, index) {
                return ParticipatingTeamItem(team: teams[index]);
              },
            ),
          ),
          // Close button
          Padding(
            padding: EdgeInsets.all(20.w),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: const Text(
                  'Cerrar',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

