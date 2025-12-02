import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:jugaenequipo/presentation/profile/screens/profile_screen.dart';

class UserResultCard extends StatelessWidget {
  final UserModel user;

  const UserResultCard({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 8.h),
      child: ListTile(
        leading: CircleAvatar(
          radius: 24.h,
          backgroundImage: (user.profileImage != null &&
                  user.profileImage!.isNotEmpty &&
                  (user.profileImage!.startsWith('http://') ||
                      user.profileImage!.startsWith('https://')))
              ? NetworkImage(user.profileImage!)
              : const AssetImage('assets/user_image.jpg') as ImageProvider,
        ),
        title: Text(
          user.userName,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          '${user.firstName} ${user.lastName}',
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey[600],
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileScreen(userId: user.id),
            ),
          );
        },
      ),
    );
  }
}

