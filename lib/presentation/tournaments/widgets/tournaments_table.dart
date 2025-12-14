import 'package:flutter/material.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';
import 'package:jugaenequipo/datasources/models/tournament_model.dart';
import 'package:jugaenequipo/presentation/tournaments/business_logic/tournaments_provider.dart';
import 'package:jugaenequipo/presentation/tournaments/screen/tournament_detail_screen.dart';
import 'package:jugaenequipo/presentation/tournaments/screen/tournament_form_screen.dart';
import 'package:jugaenequipo/datasources/tournaments_use_cases/delete_tournament_use_case.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:jugaenequipo/utils/tournament_role_helper.dart';
import 'package:jugaenequipo/utils/game_image_helper.dart';
import 'package:jugaenequipo/providers/user_provider.dart';
import 'package:jugaenequipo/datasources/tournaments_use_cases/get_tournament_background_image_use_case.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TournamentsTable extends StatelessWidget {
  const TournamentsTable({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Consumer<TournamentsProvider>(
      builder: (context, tournamentsScreen, _) {
        return _buildTournamentsList(context, tournamentsScreen, l10n);
      },
    );
  }

  Widget _buildTournamentsList(
    BuildContext context,
    TournamentsProvider tournamentsScreen,
    AppLocalizations l10n,
  ) {
    return RefreshIndicator(
      color: AppTheme.primary,
      onRefresh: tournamentsScreen.onRefresh,
      child: _buildContent(context, tournamentsScreen, l10n),
    );
  }

  Widget _buildContent(
    BuildContext context,
    TournamentsProvider tournamentsScreen,
    AppLocalizations l10n,
  ) {
    if (tournamentsScreen.isLoading && tournamentsScreen.tournaments.isEmpty) {
      return _buildLoadingState(context, l10n);
    }

    if (tournamentsScreen.error != null &&
        tournamentsScreen.tournaments.isEmpty) {
      return _buildErrorState(context, tournamentsScreen, l10n);
    }

    if (tournamentsScreen.tournaments.isEmpty) {
      return _buildEmptyState(context, l10n);
    }

    return _buildTournamentsGrid(context, tournamentsScreen, l10n);
  }

  Widget _buildLoadingState(BuildContext context, AppLocalizations l10n) {
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: _TournamentCardSkeleton(),
        );
      },
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    TournamentsProvider tournamentsScreen,
    AppLocalizations l10n,
  ) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(32.w),
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height * 0.6,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: AppTheme.error.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.error.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.error_outline,
                size: 48.w,
                color: AppTheme.error,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'Oops!',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              tournamentsScreen.error ?? 'Error al cargar torneos',
              style: TextStyle(
                fontSize: 16.sp,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.h),
            ElevatedButton.icon(
              onPressed: () => tournamentsScreen.onRefresh(),
              icon: const Icon(Icons.refresh),
              label: Text(l10n.tryAgain),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations l10n) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(32.w),
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height * 0.6,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(32.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.primary.withOpacity(0.2),
                    AppTheme.accent.withOpacity(0.1),
                  ],
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.primary.withOpacity(0.3),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primary.withOpacity(0.2),
                    blurRadius: 30,
                    spreadRadius: 0,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Icon(
                Icons.emoji_events_outlined,
                size: 64.w,
                color: AppTheme.primary,
              ),
            ),
            SizedBox(height: 32.h),
            Text(
              l10n.tournamentFormNoTournamentsAvailable,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w800,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),
            Text(
              l10n.tournamentFormCheckBackLater,
              style: TextStyle(
                fontSize: 16.sp,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: AppTheme.primary.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppTheme.primary,
                    size: 18.w,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Crea el primer torneo',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTournamentsGrid(
    BuildContext context,
    TournamentsProvider tournamentsScreen,
    AppLocalizations l10n,
  ) {
    // Add 1 to itemCount if loading more data to show loading indicator
    final itemCount = tournamentsScreen.tournaments.length +
        (tournamentsScreen.isLoadingMore ? 1 : 0);

    return ListView.separated(
      controller: tournamentsScreen.scrollController,
      padding: EdgeInsets.all(16.w),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: (context, index) {
        // Don't add separator after the last tournament (before loading indicator)
        if (tournamentsScreen.isLoadingMore &&
            index == tournamentsScreen.tournaments.length - 1) {
          return SizedBox(height: 0.h);
        }
        return SizedBox(height: 12.h);
      },
      itemBuilder: (context, index) {
        // Show loading indicator at the end
        if (index >= tournamentsScreen.tournaments.length) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 24.h),
            child: Center(
              child: SizedBox(
                width: 36.w,
                height: 36.w,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
                ),
              ),
            ),
          );
        }

        final tournament = tournamentsScreen.tournaments[index];
        return _buildTournamentCard(context, tournament, l10n);
      },
    );
  }

  Widget _buildTournamentCard(
    BuildContext context,
    dynamic tournament,
    AppLocalizations l10n,
  ) {
    return _TournamentCard(
      tournament: tournament,
      l10n: l10n,
    );
  }
}

