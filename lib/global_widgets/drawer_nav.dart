import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/providers/providers.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:jugaenequipo/global_widgets/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:jugaenequipo/router/app_routes.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DrawerNav extends StatelessWidget {
  const DrawerNav({super.key});

  @override
  Widget build(BuildContext context) {
    final drawerOptions = AppRoutes.getDrawerOptions(context).toList();
    final user = Provider.of<UserProvider>(context).user;
    final storage = const FlutterSecureStorage();

    return Drawer(
      width: 280.w,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 250.h,
            child: DrawerHeader(
              decoration: const BoxDecoration(
                color: AppTheme.primary,
                image: DecorationImage(
                  image: NetworkImage(
                    "https://static.wikia.nocookie.net/onepiece/images/a/af/Monkey_D._Luffy_Anime_Dos_A%C3%B1os_Despu%C3%A9s_Infobox.png/revision/latest?cb=20200616015904&path-prefix=es",
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    bottom: 8.0.h,
                    left: 4.0.w,
                    child: Text(
                      user!.firstName,
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
                    Navigator.pushNamed(context, option.route);
                  },
                );
              }),
              Row(
                children: [
                  Container(
                      margin: EdgeInsets.only(right: 30.0.w, left: 15.0.h),
                      child: Text(
                          AppLocalizations.of(context)!.drawerlanguageLabel,
                          style: TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 15.sp))),
                  const LanguageDropdown(showLabel: true),
                ],
              ),
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
                  await storage.delete(key: 'access_token');
                  Navigator.pushReplacementNamed(context, 'login');
                  return;
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
