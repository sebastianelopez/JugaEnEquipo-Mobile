import 'package:flutter/material.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:jugaenequipo/datasources/tournaments_use_cases/leave_tournament_use_case.dart';
import 'package:jugaenequipo/datasources/tournaments_use_cases/request_tournament_access_use_case.dart';
import 'package:jugaenequipo/datasources/tournaments_use_cases/get_tournament_requests_use_case.dart';
import 'package:jugaenequipo/datasources/teams_use_cases/search_teams_use_case.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';
import 'package:jugaenequipo/providers/user_provider.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:jugaenequipo/utils/tournament_role_helper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class TournamentRegistrationButton extends StatefulWidget {
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
  State<TournamentRegistrationButton> createState() =>
      _TournamentRegistrationButtonState();
}

class _TournamentRegistrationButtonState
    extends State<TournamentRegistrationButton> {
  bool _hasLeft = false;
  bool _hasRegistered = false;
  bool _hasPendingRequest = false;
  bool _isCheckingRequests =
      false; // Changed to false, we use isUserRegistered now

  @override
  void initState() {
    super.initState();
    // Use isUserRegistered from tournament model instead of making API call
    _hasRegistered = widget.tournament.isUserRegistered;
    // Only check for pending requests if not already registered
    if (!_hasRegistered) {
      _checkPendingRequests();
    }
  }

  Future<void> _checkPendingRequests() async {
    debugPrint('_checkPendingRequests: Starting...');
    if (mounted) {
      setState(() {
        _isCheckingRequests = true;
      });
    }

    final currentUser = Provider.of<UserProvider>(context, listen: false).user;
    if (currentUser == null) {
      debugPrint('_checkPendingRequests: No current user');
      if (mounted) {
        setState(() {
          _isCheckingRequests = false;
        });
      }
      return;
    }

    // Get user's teams in this tournament
    debugPrint('_checkPendingRequests: Checking teams in tournament...');
    final userTeamsInTournament = await searchTeams(
      userId: currentUser.id,
      tournamentId: widget.tournament.id,
    );

    debugPrint(
        '_checkPendingRequests: Teams in tournament: ${userTeamsInTournament?.length ?? 0}');

    if (userTeamsInTournament == null || userTeamsInTournament.isEmpty) {
      debugPrint('_checkPendingRequests: Getting requests for tournament...');
      final tournamentRequests = await getTournamentRequests(
        tournamentId: widget.tournament.id,
      );

      debugPrint(
          '_checkPendingRequests: Found ${tournamentRequests?.length ?? 0} total requests for tournament');

      if (tournamentRequests != null && tournamentRequests.isNotEmpty) {
        // Get user's teams to check if any request belongs to them
        final userTeams = await searchTeams(userId: currentUser.id);
        final userTeamIds = userTeams?.map((t) => t.id).toSet() ?? {};

        debugPrint(
            '_checkPendingRequests: User has ${userTeamIds.length} teams');

        for (var request in tournamentRequests) {
          debugPrint(
              '  - Request: teamId=${request.teamId}, status=${request.status}');

          // Check if this request belongs to one of user's teams and is pending
          if (userTeamIds.contains(request.teamId) &&
              request.status == 'pending') {
            debugPrint(
                '_checkPendingRequests: Found pending request for user team!');
            if (mounted) {
              setState(() {
                _hasPendingRequest = true;
                _isCheckingRequests = false;
              });
              return;
            }
          }
        }
      }
    }

    debugPrint(
        '_checkPendingRequests: No pending requests found, setting isCheckingRequests to false');
    if (mounted) {
      setState(() {
        _isCheckingRequests = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentUser = Provider.of<UserProvider>(context, listen: false).user;
    final isRegistered =
        (_hasRegistered || widget.tournament.isUserRegistered) && !_hasLeft;
    final userRole =
        TournamentRoleHelper.getUserRole(widget.tournament, currentUser);

    debugPrint(
        'TournamentRegistrationButton: userRole=$userRole, isRegistered=$isRegistered, hasLeft=$_hasLeft');
    debugPrint(
        'TournamentRegistrationButton: currentUser.teamId=${currentUser?.teamId}');

    // Don't show registration button for creators
    if (userRole == TournamentUserRole.creator) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed:
                (isRegistered || _hasPendingRequest || _isCheckingRequests)
                    ? null
                    : () => _handleRegistration(context, l10n, currentUser),
            style: ElevatedButton.styleFrom(
              backgroundColor: _hasPendingRequest
                  ? AppTheme.warning
                  : (isRegistered ? AppTheme.success : AppTheme.primary),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: _isCheckingRequests
                ? SizedBox(
                    height: 20.h,
                    width: 20.w,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    _hasPendingRequest
                        ? 'Esperando Aprobación'
                        : (isRegistered
                            ? l10n.tournamentAlreadyRegisteredLabel
                            : l10n.tournamentRegisterButtonLabel),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
        if (userRole == TournamentUserRole.member && !_hasLeft) ...[
          SizedBox(height: 12.h),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () =>
                  _handleLeaveTournament(context, l10n, currentUser),
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
    if (currentUser == null) {
      debugPrint('_handleRegistration: currentUser is null');
      return;
    }

    // Get user's teams (excluding teams already in tournament)
    debugPrint('Searching for user teams...');
    final userTeams = await searchTeams(userId: currentUser.id);

    debugPrint('Found ${userTeams?.length ?? 0} total teams for user');
    if (userTeams != null) {
      for (var team in userTeams) {
        debugPrint('Team: ${team.name} (id: ${team.id})');
        debugPrint(
            '  - Creator: ${team.creatorId} (is user: ${team.creatorId == currentUser.id})');
        debugPrint(
            '  - Leader: ${team.leaderId} (is user: ${team.leaderId == currentUser.id})');
        debugPrint(
            '  - Games: ${team.games.map((g) => '${g.name} (${g.id})').join(', ')}');
      }
    }

    if (userTeams == null || userTeams.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Debes estar en un equipo para registrarte'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
      return;
    }

    // Filter teams by game if tournament has a specific game
    debugPrint('Tournament gameId: ${widget.tournament.gameId}');
    final eligibleTeams = userTeams.where((team) {
      // Check if user is creator or leader
      final isCreatorOrLeader =
          team.creatorId == currentUser.id || team.leaderId == currentUser.id;

      // Check if team has the same game as tournament
      final hasMatchingGame = team.games.any(
        (game) => game.id == widget.tournament.gameId,
      );

      debugPrint(
          'Team ${team.name}: isCreatorOrLeader=$isCreatorOrLeader, hasMatchingGame=$hasMatchingGame');

      return isCreatorOrLeader && hasMatchingGame;
    }).toList();

    debugPrint('Found ${eligibleTeams.length} eligible teams');

    if (eligibleTeams.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
                'No tienes equipos elegibles (debes ser creador/líder y el equipo debe tener el juego del torneo)'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
      return;
    }

    // If user has multiple teams, let them choose
    String? selectedTeamId;
    debugPrint('Number of eligible teams: ${eligibleTeams.length}');
    if (eligibleTeams.length > 1) {
      debugPrint('Showing team selection dialog');
      selectedTeamId = await _showTeamSelectionDialog(
        context,
        eligibleTeams,
      );
      debugPrint('Selected team ID from dialog: $selectedTeamId');
      if (selectedTeamId == null) {
        debugPrint('User cancelled team selection');
        return; // User cancelled
      }
    } else {
      selectedTeamId = eligibleTeams.first.id;
      debugPrint('Auto-selected only eligible team: $selectedTeamId');
    }

    final result = await _requestTournamentAccessWithErrorHandling(
      tournamentId: widget.tournament.id,
      teamId: selectedTeamId,
    );

    if (context.mounted) {
      if (result['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
                'Solicitud enviada. Esperando aprobación del administrador.'),
            backgroundColor: AppTheme.success,
          ),
        );
        setState(() {
          _hasPendingRequest = true;
          _isCheckingRequests = false;
        });
        widget.onRegistrationSuccess?.call();
      } else if (result['isPending'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
                'Ya tienes una solicitud pendiente para este equipo'),
            backgroundColor: AppTheme.warning,
          ),
        );
        setState(() {
          _hasPendingRequest = true;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Error al solicitar acceso'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    }
  }

  Future<void> _handleLeaveTournament(
    BuildContext context,
    AppLocalizations l10n,
    UserModel? currentUser,
  ) async {
    debugPrint('_handleLeaveTournament called');

    if (currentUser == null) {
      debugPrint('_handleLeaveTournament: currentUser is null');
      return;
    }

    // Get user's teams that are in this tournament
    debugPrint('Searching for user teams in tournament...');
    final userTeamsInTournament = await searchTeams(
      userId: currentUser.id,
      tournamentId: widget.tournament.id,
    );

    if (userTeamsInTournament == null || userTeamsInTournament.isEmpty) {
      debugPrint('No teams found for user in this tournament');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('No tienes equipos en este torneo'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
      return;
    }

    debugPrint('Found ${userTeamsInTournament.length} team(s) in tournament');

    // If user has multiple teams, let them choose which one to remove
    String? selectedTeamId;
    if (userTeamsInTournament.length > 1) {
      selectedTeamId = await _showTeamSelectionDialog(
        context,
        userTeamsInTournament,
      );
      if (selectedTeamId == null) {
        debugPrint('User cancelled team selection');
        return; // User cancelled
      }
    } else {
      selectedTeamId = userTeamsInTournament.first.id;
    }

    debugPrint('Selected team ID: $selectedTeamId');

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Abandonar Torneo'),
        content: Text(userTeamsInTournament.length > 1
            ? '¿Estás seguro de que quieres sacar a "${userTeamsInTournament.firstWhere((t) => t.id == selectedTeamId).name}" de este torneo?'
            : '¿Estás seguro de que quieres abandonar este torneo?'),
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
      debugPrint('User confirmed leaving tournament');
      debugPrint('Tournament ID: ${widget.tournament.id}');
      debugPrint('Team ID: $selectedTeamId');

      final success = await leaveTournament(
        tournamentId: widget.tournament.id,
        teamId: selectedTeamId,
      );

      debugPrint('leaveTournament result: $success');

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
          setState(() {
            _hasLeft = true;
          });
          widget.onLeaveSuccess?.call();
          Navigator.pop(context, true);
        }
      }
    }
  }

  Future<Map<String, dynamic>> _requestTournamentAccessWithErrorHandling({
    required String tournamentId,
    required String teamId,
  }) async {
    try {
      final success = await requestTournamentAccess(
        tournamentId: tournamentId,
        teamId: teamId,
      );
      return {'success': success};
    } catch (e) {
      final errorString = e.toString();
      debugPrint('Error in requestTournamentAccess: $errorString');

      // Check if it's a 409 error (pending request exists)
      if (errorString.contains('409') ||
          errorString.contains('pending request already exists') ||
          errorString.contains('tournament_request_already_exists')) {
        return {
          'success': false,
          'isPending': true,
          'message': 'Ya existe una solicitud pendiente'
        };
      }

      return {
        'success': false,
        'isPending': false,
        'message': 'Error al solicitar acceso'
      };
    }
  }

  Future<String?> _showTeamSelectionDialog(
    BuildContext context,
    List<TeamModel> teams,
  ) async {
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Selecciona el equipo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: teams.map((team) {
            return ListTile(
              leading: team.image != null
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(team.image!),
                    )
                  : const CircleAvatar(
                      child: Icon(Icons.group),
                    ),
              title: Text(team.name),
              onTap: () => Navigator.pop(context, team.id),
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }
}
