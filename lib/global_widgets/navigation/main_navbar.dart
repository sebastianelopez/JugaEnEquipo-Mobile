import 'package:flutter/material.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

double _toolbarHeight = 50.0.h;

class MainNavbar extends StatelessWidget implements PreferredSizeWidget {
  const MainNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: _toolbarHeight,
      centerTitle: true,
      title: Container(
        margin: EdgeInsets.symmetric(vertical: 5.0.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(10.0.h),
          ),
        ),
        child: TextField(
          decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 10.0.h),
              hintText: AppLocalizations.of(context)!.navSearchInputLabel,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              prefixIcon: const Icon(Icons.search),
              labelStyle: TextStyle()),
          onChanged: (value) {
            // Handle the search input changes here.
          },
        ),
      ),
      backgroundColor: AppTheme.primary,
      leadingWidth: 50.0.h,
      leading: GestureDetector(
        onTap: () {
          Scaffold.of(context).openDrawer();
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 7.0),
          child: CircleAvatar(
            backgroundImage: const AssetImage(
                'assets/login.png'), // Replace with your profile image path
            radius: 16.w,
            backgroundColor: Colors.white,
          ),
        ),
      ),
      shadowColor: Colors.black,
      actions: [
        IconButton(
          color: Colors.white,
          icon: const Icon(Icons.message),
          iconSize: 30.h,
          onPressed: () {
            //hide keyboard
            FocusScope.of(context).unfocus();
            Navigator.pushNamed(context, 'messages');
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(_toolbarHeight);
}
