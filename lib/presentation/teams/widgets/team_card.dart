import 'package:flutter/material.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';
import 'package:jugaenequipo/presentation/teams/business_logic/teams_screen_provider.dart';
import 'package:jugaenequipo/presentation/profile/screens/profile_screen.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:jugaenequipo/datasources/teams_use_cases/get_team_members_use_case.dart';
import 'package:provider/provider.dart';

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
    Provider.of<TeamsScreenProvider>(context, listen: false);
    final l10n = AppLocalizations.of(context)!;

    return _buildTeamCard(context, l10n);
  }

  Widget _buildTeamCard(BuildContext context, AppLocalizations l10n) {
    return Card(
      elevation: 12,
      shadowColor: AppTheme.primary.withOpacity( 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
        side: BorderSide(
          color: Colors.white.withOpacity( 0.3),
          width: 1.5,
        ),
      ),
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
        child: SizedBox(
          height: 200.h,
          child: Stack(
            children: [
              // Background image with overlay
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.r),
                  child: SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: _buildTeamImageWithOverlay(),
                  ),
                ),
              ),

              // Content overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity( 0.3),
                        Colors.black.withOpacity( 0.7),
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),

              // Top section with verification badge
              if (widget.team.verified == true)
                Positioned(
                  top: 16.h,
                  right: 16.w,
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withOpacity( 0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity( 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.verified,
                      color: Colors.white,
                      size: 20.w,
                    ),
                  ),
                ),

              // Games badges at top left
              Positioned(
                top: 16.h,
                left: 16.w,
                right: 16.w,
                child: _buildGamesBadges(),
              ),

              // Bottom content section
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.team.name,
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity( 0.5),
                              offset: const Offset(0, 1),
                              blurRadius: 3,
                            ),
                          ],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      SizedBox(height: 12.h),

                      // Stats row
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.w, vertical: 6.h),
                            decoration: BoxDecoration(
                              color: AppTheme.success.withOpacity( 0.9),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.people,
                                  color: Colors.white,
                                  size: 16.w,
                                ),
                                SizedBox(width: 6.w),
                                Text(
                                  '${_members?.length ?? widget.team.membersIds?.length ?? 0}',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 12.w),
                          if ((_members != null && _members!.isNotEmpty) ||
                              (widget.team.membersIds != null && widget.team.membersIds!.isNotEmpty))
                            Expanded(
                              child: _buildMembersAvatars(),
                            ),
                        ],
                      ),

                      SizedBox(height: 16.h),

                      Container(
                        width: double.infinity,
                        height: 44.h,
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withOpacity( 0.9),
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity( 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'View Team Profile',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                                size: 16.w,
                              ),
                            ],
                          ),
                        ),
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

  Widget _buildGamesBadges() {
    if (widget.team.games.isEmpty) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: AppTheme.accent.withOpacity( 0.9),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity( 0.3),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.sports_esports,
              color: Colors.white,
              size: 14.w,
            ),
            SizedBox(width: 4.w),
            Text(
              'No Games',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    // Show first game as main badge with additional indicator
    final mainGame = widget.team.games.first;
    return Row(
      children: [
        // Main game badge - flexible to prevent overflow
        Flexible(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: AppTheme.accent.withOpacity( 0.9),
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity( 0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.sports_esports,
                  color: Colors.white,
                  size: 14.w,
                ),
                SizedBox(width: 4.w),
                Flexible(
                  child: Text(
                    mainGame.name,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Additional games indicator - fixed size
        if (widget.team.games.length > 1) ...[
          SizedBox(width: 6.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity( 0.9),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Text(
              '+${widget.team.games.length - 1}',
              style: TextStyle(
                fontSize: 9.sp,
                fontWeight: FontWeight.w600,
                color: AppTheme.primary,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildMembersAvatars() {
    final membersToShow = _members ?? [];
    final maxToShow = 4;
    final totalCount = membersToShow.isNotEmpty 
        ? membersToShow.length 
        : (widget.team.membersIds?.length ?? 0);

    if (totalCount == 0) {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        ...List.generate(
          membersToShow.length > maxToShow ? maxToShow : membersToShow.length,
          (index) {
            final member = membersToShow[index];
            return Container(
              margin: EdgeInsets.only(right: 6.w),
              child: CircleAvatar(
                radius: 14.r,
                backgroundColor: Colors.white.withOpacity(0.9),
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
                        size: 16.w,
                      )
                    : null,
              ),
            );
          },
        ),
        // Show placeholder avatars if members are still loading
        if (_isLoadingMembers && membersToShow.isEmpty)
          ...List.generate(
            widget.team.membersIds != null && widget.team.membersIds!.length > maxToShow
                ? maxToShow
                : (widget.team.membersIds?.length ?? 0),
            (index) => Container(
              margin: EdgeInsets.only(right: 6.w),
              child: CircleAvatar(
                radius: 14.r,
                backgroundColor: Colors.white.withOpacity(0.9),
                child: Icon(
                  Icons.person,
                  color: AppTheme.primary,
                  size: 16.w,
                ),
              ),
            ),
          ),
        if (totalCount > maxToShow)
          Container(
            margin: EdgeInsets.only(left: 4.w),
            child: Text(
              '+${totalCount - maxToShow}',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTeamImageWithOverlay() {
    if (widget.team.image != null &&
        widget.team.image!.isNotEmpty &&
        (widget.team.image!.startsWith('http://') ||
            widget.team.image!.startsWith('https://'))) {
      return Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              widget.team.image!,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (context, error, stackTrace) =>
                  _buildDefaultTeamBackground(),
            ),
          ),
          // Subtle overlay for better text readability
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity( 0.1),
              ),
            ),
          ),
        ],
      );
    } else {
      return _buildDefaultTeamBackground();
    }
  }

  Widget _buildDefaultTeamBackground() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primary.withOpacity( 0.8),
            AppTheme.accent.withOpacity( 0.6),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.group,
          color: Colors.white.withOpacity( 0.8),
          size: 60.w,
        ),
      ),
    );
  }
}
