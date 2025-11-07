import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';
import 'package:jugaenequipo/presentation/imageDetail/screens/image_detail_screen.dart';
import 'package:jugaenequipo/providers/providers.dart';
import 'package:provider/provider.dart';

class ProfileAvatar extends StatelessWidget {
  final UserModel profileUser;
  final bool isLoggedUser;

  const ProfileAvatar(
      {super.key, required this.profileUser, required this.isLoggedUser});

  @override
  Widget build(BuildContext context) {
    final imageProvider = Provider.of<ImagePickerProvider>(context);

    return GestureDetector(
      onTap: () async {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return SafeArea(
              child: Wrap(
                children: <Widget>[
                  if (profileUser.profileImage != null &&
                      profileUser.profileImage!.isNotEmpty &&
                      (profileUser.profileImage!.startsWith('http://') ||
                          profileUser.profileImage!.startsWith('https://')))
                    ListTile(
                      leading: const Icon(Icons.visibility),
                      title:
                          Text(AppLocalizations.of(context)!.verifyImageTitle),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ImageDetailScreen(
                                imageUrls: [profileUser.profileImage!],
                                currentIndex: 0),
                          ),
                        );
                      },
                    ),
                  if (isLoggedUser)
                    ListTile(
                      leading: const Icon(Icons.edit),
                      title: Text(AppLocalizations.of(context)!
                          .changeProfileImageTitle),
                      onTap: () async {
                        Navigator.pop(context);
                        await imageProvider.showOptions(context,
                            imageType: ImageType.imageProfile);
                      },
                    ),
                ],
              ),
            );
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Theme.of(context).colorScheme.onPrimary,
            width: 2.h,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity( 0.5),
              spreadRadius: 2.h,
              blurRadius: 5.h,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: CircleAvatar(
            maxRadius: 46.h,
            backgroundImage: (profileUser.profileImage != null &&
                    profileUser.profileImage!.isNotEmpty &&
                    (profileUser.profileImage!.startsWith('http://') ||
                        profileUser.profileImage!.startsWith('https://')))
                ? NetworkImage(profileUser.profileImage!)
                : const AssetImage('assets/user_image.jpg') as ImageProvider),
      ),
    );
  }
}
