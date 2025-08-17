import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:jugaenequipo/providers/providers.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';
import 'package:jugaenequipo/router/app_routes.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DrawerNav extends StatelessWidget {
  const DrawerNav({super.key});

  @override
  Widget build(BuildContext context) {
    final drawerOptions = AppRoutes.getDrawerOptions(context).toList();
    UserModel? user = Provider.of<UserProvider>(context).user;
    const storage = FlutterSecureStorage();

    return Drawer(
      width: 280.w,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 250.h,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: AppTheme.primary,
                image: DecorationImage(
                  image: user?.profileImage != null
                      ? NetworkImage(user!.profileImage!)
                      : const AssetImage('assets/user_image.jpg')
                          as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    bottom: 8.0.h,
                    left: 4.0.w,
                    child: Text(
                      user?.firstName ?? 'user',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w900),
                    ),
                  )
                ],
              ),
            ),
          ),
          Column(
            children: [
              ...drawerOptions.map((option) {
                return ListTile(
                  title: Text(option.name,
                      style: TextStyle(
                          fontWeight: FontWeight.w900, fontSize: 15.sp)),
                  onTap: () {
                    // Hide keyboard
                    FocusScope.of(context).unfocus();
                    Navigator.of(context).pushNamed(option.route);
                  },
                );
              }),
              SizedBox(
                height: 50.h,
              ),
            ],
          ),
          TextButton.icon(
            style: ButtonStyle(
              alignment: Alignment.centerLeft,
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
            iconAlignment: IconAlignment.start,
            onPressed: () async {
              if (context.mounted) {
                await storage.delete(key: 'access_token');
                // ignore: use_build_context_synchronously
                Navigator.pushReplacementNamed(context, 'login');
                return;
              }
            },
            icon: Icon(Icons.logout, size: 30.sp),
            label: Text(AppLocalizations.of(context)!.drawerLogoutLabel,
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w900)),
          )
        ],
      ),
    );
  }
}
