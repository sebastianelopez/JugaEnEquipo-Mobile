import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';
import 'package:jugaenequipo/presentation/profile/screens/profile_screen.dart';

class TeamResultCard extends StatelessWidget {
  final TeamModel team;

  const TeamResultCard({
    super.key,
    required this.team,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 8.h),
      child: ListTile(
        leading: CircleAvatar(
          radius: 24.h,
          backgroundColor: Colors.blue[100],
          child: Icon(
            Icons.group,
            color: Colors.blue[700],
            size: 24.h,
          ),
        ),
        title: Text(
          team.name,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              team.games.isNotEmpty ? team.games.first.name : 'No games',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
              ),
            ),
            Row(
              children: [
                Icon(
                  (team.verified == true) ? Icons.verified : Icons.pending,
                  size: 16.h,
                  color: (team.verified == true) ? Colors.green : Colors.orange,
                ),
                SizedBox(width: 8.w),
                Text(
                  (team.verified == true)
                      ? AppLocalizations.of(context)!.verifiedStatus
                      : AppLocalizations.of(context)!.pendingStatus,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color:
                        (team.verified == true) ? Colors.green : Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
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
      ),
    );
  }
}

