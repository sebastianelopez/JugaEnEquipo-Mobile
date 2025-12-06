import 'package:flutter/material.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:jugaenequipo/presentation/profile/screens/profile_screen.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ParticipatingTeamItem extends StatelessWidget {
  final TeamModel team;

  const ParticipatingTeamItem({
    super.key,
    required this.team,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: double.infinity,
        ),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Team Avatar - tamaño fijo
            SizedBox(
              width: 40.w,
              height: 40.w,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: _buildTeamAvatar(),
              ),
            ),
            SizedBox(width: 10.w),
            // Team Name - flexible con constraints
            Flexible(
              fit: FlexFit.tight,
              child: Text(
                team.name,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 4.w),
            // Arrow icon - tamaño fijo
            Icon(
              Icons.chevron_right,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
              size: 16.w,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamAvatar() {
    final hasImage = team.image != null &&
        team.image!.isNotEmpty &&
        (team.image!.startsWith('http://') || team.image!.startsWith('https://'));

    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        color: AppTheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: hasImage
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.network(
                team.image!,
                width: 40.w,
                height: 40.w,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => _buildDefaultAvatar(),
              ),
            )
          : _buildDefaultAvatar(),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        color: AppTheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Icon(
        Icons.group,
        color: AppTheme.primary,
        size: 20.w,
      ),
    );
  }
}

