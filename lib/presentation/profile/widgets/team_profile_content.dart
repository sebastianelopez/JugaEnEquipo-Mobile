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

        return _buildContent(context, teamProfile);
      },
    );
  }

  Widget _buildContent(BuildContext context, TeamProfileModel teamProfile) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        color: AppTheme.primary,
        padding: EdgeInsets.only(top: 50.h),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(top: 80.h),
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
                  if (teamProfile.description != null) ...[
                    SizedBox(height: 8.h),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Text(
                        teamProfile.description!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12.h,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.8),
                        ),
                      ),
                    ),
                  ],
                  Container(
                    margin: EdgeInsets.only(top: 15.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ProfileElevatedButton(
                          label: AppLocalizations.of(context)!
                              .viewMembersButtonLabel,
                          onPressed: onMembersPressed,
                        ),
                        ProfileElevatedButton(
                          label:
                              AppLocalizations.of(context)!.contactButtonLabel,
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15.h, bottom: 15.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Builder(
                            builder: (context) {
                              if (kDebugMode) {
                                debugPrint(
                                    'TeamProfileContent: Showing ${teamProfile.members.length} members');
                              }
                              return NumberAndLabel(
                                label:
                                    AppLocalizations.of(context)!.membersLabel,
                                number: teamProfile.members.length,
                                hasRightBorder: true,
                                onTap: onMembersPressed,
                              );
                            },
                          ),
                        ),
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
                  _buildMembersSection(context, teamProfile),
                  _buildStatsSection(context, teamProfile),
                ],
              ),
            ),
            Positioned(
              top: -40.h,
              child: _buildTeamAvatar(context, teamProfile),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamAvatar(BuildContext context, TeamProfileModel team) {
    return Container(
      width: 80.h,
      height: 80.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 4,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipOval(
        child: team.image != null &&
                team.image!.isNotEmpty &&
                (team.image!.startsWith('http://') ||
                    team.image!.startsWith('https://'))
            ? Image.network(
                team.image!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Image.asset('assets/team_image.jpg', fit: BoxFit.cover),
              )
            : Image.asset('assets/team_image.jpg', fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildMembersSection(BuildContext context, TeamProfileModel team) {
    if (kDebugMode) {
      debugPrint(
          '_buildMembersSection: team.members.length = ${team.members.length}');
    }

    if (team.members.isEmpty) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Miembros del equipo',
              style: TextStyle(
                fontSize: 16.h,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              'No hay miembros disponibles',
              style: TextStyle(
                fontSize: 14.h,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            if (kDebugMode)
              Text(
                'Debug: members list is empty',
                style: TextStyle(
                  fontSize: 10.sp,
                  color: Colors.red,
                ),
              ),
          ],
        ),
      );
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Miembros del equipo',
            style: TextStyle(
              fontSize: 16.h,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.h),
          SizedBox(
            height: 60.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: team.members.length,
              itemBuilder: (context, index) {
                final member = team.members[index];
                return Container(
                  margin: EdgeInsets.only(right: 12.w),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 20.h,
                        backgroundImage: member.profileImage != null
                            ? (member.profileImage!.startsWith('http://') ||
                                    member.profileImage!.startsWith('https://')
                                ? NetworkImage(member.profileImage!)
                                : AssetImage(member.profileImage!)
                                    as ImageProvider)
                            : const AssetImage('assets/user_image.jpg'),
                      ),
                      SizedBox(height: 4.h),
                      SizedBox(
                        width: 60.w,
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
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.primary.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: AppTheme.primary,
            size: 24.h,
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 20.h,
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
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
