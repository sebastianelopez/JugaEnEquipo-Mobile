import 'package:flutter/material.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:jugaenequipo/datasources/tournaments_use_cases/delete_tournament_use_case.dart'
    as delete_use_case;
import 'package:jugaenequipo/datasources/teams_use_cases/search_teams_use_case.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:jugaenequipo/utils/tournament_role_helper.dart';
import 'package:jugaenequipo/providers/user_provider.dart';
import 'package:jugaenequipo/presentation/tournaments/screen/tournament_form_screen.dart';
import 'package:jugaenequipo/presentation/tournaments/widgets/tournament_header.dart';
import 'package:jugaenequipo/presentation/tournaments/widgets/tournament_background_image.dart';
import 'package:jugaenequipo/presentation/tournaments/widgets/tournament_description.dart';
import 'package:jugaenequipo/presentation/tournaments/widgets/tournament_game_info.dart';
import 'package:jugaenequipo/presentation/tournaments/widgets/tournament_official_status.dart';
import 'package:jugaenequipo/presentation/tournaments/widgets/tournament_participants_section.dart';
import 'package:jugaenequipo/presentation/tournaments/widgets/tournament_participating_teams_section.dart';
import 'package:jugaenequipo/presentation/tournaments/widgets/tournament_registration_button.dart';
import 'package:jugaenequipo/presentation/tournaments/widgets/tournament_additional_info.dart';
import 'package:jugaenequipo/presentation/tournaments/widgets/tournament_teams_modal.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class TournamentDetailScreen extends StatefulWidget {
  final TournamentModel tournament;

  const TournamentDetailScreen({
    super.key,
    required this.tournament,
  });

  @override
  State<TournamentDetailScreen> createState() => _TournamentDetailScreenState();
}

class _TournamentDetailScreenState extends State<TournamentDetailScreen> {
  List<TeamModel>? _participatingTeams;
  bool _isLoadingTeams = false;
  String? _teamsError;

  @override
  void initState() {
    super.initState();
    _loadParticipatingTeams();
  }

