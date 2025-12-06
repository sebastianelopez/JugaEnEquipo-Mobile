import 'package:flutter/material.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:jugaenequipo/datasources/tournaments_use_cases/leave_tournament_use_case.dart';
import 'package:jugaenequipo/datasources/tournaments_use_cases/request_tournament_access_use_case.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';
import 'package:jugaenequipo/providers/user_provider.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:jugaenequipo/utils/tournament_role_helper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class TournamentRegistrationButton extends StatelessWidget {
  final TournamentModel tournament;
  final VoidCallback? onRegistrationSuccess;
  final VoidCallback? onLeaveSuccess;

  const TournamentRegistrationButton({
    super.key,
    required this.tournament,
    this.onRegistrationSuccess,
    this.onLeaveSuccess,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentUser = Provider.of<UserProvider>(context, listen: false).user;
    final isRegistered = tournament.isUserRegistered;
    final userRole =
        TournamentRoleHelper.getUserRole(tournament, currentUser);

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
                : () => _handleRegistration(context, l10n, currentUser),
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
              onPressed: () => _handleLeaveTournament(context, l10n, currentUser),
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

  Future<void> _handleRegistration(
    BuildContext context,
    AppLocalizations l10n,
    UserModel? currentUser,
  ) async {
    if (currentUser?.teamId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Debes estar en un equipo para registrarte'),
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
          backgroundColor: success ? AppTheme.success : AppTheme.error,
        ),
      );
      if (success) {
        onRegistrationSuccess?.call();
        Navigator.pop(context, true);
      }
    }
  }

  Future<void> _handleLeaveTournament(
    BuildContext context,
    AppLocalizations l10n,
    UserModel? currentUser,
  ) async {
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
            style: TextButton.styleFrom(foregroundColor: AppTheme.error),
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
            backgroundColor: success ? AppTheme.success : AppTheme.error,
          ),
        );
        if (success) {
          onLeaveSuccess?.call();
          Navigator.pop(context, true);
        }
      }
    }
  }
}

