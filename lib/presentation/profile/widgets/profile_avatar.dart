import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:jugaenequipo/providers/providers.dart';
import 'package:provider/provider.dart';

class ProfileAvatar extends StatelessWidget {
  final UserModel profileUser;

  const ProfileAvatar({super.key, required this.profileUser});

  @override
  Widget build(BuildContext context) {
    final imageProvider = Provider.of<ImagePickerProvider>(context);
    UserModel? user = Provider.of<UserProvider>(context).user;
    final isLoggedUser = user?.id == profileUser.id;

    return GestureDetector(
      onTap: () async {
        if(user != null) {
          await imageProvider.showOptions(context,
            imageType: ImageType.imageProfile, userId: user.id);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 2.h,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2.h,
              blurRadius: 5.h,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: CircleAvatar(
          maxRadius: 46.h,
          backgroundImage: NetworkImage(profileUser.profileImage!),
        ),
      ),
    );
  }
}