class _TournamentCard extends StatefulWidget {
  final TournamentModel tournament;
  final AppLocalizations l10n;

  const _TournamentCard({
    required this.tournament,
    required this.l10n,
  });

  @override
  State<_TournamentCard> createState() => _TournamentCardState();
}

class _TournamentCardState extends State<_TournamentCard> {
  String? _backgroundImageUrl;
  bool _isLoadingImage = true;

  @override
  void initState() {
    super.initState();
    _loadBackgroundImage();
  }

  Future<void> _loadBackgroundImage() async {
    final imageUrl = await getTournamentBackgroundImage(
      tournamentId: widget.tournament.id,
    );
    if (mounted) {
      setState(() {
        _backgroundImageUrl = imageUrl;
        _isLoadingImage = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserProvider>(context, listen: false).user;
    final canEdit =
        TournamentRoleHelper.canEdit(widget.tournament, currentUser);
    final now = DateTime.now();
    final isUpcoming = widget.tournament.startAt.isAfter(now);
    final isOngoing = widget.tournament.startAt.isBefore(now) &&
        widget.tournament.endAt.isAfter(now);
    final isFinished = widget.tournament.endAt.isBefore(now);
    final progress =
        widget.tournament.registeredTeams / widget.tournament.maxTeams;

    final hasImage = _backgroundImageUrl != null &&
        _backgroundImageUrl!.isNotEmpty &&
        (_backgroundImageUrl!.startsWith('http://') ||
            _backgroundImageUrl!.startsWith('https://') ||
            _backgroundImageUrl!.startsWith('data:image'));

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  TournamentDetailScreen(tournament: widget.tournament),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
              transitionDuration: const Duration(milliseconds: 300),
            ),
          );
        },
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          height: 240.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            gradient: hasImage
                ? null
                : LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.primary.withOpacity(0.15),
                      AppTheme.accent.withOpacity(0.08),
                      AppTheme.warning.withOpacity(0.05),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
          ),
          child: Stack(
            children: [
              // Background Image
              if (hasImage && !_isLoadingImage)
                Positioned.fill(
                  child: _backgroundImageUrl!.startsWith('data:image')
                      ? Image.memory(
                          Uri.parse(_backgroundImageUrl!)
                              .data!
                              .contentAsBytes(),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(),
                        )
                      : Image.network(
                          _backgroundImageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(),
                        ),
                ),
              // Gradient Overlay
              if (hasImage)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.3),
                          Colors.black.withOpacity(0.7),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                ),
              // Content
              Positioned.fill(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title
                                Text(
                                  widget.tournament.title,
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w800,
                                    color: hasImage
                                        ? Colors.white
                                        : Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                    height: 1.2,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 8.h),
                                // Status Badge
                                _buildStatusBadge(
                                    context, isUpcoming, isOngoing, isFinished),
                              ],
                            ),
                          ),
                          SizedBox(width: 8.w),
                          // Official Badge & Menu
                          Column(
                            children: [
                              if (widget.tournament.isOfficial)
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.w, vertical: 4.h),
                                  decoration: BoxDecoration(
                                    color: hasImage
                                        ? Colors.white.withOpacity(0.2)
                                        : AppTheme.primary.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(12.r),
                                    border: Border.all(
                                      color: hasImage
                                          ? Colors.white.withOpacity(0.3)
                                          : AppTheme.primary.withOpacity(0.4),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.verified,
                                        color: hasImage
                                            ? Colors.white
                                            : AppTheme.primary,
                                        size: 14.w,
                                      ),
                                      SizedBox(width: 4.w),
                                      Text(
                                        widget.l10n.tournamentFormOfficial,
                                        style: TextStyle(
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w700,
                                          color: hasImage
                                              ? Colors.white
                                              : AppTheme.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              if (canEdit) ...[
                                SizedBox(height: 8.h),
                                PopupMenuButton<String>(
                                  icon: Icon(
                                    Icons.more_vert,
                                    color: hasImage
                                        ? Colors.white
                                        : Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withOpacity(0.6),
                                    size: 20.w,
                                  ),
                                  color: Theme.of(context).colorScheme.surface,
                                  onSelected: (value) {
                                    if (value == 'edit') {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              TournamentFormScreen(
                                                  tournament:
                                                      widget.tournament),
                                        ),
                                      );
                                    } else if (value == 'delete') {
                                      _showDeleteConfirmation(
                                          context, widget.tournament);
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      value: 'edit',
                                      child: Row(
                                        children: [
                                          Icon(Icons.edit,
                                              color: Colors.blue, size: 18.w),
                                          SizedBox(width: 8.w),
                                          Text(widget.l10n.tournamentFormEdit),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 'delete',
                                      child: Row(
                                        children: [
                                          Icon(Icons.delete,
                                              color: Colors.red, size: 18.w),
                                          SizedBox(width: 8.w),
                                          Text(
                                              widget.l10n.tournamentFormDelete),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                      const Spacer(),
                      // Game Info & Participants
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.r),
                            child: Container(
                              width: 48.w,
                              height: 48.w,
                              color: Colors.white.withOpacity(0.2),
                              padding: EdgeInsets.all(8.w),
                              child: GameImageHelper.buildGameImage(
                                gameName: widget.tournament.game.name,
                                width: 32.w,
                                height: 32.w,
                                defaultIcon: Icons.sports_esports,
                                defaultIconColor: Colors.white,
                                defaultIconSize: 20.w,
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.tournament.game.name,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w700,
                                    color: hasImage
                                        ? Colors.white
                                        : Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4.h),
                                // Participants Progress
                                Row(
                                  children: [
                                    Icon(
                                      Icons.people,
                                      size: 14.w,
                                      color: hasImage
                                          ? Colors.white.withOpacity(0.8)
                                          : AppTheme.primary,
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      '${widget.tournament.registeredTeams}/${widget.tournament.maxTeams}',
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w600,
                                        color: hasImage
                                            ? Colors.white.withOpacity(0.9)
                                            : Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Progress Indicator
                          Container(
                            width: 60.w,
                            height: 60.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: hasImage
                                  ? Colors.white.withOpacity(0.2)
                                  : AppTheme.primary.withOpacity(0.1),
                            ),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                CircularProgressIndicator(
                                  value: progress,
                                  strokeWidth: 4,
                                  backgroundColor: hasImage
                                      ? Colors.white.withOpacity(0.3)
                                      : AppTheme.primary.withOpacity(0.2),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    progress >= 1.0
                                        ? AppTheme.success
                                        : hasImage
                                            ? Colors.white
                                            : AppTheme.primary,
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    '${(progress * 100).toStringAsFixed(0)}%',
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w800,
                                      color: hasImage
                                          ? Colors.white
                                          : AppTheme.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      // Date Info
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 14.w,
                            color: hasImage
                                ? Colors.white.withOpacity(0.8)
                                : Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(0.6),
                          ),
                          SizedBox(width: 6.w),
                          Expanded(
                            child: Text(
                              _formatDateRange(widget.tournament.startAt,
                                  widget.tournament.endAt),
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: hasImage
                                    ? Colors.white.withOpacity(0.9)
                                    : Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withOpacity(0.7),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(
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
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: color.withOpacity(0.4),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12.w, color: color),
          SizedBox(width: 4.w),
          Text(
            text,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateRange(DateTime start, DateTime end) {
    final isSameDay = start.day == end.day &&
        start.month == end.month &&
        start.year == end.year;

    final startStr = isSameDay
        ? '${start.day.toString().padLeft(2, '0')}/${start.month.toString().padLeft(2, '0')}/${start.year}'
        : '${start.day.toString().padLeft(2, '0')}/${start.month.toString().padLeft(2, '0')}';

    final endStr =
        '${end.day.toString().padLeft(2, '0')}/${end.month.toString().padLeft(2, '0')}/${end.year}';

    return '$startStr - $endStr';
  }

  Future<void> _showDeleteConfirmation(
      BuildContext context, TournamentModel tournament) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(widget.l10n.tournamentFormDeleteTitle),
        content: Text(widget.l10n.tournamentFormDeleteMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(widget.l10n.tournamentFormDeleteCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppTheme.error),
            child: Text(widget.l10n.tournamentFormDeleteConfirm),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final success = await deleteTournament(tournamentId: tournament.id);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success
                ? widget.l10n.tournamentFormSuccessDelete
                : widget.l10n.tournamentFormErrorDelete),
            backgroundColor: success ? AppTheme.success : AppTheme.error,
          ),
        );
        if (success) {
          final tournamentsProvider =
              Provider.of<TournamentsProvider>(context, listen: false);
          tournamentsProvider.onRefresh();
        }
      }
    }
  }
}

class _TournamentCardSkeleton extends StatefulWidget {
  const _TournamentCardSkeleton();

  @override
  State<_TournamentCardSkeleton> createState() =>
      _TournamentCardSkeletonState();
}

class _TournamentCardSkeletonState extends State<_TournamentCardSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Card(
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          clipBehavior: Clip.antiAlias,
          child: Container(
            height: 240.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.grey.withOpacity(0.1),
                  Colors.grey.withOpacity(0.05),
                ],
              ),
            ),
            child: _buildShimmerOverlay(context),
          ),
        );
      },
    );
  }

  Widget _buildShimmerOverlay(BuildContext context) {
    final shimmerColor = Colors.white.withOpacity(
      0.1 + (_animation.value * 0.15),
    );

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(-1.0 + (_animation.value * 2), 0),
          end: Alignment(1.0 + (_animation.value * 2), 0),
          colors: [
            Colors.transparent,
            shimmerColor,
            Colors.transparent,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row Skeleton
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tournament Title Skeleton
                      Container(
                        width: double.infinity,
                        height: 24.h,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      // Status Badge Skeleton
                      Container(
                        width: 90.w,
                        height: 20.h,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                // Official Badge Skeleton (optional)
                Container(
                  width: 70.w,
                  height: 24.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ],
            ),
            const Spacer(),
            // Game Info & Participants Skeleton
            Row(
              children: [
                // Game Icon Skeleton
                Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Game Name Skeleton
                      Container(
                        width: 120.w,
                        height: 18.h,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      // Participants Count Skeleton
                      Container(
                        width: 100.w,
                        height: 16.h,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                      ),
                    ],
                  ),
                ),
                // Progress Indicator Skeleton
                Container(
                  width: 60.w,
                  height: 60.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.withOpacity(0.2),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            // Date Info Skeleton
            Container(
              width: 180.w,
              height: 14.h,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(6.r),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
