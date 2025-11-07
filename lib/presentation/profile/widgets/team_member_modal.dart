import 'package:flutter/material.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:jugaenequipo/presentation/profile/screens/profile_screen.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TeamMemberModal extends StatelessWidget {
  final String title;
  final List<UserModel> members;

  const TeamMemberModal({
    super.key,
    required this.title,
    required this.members,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.people,
                    color: Colors.white,
                    size: 24.h,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.h,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: members.length,
                itemBuilder: (context, index) {
                  final member = members[index];
                  return _buildMemberTile(context, member);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberTile(BuildContext context, UserModel member) {
    return ListTile(
      onTap: () {
        Navigator.of(context).pop();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileScreen(
              userId: member.id,
              profileType: ProfileType.user,
            ),
          ),
        );
      },
      leading: CircleAvatar(
        radius: 24.h,
        backgroundImage: member.profileImage != null
            ? (member.profileImage!.startsWith('http://') ||
                    member.profileImage!.startsWith('https://')
                ? NetworkImage(member.profileImage!)
                : AssetImage(member.profileImage!) as ImageProvider)
            : const AssetImage('assets/user_image.jpg'),
      ),
      title: Text(
        '${member.firstName} ${member.lastName}',
        style: TextStyle(
          fontSize: 16.h,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        '@${member.userName}',
        style: TextStyle(
          fontSize: 14.h,
          color: Theme.of(context)
              .colorScheme
              .onSurface
              .withOpacity( 0.7),
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16.h,
        color: Theme.of(context)
            .colorScheme
            .onSurface
            .withOpacity( 0.5),
      ),
    );
  }
}
