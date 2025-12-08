import 'package:flutter/material.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:jugaenequipo/datasources/tournaments_use_cases/delete_tournament_use_case.dart'
    as delete_use_case;
import 'package:jugaenequipo/datasources/teams_use_cases/search_teams_use_case.dart';
import 'package:jugaenequipo/datasources/user_use_cases/get_user_use_case.dart';
import 'package:jugaenequipo/datasources/tournaments_use_cases/get_tournament_background_image_use_case.dart';
import 'package:jugaenequipo/datasources/tournaments_use_cases/get_tournament_requests_use_case.dart';
import 'package:jugaenequipo/presentation/tournaments/widgets/tournament_pending_requests_section.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:jugaenequipo/utils/tournament_role_helper.dart';
import 'package:jugaenequipo/providers/user_provider.dart';
import 'package:jugaenequipo/presentation/tournaments/screen/tournament_form_screen.dart';
import 'package:jugaenequipo/presentation/tournaments/widgets/tournament_header.dart';
import 'package:jugaenequipo/presentation/tournaments/widgets/tournament_background_image.dart';
import 'package:jugaenequipo/presentation/tournaments/widgets/tournament_description.dart';
import 'package:jugaenequipo/presentation/tournaments/widgets/tournament_game_info.dart';
import 'package:jugaenequipo/presentation/tournaments/widgets/tournament_official_status.dart';
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

