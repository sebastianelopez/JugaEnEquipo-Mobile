import 'package:flutter/material.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';
import 'package:jugaenequipo/presentation/teams/business_logic/teams_screen_provider.dart';
import 'package:jugaenequipo/presentation/profile/screens/profile_screen.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:provider/provider.dart';

class TeamCard extends StatelessWidget {
  final TeamModel team;

  const TeamCard({super.key, required this.team});

  @override
  Widget build(BuildContext context) {
    Provider.of<TeamsScreenProvider>(context, listen: false);

    return Center(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileScreen(
                teamId: team.id,
                profileType: ProfileType.team,
              ),
            ),
          );
        },
        child: Container(
          height: 150,
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppTheme.black.withValues(alpha: 0.3),
                spreadRadius: 1,
                blurRadius: 5,
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left Image
              ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(12),
                ),
                child: Container(
                  color: Theme.of(context).colorScheme.surface,
                  width: 125,
                  child: (team.teamImage != null &&
                          team.teamImage!.isNotEmpty &&
                          (team.teamImage!.startsWith('http://') ||
                              team.teamImage!.startsWith('https://')))
                      ? Image.network(
                          team.teamImage!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Image.asset(
                            'assets/error.png',
                            fit: BoxFit.cover,
                          ),
                        )
                      : Image.asset('assets/team_image.jpg', fit: BoxFit.cover),
                ),
              ),

              // Right Content
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              team.name,
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 15.h,
                              ),
                            ),
                            SizedBox(width: 5.0.w),
                            if (team.verified)
                              const Icon(Icons.verified_rounded,
                                  color: AppTheme.primary),
                          ],
                        ),
                        SizedBox(height: 4.0.w),
                        Text(
                          AppLocalizations.of(context)!.membersLabel,
                          style: TextStyle(
                            fontSize: 12.h,
                          ),
                        ),
                        SizedBox(height: 3.0.w),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                            team.membersIds.length,
                            (index) => const CircleAvatar(
                              backgroundImage:
                                  AssetImage('assets/user_image.jpg'),
                              maxRadius: 10,
                            ),
                          ),
                        ),
                        SizedBox(height: 4.0.w),
                        Text(AppLocalizations.of(context)!.gamesLabel),
                        SizedBox(height: 3.0.w),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                            team.membersIds.length,
                            (index) => const CircleAvatar(
                              backgroundImage:
                                  AssetImage('assets/user_image.jpg'),
                              maxRadius: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
