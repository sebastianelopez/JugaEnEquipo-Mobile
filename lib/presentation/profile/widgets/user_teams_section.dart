import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:jugaenequipo/presentation/profile/screens/profile_screen.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';

class UserTeamsSection extends StatelessWidget {
  final List<TeamModel> teams;

  const UserTeamsSection({super.key, required this.teams});

  @override
  Widget build(BuildContext context) {
    if (teams.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.profileTeamsLabel,
            style: TextStyle(
              fontSize: 16.h,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12.h),
          SizedBox(
            height: 120.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: teams.length,
              itemBuilder: (context, index) {
                final team = teams[index];
                return _buildTeamCard(context, team);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamCard(BuildContext context, TeamModel team) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileScreen(
              teamId: team.id,
              team: team,
              profileType: ProfileType.team,
            ),
          ),
        );
      },
      child: Container(
        width: 200.w,
        margin: EdgeInsets.only(right: 12.w),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: AppTheme.primary.withOpacity( 0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withOpacity( 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60.w,
              height: 60.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.primary.withOpacity( 0.2),
                  width: 2,
                ),
              ),
              child: ClipOval(
                child: team.teamImage != null &&
                        team.teamImage!.isNotEmpty &&
                        (team.teamImage!.startsWith('http://') ||
                            team.teamImage!.startsWith('https://'))
                    ? Image.network(
                        team.teamImage!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Image.asset(
                          'assets/team_image.jpg',
                          fit: BoxFit.cover,
                        ),
                      )
                    : Image.asset(
                        'assets/team_image.jpg',
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    team.name,
                    style: TextStyle(
                      fontSize: 14.h,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primary,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (team.verified == true) ...[
                  SizedBox(width: 4.w),
                  Icon(
                    Icons.verified_rounded,
                    color: AppTheme.primary,
                    size: 16.h,
                  ),
                ],
              ],
            ),
            if (team.games.isNotEmpty) ...[
              SizedBox(height: 4.h),
              Wrap(
                spacing: 4.w,
                alignment: WrapAlignment.center,
                children: team.games.take(2).map((game) {
                  return Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: AppTheme.accent.withOpacity( 0.1),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      game.name,
                      style: TextStyle(
                        fontSize: 10.h,
                        color: AppTheme.accent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
