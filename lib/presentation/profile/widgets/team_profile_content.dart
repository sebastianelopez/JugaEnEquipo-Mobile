import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:jugaenequipo/presentation/profile/business_logic/team_profile_provider.dart';
import 'package:jugaenequipo/presentation/profile/widgets/widgets.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class TeamProfileContent extends StatelessWidget {
  final VoidCallback? onMembersPressed;
  final VoidCallback? onTournamentsPressed;
  final VoidCallback? onWinsPressed;

  const TeamProfileContent({
    super.key,
    this.onMembersPressed,
    this.onTournamentsPressed,
    this.onWinsPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<TeamProfileProvider>(
      builder: (context, teamProvider, _) {
        final teamProfile = teamProvider.teamProfile;

        if (teamProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (teamProfile == null) {
          return Center(
              child: Text(AppLocalizations.of(context)!.teamNotFound));
        }

        if (teamProvider.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(teamProvider.error!),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => teamProvider.refreshData(),
                  child: Text(AppLocalizations.of(context)!.tryAgain),
                ),
              ],
            ),
          );
        }

        // Wrap content with ChangeNotifierProvider.value to ensure provider is available to all children including Slivers
        return ChangeNotifierProvider<TeamProfileProvider>.value(
          value: teamProvider,
          child: _buildContent(context, teamProfile, teamProvider),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, TeamProfileModel teamProfile,
      TeamProfileProvider provider) {
    final bgImage = provider.backgroundImageUrl;

    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          // Background Image
          if (bgImage != null && bgImage.isNotEmpty)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 250.h,
              child: _buildBackgroundImage(bgImage),
            )
          else
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 250.h,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.primary,
                      AppTheme.primary.withOpacity(0.8),
                    ],
                  ),
                ),
              ),
            ),
          // Content
          ChangeNotifierProvider<TeamProfileProvider>.value(
            value: provider,
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Container(
                margin: EdgeInsets.only(top: 200.h),
                padding: EdgeInsets.only(top: 0.h),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    // Avatar positioned at the top of scrollable content, partially overlapping background
                    Transform.translate(
                      offset: Offset(0, -45.h),
                      child: _buildTeamAvatar(context, teamProfile),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          teamProfile.name,
                          style: TextStyle(
                            fontSize: 18.h,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        if (teamProfile.verified == true)
                          const Icon(
                            Icons.verified_rounded,
                            color: AppTheme.primary,
                            size: 20,
                          ),
                      ],
                    ),
                    // Games section
                    if (teamProfile.games.isNotEmpty) ...[
                      SizedBox(height: 8.h),
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 4.h,
                        alignment: WrapAlignment.center,
                        children: teamProfile.games.map((game) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.w, vertical: 6.h),
                            decoration: BoxDecoration(
                              color: AppTheme.accent.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(
                                color: AppTheme.accent.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.sports_esports,
                                  color: AppTheme.accent,
                                  size: 16.w,
                                ),
                                SizedBox(width: 6.w),
                                Text(
                                  game.name,
                                  style: TextStyle(
                                    color: AppTheme.accent,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                    if (teamProfile.description != null &&
                        teamProfile.description!.isNotEmpty) ...[
                      SizedBox(height: 16.h),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20.w),
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .surface
                              .withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          teamProfile.description!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Theme.of(context).colorScheme.onSurface,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                    Builder(
                      builder: (context) {
                        final userRole = provider.getUserRole();
                        final canEdit = provider.canEditTeam();
                        final canManageMembers = provider.canManageMembers();
                        final canManageRequests = provider.canManageRequests();
                        final isMember = provider.isMember();

                        return Container(
                          margin: EdgeInsets.only(top: 15.h),
                          child: _buildActionButtons(
                            context,
                            provider,
                            userRole,
                            canEdit,
                            canManageMembers,
                            canManageRequests,
                            isMember,
                          ),
                        );
                      },
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 15.h, bottom: 15.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: NumberAndLabel(
                              label: AppLocalizations.of(context)!
                                  .teamTournamentsTitle,
                              number: teamProfile.totalTournaments,
                              hasRightBorder: true,
                              onTap: onTournamentsPressed,
                            ),
                          ),
                          Expanded(
                            child: NumberAndLabel(
                              label: AppLocalizations.of(context)!.winsLabel,
                              number: teamProfile.totalWins,
                              onTap: onWinsPressed,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildMembersSection(
                        context, teamProfile, onMembersPressed),
                    _buildStatsSection(context, teamProfile),
                    SizedBox(height: 24.h), // Bottom padding
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundImage(String imageUrl) {
    final isNetworkImage =
        imageUrl.startsWith('http://') || imageUrl.startsWith('https://');

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: isNetworkImage
              ? NetworkImage(imageUrl)
              : const AssetImage('assets/login.png') as ImageProvider,
          fit: BoxFit.cover,
          onError: (exception, stackTrace) {
            if (kDebugMode) {
              debugPrint('Error loading background image: $exception');
            }
          },
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeamAvatar(BuildContext context, TeamProfileModel team) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Theme.of(context).colorScheme.onPrimary,
          width: 2.h,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 2.h,
            blurRadius: 5.h,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: CircleAvatar(
        maxRadius: 46.h,
        backgroundImage: (team.image != null &&
                team.image!.isNotEmpty &&
                (team.image!.startsWith('http://') ||
                    team.image!.startsWith('https://')))
            ? NetworkImage(team.image!)
            : const AssetImage('assets/team_image.jpg') as ImageProvider,
      ),
    );
  }

  Widget _buildMembersSection(BuildContext context, TeamProfileModel team,
      VoidCallback? onMembersPressed) {
    if (kDebugMode) {
      debugPrint(
          '_buildMembersSection: team.members.length = ${team.members.length}');
    }

    return GestureDetector(
      onTap: onMembersPressed,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.primary.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.people,
                      color: AppTheme.primary,
                      size: 20.h,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      AppLocalizations.of(context)!.membersLabel,
                      style: TextStyle(
                        fontSize: 16.h,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${team.members.length}',
                        style: TextStyle(
                          fontSize: 14.h,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primary,
                        ),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14.h,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.5),
                    ),
                  ],
                ),
              ],
            ),
            if (team.members.isEmpty) ...[
              SizedBox(height: 16.h),
              Center(
                child: Text(
                  'No hay miembros disponibles',
                  style: TextStyle(
                    fontSize: 14.h,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6),
                  ),
                ),
              ),
            ] else ...[
              SizedBox(height: 12.h),
              SizedBox(
                height: 80.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: team.members.length > 5 ? 6 : team.members.length,
                  itemBuilder: (context, index) {
                    // Si hay más de 5 miembros y estamos en el último índice, mostrar indicador
                    if (team.members.length > 5 && index == 5) {
                      final remainingCount = team.members.length - 5;
                      return Container(
                        margin: EdgeInsets.only(right: 12.w),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 44.h,
                              height: 44.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppTheme.primary.withOpacity(0.1),
                                border: Border.all(
                                  color: AppTheme.primary.withOpacity(0.3),
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  '+$remainingCount',
                                  style: TextStyle(
                                    fontSize: 14.h,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primary,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 4.h),
                            SizedBox(
                              width: 70.w,
                              child: Text(
                                'Ver más',
                                style: TextStyle(
                                  fontSize: 10.h,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.primary,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    final member = team.members[index];
                    return Container(
                      margin: EdgeInsets.only(right: 12.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 22.h,
                            backgroundImage: member.profileImage != null
                                ? (member.profileImage!.startsWith('http://') ||
                                        member.profileImage!
                                            .startsWith('https://')
                                    ? NetworkImage(member.profileImage!)
                                    : AssetImage(member.profileImage!)
                                        as ImageProvider)
                                : const AssetImage('assets/user_image.jpg'),
                          ),
                          SizedBox(height: 4.h),
                          SizedBox(
                            width: 70.w,
                            child: Text(
                              '${member.firstName} ${member.lastName}',
                              style: TextStyle(
                                fontSize: 10.h,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context, TeamProfileModel team) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.statisticsLabel,
            style: TextStyle(
              fontSize: 16.h,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  AppLocalizations.of(context)!.tournamentsPlayedLabel,
                  team.totalTournaments.toString(),
                  Icons.emoji_events,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: _buildStatCard(
                  context,
                  AppLocalizations.of(context)!.winsLabel,
                  team.totalWins.toString(),
                  Icons.star,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primary.withOpacity(0.1),
            AppTheme.primary.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primary.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppTheme.primary,
              size: 24.h,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 24.h,
              fontWeight: FontWeight.bold,
              color: AppTheme.primary,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.h,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    TeamProfileProvider provider,
    TeamUserRole userRole,
    bool canEdit,
    bool canManageMembers,
    bool canManageRequests,
    bool isMember,
  ) {
    // Creator/Leader actions - Only Edit Profile and Requests
    if (canEdit) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: ProfileElevatedButton(
                  label: AppLocalizations.of(context)!.editProfile,
                  onPressed: () =>
                      _showEditTeamProfileDialog(context, provider),
                ),
              ),
            ),
            if (canManageRequests)
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 8.w),
                  child: ProfileElevatedButton(
                    label:
                        '${AppLocalizations.of(context)!.requests} (${provider.teamRequests.length})',
                    onPressed: () =>
                        _showManageRequestsDialog(context, provider),
                  ),
                ),
              ),
          ],
        ),
      );
    }

    // Member actions
    if (isMember) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: ProfileElevatedButton(
          label: 'Leave Team',
          onPressed: () => _showLeaveTeamDialog(context, provider),
        ),
      );
    }

    // Non-member actions
    // Wait for requests to load before checking
    if (provider.isLoadingRequests && provider.teamRequests.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: ProfileElevatedButton(
          label: AppLocalizations.of(context)!.requestAccess,
          onPressed: null, // Disabled while loading
        ),
      );
    }

    final hasPendingRequest = provider.hasPendingRequest();

    if (kDebugMode) {
      debugPrint('_buildActionButtons: hasPendingRequest = $hasPendingRequest');
      debugPrint(
          '_buildActionButtons: teamRequests.length = ${provider.teamRequests.length}');
      debugPrint(
          '_buildActionButtons: currentUserId = ${provider.currentUserId}');
      debugPrint(
          '_buildActionButtons: isLoadingRequests = ${provider.isLoadingRequests}');
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: ProfileElevatedButton(
        label: hasPendingRequest
            ? AppLocalizations.of(context)!.waitingForApproval
            : AppLocalizations.of(context)!.requestAccess,
        onPressed: hasPendingRequest || provider.isPerformingAction
            ? null
            : () => _requestAccess(context, provider),
      ),
    );
  }

  void _showEditTeamProfileDialog(
      BuildContext context, TeamProfileProvider provider) {
    showDialog(
      context: context,
      builder: (dialogContext) => EditTeamProfileDialog(
        team: provider.teamProfile!,
        provider: provider,
      ),
    ).then((updated) {
      if (updated == true && context.mounted) {
        provider.refreshData();
      }
    });
  }

  void _showManageRequestsDialog(
      BuildContext context, TeamProfileProvider provider) {
    showDialog(
      context: context,
      builder: (dialogContext) => ManageTeamRequestsDialog(
        requests: provider.teamRequests,
        provider: provider,
      ),
    ).then((_) {
      // Refresh data after managing requests
      if (context.mounted) {
        provider.refreshData();
      }
    });
  }

  void _showLeaveTeamDialog(
      BuildContext context, TeamProfileProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Leave Team'),
        content: const Text('Are you sure you want to leave this team?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final success = await provider.leaveTeam();
              if (context.mounted) {
                if (success) {
                  Navigator.of(context).pop(); // Go back to previous screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Left team successfully')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Error leaving team')),
                  );
                }
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Leave'),
          ),
        ],
      ),
    );
  }

  Future<void> _requestAccess(
      BuildContext context, TeamProfileProvider provider) async {
    final success = await provider.requestAccess();
    if (context.mounted) {
      if (success) {
        // The provider already reloads requests internally, but we can ensure it here too
        // The Consumer will automatically rebuild when notifyListeners() is called
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.accessRequestSent),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.errorSendingRequest),
          ),
        );
      }
    }
  }
}
