import 'package:flutter/material.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';
import 'package:jugaenequipo/presentation/profile/screens/profile_screen.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:jugaenequipo/datasources/teams_use_cases/get_team_members_use_case.dart';

class TeamCard extends StatefulWidget {
  final TeamModel team;

  const TeamCard({super.key, required this.team});

  @override
  State<TeamCard> createState() => _TeamCardState();
}

class _TeamCardState extends State<TeamCard> {
  List<UserModel>? _members;
  bool _isLoadingMembers = false;

  @override
  void initState() {
    super.initState();
    _loadMembers();
  }

  Future<void> _loadMembers() async {
    if (_members != null) return; // Already loaded

    setState(() {
      _isLoadingMembers = true;
    });

    try {
      final members = await getTeamMembers(widget.team.id);
      if (mounted) {
        setState(() {
          _members = members;
          _isLoadingMembers = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingMembers = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return _buildTeamCard(context, l10n);
  }

  Widget _buildTeamCard(BuildContext context, AppLocalizations l10n) {
    final hasImage = widget.team.image != null &&
        widget.team.image!.isNotEmpty &&
        (widget.team.image!.startsWith('http://') ||
            widget.team.image!.startsWith('https://'));

    return Hero(
      tag: 'team-${widget.team.id}',
      child: Card(
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
              MaterialPageRoute(
                builder: (context) => ProfileScreen(
                  teamId: widget.team.id,
                  team: widget.team,
                  profileType: ProfileType.team,
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(20.r),
          child: Container(
            height: 220.h,
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
                        AppTheme.success.withOpacity(0.05),
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
            ),
            child: Stack(
              children: [
                // Background Image
                if (hasImage)
                  Positioned.fill(
                    child: Image.network(
                      widget.team.image!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(),
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
                                  // Team Name
                                  Text(
                                    widget.team.name,
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
                                  // Founded Badge
                                  _buildFoundedBadge(context, hasImage),
                                ],
                              ),
                            ),
                            SizedBox(width: 8.w),
                            // Verified Badge
                            if (widget.team.verified == true)
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
                                        : AppTheme.primary.withOpacity(0.3),
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
                                      l10n.verifiedStatus,
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
                          ],
                        ),
                        const Spacer(),
                        // Game & Members Info
                        Row(
                          children: [
                            // Game Icon Container
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.r),
                              child: Container(
                                width: 48.w,
                                height: 48.w,
                                color: hasImage
                                    ? Colors.white.withOpacity(0.2)
                                    : AppTheme.primary.withOpacity(0.1),
                                padding: EdgeInsets.all(8.w),
                                child: Icon(
                                  Icons.sports_esports,
                                  color: hasImage
                                      ? Colors.white
                                      : AppTheme.primary,
                                  size: 24.w,
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Games Display
                                  _buildGamesText(context, hasImage),
                                  SizedBox(height: 4.h),
                                  // Members Count
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
                                        '${_members?.length ?? widget.team.membersIds?.length ?? 0} ${l10n.membersLabel}',
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
                            // Members Avatars
                            if ((_members != null && _members!.isNotEmpty) ||
                                (widget.team.membersIds != null &&
                                    widget.team.membersIds!.isNotEmpty))
                              _buildMembersAvatarsCompact(hasImage),
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
      ),
    );
  }

  Widget _buildFoundedBadge(BuildContext context, bool hasImage) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final difference = now.difference(widget.team.createdAt);
    final years = (difference.inDays / 365).floor();
    final months = ((difference.inDays % 365) / 30).floor();

    String ageText;
    IconData icon;
    Color color;

    if (years > 0) {
      ageText =
          years == 1 ? '1 ${l10n.yearSingular}' : '$years ${l10n.yearPlural}';
      icon = Icons.emoji_events;
      color = AppTheme.warning;
    } else if (months > 0) {
      ageText = months == 1
          ? '1 ${l10n.monthSingular}'
          : '$months ${l10n.monthPlural}';
      icon = Icons.schedule;
      color = AppTheme.accent;
    } else {
      ageText = l10n.newTeam;
      icon = Icons.fiber_new;
      color = AppTheme.success;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(hasImage ? 0.3 : 0.15),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: color.withOpacity(0.4),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12.w, color: hasImage ? Colors.white : color),
          SizedBox(width: 4.w),
          Text(
            ageText,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: hasImage ? Colors.white : color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGamesText(BuildContext context, bool hasImage) {
    final l10n = AppLocalizations.of(context)!;

    if (widget.team.games.isEmpty) {
      return Text(
        l10n.noGames,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w700,
          color:
              hasImage ? Colors.white : Theme.of(context).colorScheme.onSurface,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }

    final gamesText = widget.team.games.length == 1
        ? widget.team.games.first.name
        : '${widget.team.games.first.name} +${widget.team.games.length - 1}';

    return Text(
      gamesText,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w700,
        color:
            hasImage ? Colors.white : Theme.of(context).colorScheme.onSurface,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildMembersAvatarsCompact(bool hasImage) {
    final membersToShow = _members ?? [];
    final maxToShow = 3;

    if (membersToShow.isEmpty && !_isLoadingMembers) {
      return const SizedBox.shrink();
    }

    return Container(
      width: 60.w,
      height: 60.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: hasImage
            ? Colors.white.withOpacity(0.2)
            : AppTheme.primary.withOpacity(0.1),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (membersToShow.isNotEmpty)
            ...List.generate(
              membersToShow.length > maxToShow
                  ? maxToShow
                  : membersToShow.length,
              (index) {
                final member = membersToShow[index];
                final radius = 12.w;
                return Positioned(
                  left: 30.w +
                      (radius * (index == 0 ? 0 : (index == 1 ? 1 : -0.5))),
                  top: 30.w +
                      (radius * (index == 0 ? -1 : (index == 1 ? 0.5 : 0.5))),
                  child: CircleAvatar(
                    radius: 8.r,
                    backgroundColor: Colors.white,
                    backgroundImage: member.profileImage != null &&
                            (member.profileImage!.startsWith('http://') ||
                                member.profileImage!.startsWith('https://'))
                        ? NetworkImage(member.profileImage!)
                        : null,
                    child: member.profileImage == null ||
                            (!member.profileImage!.startsWith('http://') &&
                                !member.profileImage!.startsWith('https://'))
                        ? Icon(
                            Icons.person,
                            color: AppTheme.primary,
                            size: 10.w,
                          )
                        : null,
                  ),
                );
              },
            )
          else
            Icon(
              Icons.people,
              color: hasImage
                  ? Colors.white.withOpacity(0.6)
                  : AppTheme.primary.withOpacity(0.6),
              size: 24.w,
            ),
        ],
      ),
    );
  }
}
