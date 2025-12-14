import 'package:flutter/material.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';
import 'package:jugaenequipo/presentation/tournaments/widgets/participating_team_item.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:jugaenequipo/utils/tournament_role_helper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TournamentParticipatingTeamsSection extends StatelessWidget {
  final List<TeamModel>? participatingTeams;
  final bool isLoading;
  final String? error;
  final VoidCallback onRetry;
  final VoidCallback onShowAllTeams;
  final TournamentModel tournament;
  final UserModel? currentUser;

  const TournamentParticipatingTeamsSection({
    super.key,
    required this.participatingTeams,
    required this.isLoading,
    this.error,
    required this.onRetry,
    required this.onShowAllTeams,
    required this.tournament,
    this.currentUser,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (isLoading) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.tournamentRegisteredTeamsLabel,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 16.h),
          Center(
            child: Padding(
              padding: EdgeInsets.all(24.h),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
              ),
            ),
          ),
        ],
      );
    }

    if (error != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.tournamentRegisteredTeamsLabel,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppTheme.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.error_outline,
                  color: AppTheme.error,
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    error!,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppTheme.error,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: onRetry,
                  child: Text(l10n.tryAgain),
                ),
              ],
            ),
          ),
        ],
      );
    }

    if (participatingTeams == null || participatingTeams!.isEmpty) {
      // Check if user is creator or responsible
      final userRole =
          TournamentRoleHelper.getUserRole(tournament, currentUser);
      bool isCreatorOrResponsible = false;

      if (currentUser != null) {
        final userId = currentUser!.id;
        isCreatorOrResponsible = userRole == TournamentUserRole.creator ||
            tournament.responsibleId == userId ||
            tournament.creatorId == userId;
      }

      final message = isCreatorOrResponsible
          ? l10n.tournamentNoParticipantsLabelAdmin
          : l10n.tournamentNoParticipantsLabel;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.tournamentRegisteredTeamsLabel,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppTheme.warning.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.people_outline,
                  color: AppTheme.warning,
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    message,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppTheme.warning,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    const int maxVisibleTeams = 5;
    final visibleTeams = participatingTeams!.length > maxVisibleTeams
        ? participatingTeams!.take(maxVisibleTeams).toList()
        : participatingTeams!;
    final hasMoreTeams = participatingTeams!.length > maxVisibleTeams;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Equipos registrados',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 12.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                '${participatingTeams!.length}',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primary,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        ...visibleTeams.map((team) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: ParticipatingTeamItem(team: team),
            )),
        if (hasMoreTeams) ...[
          SizedBox(height: 12.h),
          InkWell(
            onTap: onShowAllTeams,
            borderRadius: BorderRadius.circular(12.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: AppTheme.primary.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      'Ver todos (${participatingTeams!.length - maxVisibleTeams} más)',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primary,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Icon(
                    Icons.arrow_forward,
                    color: AppTheme.primary,
                    size: 16.w,
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