  Future<void> _loadParticipatingTeams() async {
    setState(() {
      _isLoadingTeams = true;
      _teamsError = null;
    });

    try {
      final teams = await searchTeams(tournamentId: widget.tournament.id);
      if (mounted) {
        setState(() {
          _participatingTeams = teams ?? [];
          _isLoadingTeams = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _teamsError = 'Error al cargar los equipos';
          _isLoadingTeams = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentUser = Provider.of<UserProvider>(context).user;
    final now = DateTime.now();
    final isUpcoming = widget.tournament.startAt.isAfter(now);
    final isOngoing = widget.tournament.startAt.isBefore(now) &&
        widget.tournament.endAt.isAfter(now);
    final isFinished = widget.tournament.endAt.isBefore(now);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          l10n.tournamentDetailsTitle,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            shadows: [
              Shadow(
                offset: const Offset(0, 1),
                blurRadius: 3,
                color: Colors.black.withOpacity(0.3),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.arrow_back, size: 20.w),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (TournamentRoleHelper.canEdit(widget.tournament, currentUser)) ...[
            IconButton(
              icon: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.edit, size: 20.w),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        TournamentFormScreen(tournament: widget.tournament),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                  ),
                ).then((result) {
                  if (result == true && context.mounted) {
                    _loadParticipatingTeams();
                    Navigator.pop(context, true);
                  }
                });
              },
            ),
            PopupMenuButton<String>(
              icon: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.more_vert, size: 20.w),
              ),
              color: Theme.of(context).colorScheme.surface,
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
                      Icon(Icons.delete, color: Colors.red, size: 18.w),
                      SizedBox(width: 8.w),
                      Text(l10n.tournamentFormDelete),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
      body: SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            // Background Image
            TournamentBackgroundImage(imageUrl: widget.tournament.image),
            // Tournament Title Overlay
            TournamentHeader(tournament: widget.tournament),
            // Content
            SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Container(
                margin: EdgeInsets.only(top: 250.h),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status Badge Section
                    _buildStatusSection(
                        context, isUpcoming, isOngoing, isFinished),
                    SizedBox(height: 24.h),
                    // Key Info Cards
                    _buildKeyInfoSection(
                        context, l10n, isUpcoming, isOngoing, isFinished),
                    SizedBox(height: 24.h),
                    TournamentDescription(tournament: widget.tournament),
                    if (widget.tournament.description != null &&
                        widget.tournament.description!.isNotEmpty)
                      SizedBox(height: 24.h),
                    TournamentGameInfo(tournament: widget.tournament),
                    SizedBox(height: 24.h),
                    TournamentOfficialStatus(tournament: widget.tournament),
                    SizedBox(height: 24.h),
                    TournamentParticipantsSection(
                        tournament: widget.tournament),
                    SizedBox(height: 24.h),
                    TournamentParticipatingTeamsSection(
                      participatingTeams: _participatingTeams,
                      isLoading: _isLoadingTeams,
                      error: _teamsError,
                      onRetry: _loadParticipatingTeams,
                      onShowAllTeams: () => _showAllTeamsModal(context),
                    ),
                    SizedBox(height: 24.h),
                    TournamentRegistrationButton(
                      tournament: widget.tournament,
                      onRegistrationSuccess: _loadParticipatingTeams,
                      onLeaveSuccess: _loadParticipatingTeams,
                    ),
                    SizedBox(height: 24.h),
                    TournamentAdditionalInfo(tournament: widget.tournament),
                    SizedBox(height: 24.h), // Bottom padding
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAllTeamsModal(BuildContext context) {
    if (_participatingTeams != null && _participatingTeams!.isNotEmpty) {
      TournamentTeamsModal.show(context, _participatingTeams!);
    }
  }

  Widget _buildStatusSection(
      BuildContext context, bool isUpcoming, bool isOngoing, bool isFinished) {
    String text;
    Color color;
    IconData icon;

    if (isFinished) {
      text = 'Finalizado';
      color = AppTheme.error;
      icon = Icons.check_circle;
    } else if (isOngoing) {
      text = 'En curso';
      color = AppTheme.success;
      icon = Icons.play_circle_filled;
    } else {
      text = 'Próximo';
      color = AppTheme.warning;
      icon = Icons.schedule;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24.w),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Estado del Torneo',
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
                  text,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyInfoSection(BuildContext context, AppLocalizations l10n,
      bool isUpcoming, bool isOngoing, bool isFinished) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final timeFormat = DateFormat('HH:mm');

    return Row(
      children: [
        Expanded(
          child: _buildInfoCard(
            context,
            icon: Icons.calendar_today,
            iconColor: AppTheme.primary,
            title: 'Inicio',
            value: dateFormat.format(widget.tournament.startAt),
            subtitle: timeFormat.format(widget.tournament.startAt),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildInfoCard(
            context,
            icon: Icons.event,
            iconColor: AppTheme.accent,
            title: 'Fin',
            value: dateFormat.format(widget.tournament.endAt),
            subtitle: timeFormat.format(widget.tournament.endAt),
          ),
        ),
        if (widget.tournament.prize != null &&
            widget.tournament.prize!.isNotEmpty) ...[
          SizedBox(width: 12.w),
          Expanded(
            child: _buildInfoCard(
              context,
              icon: Icons.emoji_events,
              iconColor: AppTheme.warning,
              title: 'Premio',
              value: widget.tournament.prize!,
              subtitle: null,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    String? subtitle,
  }) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: iconColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, color: iconColor, size: 18.w),
          ),
          SizedBox(height: 8.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 11.sp,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (subtitle != null) ...[
            SizedBox(height: 2.h),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 10.sp,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ],
        ],
      ),
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
        tournamentId: widget.tournament.id,
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
}
