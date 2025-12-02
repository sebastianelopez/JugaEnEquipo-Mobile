import 'package:flutter/material.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:jugaenequipo/datasources/tournaments_use_cases/delete_tournament_use_case.dart'
    as delete_use_case;
import 'package:jugaenequipo/datasources/tournaments_use_cases/request_tournament_access_use_case.dart';
import 'package:jugaenequipo/datasources/tournaments_use_cases/leave_tournament_use_case.dart';
import 'package:jugaenequipo/global_widgets/card_container.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:jugaenequipo/utils/tournament_role_helper.dart';
import 'package:jugaenequipo/providers/user_provider.dart';
import 'package:jugaenequipo/presentation/tournaments/screen/tournament_form_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TournamentDetailScreen extends StatelessWidget {
  final TournamentModel tournament;

  const TournamentDetailScreen({
    super.key,
    required this.tournament,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentUser = Provider.of<UserProvider>(context).user;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tournamentDetailsTitle),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (TournamentRoleHelper.canEdit(tournament, currentUser)) ...[
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TournamentFormScreen(
                      tournament: tournament,
                    ),
                  ),
                ).then((result) {
                  if (result == true && context.mounted) {
                    Navigator.pop(context, true); // Refresh tournament list
                  }
                });
              },
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                if (value == 'delete') {
                  _showDeleteConfirmation(context, l10n);
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      const Icon(Icons.delete, color: Colors.red),
                      const SizedBox(width: 8),
                      Text(l10n.tournamentFormDelete),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTournamentHeader(context),
            SizedBox(height: 24.h),
            _buildGameInfo(context),
            SizedBox(height: 24.h),
            _buildOfficialStatus(context),
            SizedBox(height: 24.h),
            _buildParticipantsSection(context),
            SizedBox(height: 24.h),
            _buildRegistrationButton(context),
            SizedBox(height: 24.h),
            _buildAdditionalInfo(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTournamentHeader(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return CardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  tournament.title,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              if (tournament.isOfficial)
                Icon(
                  Icons.verified,
                  color: AppTheme.primary,
                  size: 28.sp,
                ),
            ],
          ),
          SizedBox(height: 8.h),
          if (tournament.description != null &&
              tournament.description!.isNotEmpty) ...[
            Text(
              tournament.description!,
              style: TextStyle(
                fontSize: 14.sp,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            SizedBox(height: 8.h),
          ],
          Text(
            '${l10n.tournamentParticipantsLabel}: ${tournament.registeredTeams}/${tournament.maxTeams}',
            style: TextStyle(
              fontSize: 16.sp,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameInfo(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return CardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.tournamentGameInfoLabel,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              if (tournament.image != null && tournament.image!.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: tournament.image!.startsWith('http://') ||
                          tournament.image!.startsWith('https://')
                      ? Image.network(
                          tournament.image!,
                          width: 60.w,
                          height: 60.h,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 60.w,
                              height: 60.h,
                              decoration: BoxDecoration(
                                color: AppTheme.accent.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Icon(
                                Icons.sports_esports,
                                size: 30.sp,
                                color: AppTheme.accent,
                              ),
                            );
                          },
                        )
                      : Image.asset(
                          tournament.image!,
                          width: 60.w,
                          height: 60.h,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 60.w,
                              height: 60.h,
                              decoration: BoxDecoration(
                                color: AppTheme.accent.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Icon(
                                Icons.sports_esports,
                                size: 30.sp,
                                color: AppTheme.accent,
                              ),
                            );
                          },
                        ),
                )
              else
                Container(
                  width: 60.w,
                  height: 60.h,
                  decoration: BoxDecoration(
                    color: AppTheme.accent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.sports_esports,
                    size: 30.sp,
                    color: AppTheme.accent,
                  ),
                ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tournament.game.name,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      l10n.tournamentGameTypeLabel,
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
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOfficialStatus(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return CardContainer(
      child: Row(
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
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParticipantsSection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final participantsCount = tournament.registeredTeams;

    return CardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.tournamentParticipantsLabel,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              Text(
                '$participantsCount/${tournament.maxTeams}',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          if (participantsCount > 0) ...[
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                ),
              ),
              child: Text(
                l10n.tournamentParticipantsListLabel,
                style: TextStyle(
                  fontSize: 14.sp,
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ),
          ] else ...[
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
                      l10n.tournamentNoParticipantsLabel,
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
        ],
      ),
    );
  }

  Widget _buildRegistrationButton(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentUser = Provider.of<UserProvider>(context, listen: false).user;
    final isRegistered = tournament.isUserRegistered;
    final userRole = TournamentRoleHelper.getUserRole(tournament, currentUser);

    // Don't show registration button for creators
    if (userRole == TournamentUserRole.creator) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isRegistered
                ? null
                : () async {
                    if (currentUser?.teamId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text('Debes estar en un equipo para registrarte'),
                          backgroundColor: AppTheme.error,
                        ),
                      );
                      return;
                    }

                    final success = await requestTournamentAccess(
                      tournamentId: tournament.id,
                      teamId: currentUser!.teamId!,
                    );

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(success
                              ? l10n.tournamentRegistrationSuccess
                              : 'Error al solicitar acceso'),
                          backgroundColor:
                              success ? AppTheme.success : AppTheme.error,
                        ),
                      );
                      if (success) {
                        Navigator.pop(context, true); // Refresh
                      }
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isRegistered ? AppTheme.success : AppTheme.primary,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text(
              isRegistered
                  ? l10n.tournamentAlreadyRegisteredLabel
                  : l10n.tournamentRegisterButtonLabel,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        if (userRole == TournamentUserRole.member) ...[
          SizedBox(height: 12.h),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () async {
                if (currentUser?.teamId == null) return;

                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Abandonar Torneo'),
                    content: const Text(
                        '¿Estás seguro de que quieres abandonar este torneo?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text(l10n.tournamentFormDeleteCancel),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: TextButton.styleFrom(
                            foregroundColor: AppTheme.error),
                        child: const Text('Abandonar'),
                      ),
                    ],
                  ),
                );

                if (confirmed == true && context.mounted) {
                  final success = await leaveTournament(
                    tournamentId: tournament.id,
                    teamId: currentUser!.teamId!,
                  );

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(success
                            ? 'Has abandonado el torneo'
                            : 'Error al abandonar el torneo'),
                        backgroundColor:
                            success ? AppTheme.success : AppTheme.error,
                      ),
                    );
                    if (success) {
                      Navigator.pop(context, true); // Refresh
                    }
                  }
                }
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.error,
                side: BorderSide(color: AppTheme.error),
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: const Text(
                'Abandonar Torneo',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _showDeleteConfirmation(
      BuildContext context, AppLocalizations l10n) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.tournamentFormDeleteTitle),
        content: Text(l10n.tournamentFormDeleteMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.tournamentFormDeleteCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppTheme.error),
            child: Text(l10n.tournamentFormDeleteConfirm),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final success = await delete_use_case.deleteTournament(
        tournamentId: tournament.id,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success
                ? l10n.tournamentFormSuccessDelete
                : l10n.tournamentFormErrorDelete),
            backgroundColor: success ? AppTheme.success : AppTheme.error,
          ),
        );
        if (success) {
          Navigator.pop(context, true); // Go back and refresh list
        }
      }
    }
  }

  Widget _buildAdditionalInfo(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return CardContainer(
      child: Column(
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
      ),
    );
  }

  Widget _buildInfoRow(
      BuildContext context, IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20.sp,
          color: AppTheme.accent,
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14.sp,
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