class _TournamentDetailScreenState extends State<TournamentDetailScreen>
    with SingleTickerProviderStateMixin {
  List<TeamModel>? _participatingTeams;
  bool _isLoadingTeams = false;
  String? _teamsError;

  UserModel? _responsibleUser;
  bool _isLoadingResponsible = false;

  String? _backgroundImageUrl;

  List<TournamentRequestModel> _pendingRequests = [];
  bool _isLoadingRequests = false;
  String? _requestsError;

  late TabController _tabController;
  bool _showRequestsTab = false;

  @override
  void initState() {
    super.initState();
    final currentUser = Provider.of<UserProvider>(context, listen: false).user;
    _showRequestsTab = _shouldShowPendingRequests(currentUser);

    _tabController = TabController(
      length: _showRequestsTab ? 2 : 1,
      vsync: this,
    );

    _tabController.addListener(() {
      setState(() {});
    });

    _loadParticipatingTeams();
    _loadResponsibleUser();
    _loadBackgroundImage();
    if (_showRequestsTab) {
      _loadPendingRequests();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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

  Future<void> _loadResponsibleUser() async {
    setState(() {
      _isLoadingResponsible = true;
    });

    try {
      final user = await getUserById(widget.tournament.responsibleId);
      if (mounted) {
        setState(() {
          _responsibleUser = user;
          _isLoadingResponsible = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingResponsible = false;
        });
      }
    }
  }

  Future<void> _loadBackgroundImage() async {
    try {
      final imageUrl = await getTournamentBackgroundImage(
        tournamentId: widget.tournament.id,
      );
      if (mounted) {
        setState(() {
          _backgroundImageUrl = imageUrl;
        });
      }
    } catch (e) {
      // Error loading background image, just skip it
    }
  }

  Future<void> _loadPendingRequests() async {
    final currentUser = Provider.of<UserProvider>(context, listen: false).user;
    final isCreator =
        currentUser != null && widget.tournament.creatorId == currentUser.id;
    final isResponsible = currentUser != null &&
        widget.tournament.responsibleId == currentUser.id;

    // Only load requests if user is creator or responsible
    if (!isCreator && !isResponsible) {
      return;
    }

    setState(() {
      _isLoadingRequests = true;
      _requestsError = null;
    });

    try {
      final requests = await getTournamentRequests(
        tournamentId: widget.tournament.id,
      );
      if (mounted) {
        setState(() {
          _pendingRequests = requests ?? [];
          _isLoadingRequests = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _requestsError = 'Error al cargar las solicitudes';
          _isLoadingRequests = false;
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
            TournamentBackgroundImage(imageUrl: _backgroundImageUrl),
            TournamentHeader(tournament: widget.tournament),
            // Content with Tabs
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
                    if (_showRequestsTab) ...[
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: Theme.of(context)
                                .colorScheme
                                .outline
                                .withOpacity(0.1),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: TabBar(
                            controller: _tabController,
                            labelColor: AppTheme.primary,
                            unselectedLabelColor: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.6),
                            indicatorColor: AppTheme.primary,
                            indicatorWeight: 4,
                            indicatorSize: TabBarIndicatorSize.tab,
                            dividerColor: Colors.transparent,
                            tabs: [
                              Tab(
                                icon: Icon(Icons.info_outline, size: 20.w),
                                text: l10n.tournamentTabInfo,
                              ),
                              Tab(
                                icon: Icon(Icons.pending_actions, size: 20.w),
                                text: l10n.tournamentTabRequests,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),
                      // Contenido según el tab seleccionado
                      _tabController.index == 0
                          ? _buildInfoTabContent(context, l10n, currentUser,
                              isUpcoming, isOngoing, isFinished)
                          : _buildRequestsTabContent(context, l10n),
                    ] else ...[
                      // Sin tabs, mostrar solo información
                      _buildInfoTabContent(context, l10n, currentUser,
                          isUpcoming, isOngoing, isFinished),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTabContent(
    BuildContext context,
    AppLocalizations l10n,
    UserModel? currentUser,
    bool isUpcoming,
    bool isOngoing,
    bool isFinished,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStatusSection(context, isUpcoming, isOngoing, isFinished),
        SizedBox(height: 24.h),
        _buildKeyInfoSection(context, l10n, isUpcoming, isOngoing, isFinished),
        SizedBox(height: 24.h),
        TournamentDescription(tournament: widget.tournament),
        if (widget.tournament.description != null &&
            widget.tournament.description!.isNotEmpty)
          SizedBox(height: 24.h),
        TournamentGameInfo(tournament: widget.tournament),
        SizedBox(height: 24.h),
        TournamentOfficialStatus(tournament: widget.tournament),
        SizedBox(height: 24.h),
        _buildResponsibleSection(context, currentUser),
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
        SizedBox(height: 24.h),
      ],
    );
  }

  Widget _buildRequestsTabContent(BuildContext context, AppLocalizations l10n) {
    return TournamentPendingRequestsSection(
      requests: _pendingRequests,
      isLoading: _isLoadingRequests,
      error: _requestsError,
      onRefresh: _loadPendingRequests,
      onRequestProcessed: () {
        _loadPendingRequests();
        _loadParticipatingTeams();
      },
    );
  }

  void _showAllTeamsModal(BuildContext context) {
    if (_participatingTeams != null && _participatingTeams!.isNotEmpty) {
      TournamentTeamsModal.show(context, _participatingTeams!);
    }
  }

  Widget _buildStatusSection(
      BuildContext context, bool isUpcoming, bool isOngoing, bool isFinished) {
    final l10n = AppLocalizations.of(context)!;
    String text;
    Color color;
    IconData icon;

    if (isFinished) {
      text = l10n.tournamentStatusFinished;
      color = AppTheme.error;
      icon = Icons.check_circle;
    } else if (isOngoing) {
      text = l10n.tournamentStatusOngoing;
      color = AppTheme.success;
      icon = Icons.play_circle_filled;
    } else {
      text = l10n.tournamentStatusUpcoming;
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
                  l10n.tournamentStatusLabel,
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
            title: l10n.tournamentStartDate,
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
            title: l10n.tournamentEndDate,
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
              title: l10n.tournamentPrize,
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

  Widget _buildResponsibleSection(
      BuildContext context, UserModel? currentUser) {
    final l10n = AppLocalizations.of(context)!;
    final isCreator =
        currentUser != null && widget.tournament.creatorId == currentUser.id;
    final isResponsible = currentUser != null &&
        widget.tournament.responsibleId == currentUser.id;
    final userRole =
        TournamentRoleHelper.getUserRole(widget.tournament, currentUser);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppTheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppTheme.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Avatar del responsable
              if (_isLoadingResponsible)
                Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: SizedBox(
                      width: 20.w,
                      height: 20.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                )
              else if (_responsibleUser?.profileImage != null)
                CircleAvatar(
                  radius: 24.w,
                  backgroundImage:
                      NetworkImage(_responsibleUser!.profileImage!),
                  backgroundColor: AppTheme.primary.withOpacity(0.2),
                )
              else
                CircleAvatar(
                  radius: 24.w,
                  backgroundColor: AppTheme.primary.withOpacity(0.2),
                  child: Icon(
                    Icons.person,
                    color: AppTheme.primary,
                    size: 24.w,
                  ),
                ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.tournamentResponsible,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.6),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    if (_isLoadingResponsible)
                      Text(
                        l10n.loading,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.5),
                        ),
                      )
                    else if (_responsibleUser != null)
                      Text(
                        _responsibleUser!.userName,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      )
                    else
                      Text(
                        l10n.tournamentUserNotAvailable,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.5),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          if (isCreator || isResponsible) ...[
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppTheme.success.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: AppTheme.success.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isCreator ? Icons.star : Icons.shield,
                    color: AppTheme.success,
                    size: 16.w,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    isCreator
                        ? l10n.tournamentYouAreCreator
                        : isResponsible
                            ? l10n.tournamentYouAreRole('responsable')
                            : l10n.tournamentYouAreRole(
                                userRole.toString().split('.').last),
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.success,
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

  bool _shouldShowPendingRequests(UserModel? currentUser) {
    if (currentUser == null) return false;
    final isCreator = widget.tournament.creatorId == currentUser.id;
    final isResponsible = widget.tournament.responsibleId == currentUser.id;
    return isCreator || isResponsible;
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
