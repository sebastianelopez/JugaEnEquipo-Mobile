import 'package:flutter/material.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:jugaenequipo/presentation/messages/screens/messages_screen.dart';
import 'package:jugaenequipo/presentation/search/screens/search_screen.dart';
import 'package:jugaenequipo/presentation/notifications/business_logic/notifications_provider.dart';
import 'package:jugaenequipo/providers/providers.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';
import 'package:jugaenequipo/utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

double _toolbarHeight = 50.0.h;

class MainNavbar extends StatefulWidget implements PreferredSizeWidget {
  const MainNavbar({super.key});

  @override
  State<MainNavbar> createState() => _MainNavbarState();

  @override
  Size get preferredSize => Size.fromHeight(_toolbarHeight);
}

class _MainNavbarState extends State<MainNavbar> {
  @override
  Widget build(BuildContext context) {
    UserModel? user = Provider.of<UserProvider>(context).user;

    return AppBar(
      toolbarHeight: _toolbarHeight,
      centerTitle: true,
      title: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const SearchScreen(),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          );
        },
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 5.0.w),
          constraints: BoxConstraints(maxHeight: 36.0.h),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.all(
              Radius.circular(10.0.h),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0.h),
            child: Row(
              children: [
                SizedBox(width: 12.0.w),
                Icon(Icons.search, size: 20.0.h, color: Colors.grey[600]),
                SizedBox(width: 8.0.w),
                Text(
                  AppLocalizations.of(context)!.navSearchInputLabel,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: AppTheme.primary,
      leadingWidth: 50.0.h,
      leading: GestureDetector(
        onTap: () {
          Scaffold.of(context).openDrawer();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 7.0),
          child: CircleAvatar(
            backgroundImage: (user?.profileImage != null &&
                    (user!.profileImage?.isNotEmpty ?? false) &&
                    (user.profileImage!.startsWith('http://') ||
                        user.profileImage!.startsWith('https://')))
                ? NetworkImage(user.profileImage!)
                : const AssetImage('assets/user_image.jpg') as ImageProvider,
            radius: 16.w,
            backgroundColor: AppTheme.white,
          ),
        ),
      ),
      shadowColor: AppTheme.black,
      actions: [
        Consumer<NotificationsProvider>(
          builder: (context, notificationsProvider, child) {
            final unreadMessagesCount = notificationsProvider.unreadMessagesCount;
            
            return Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  color: Colors.white,
                  icon: const Icon(Icons.message),
                  iconSize: 30.h,
                  onPressed: () {
                    Navigator.push(
                      context,
                      NavigationUtils.slideTransition(
                        const MessagesScreen(),
                        direction: SlideDirection.fromRight,
                        duration: 400,
                        curve: Curves.easeOutExpo,
                      ),
                    );
                  },
                ),
                if (unreadMessagesCount > 0)
                  Positioned(
                    right: 4,
                    top: 4,
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: const BoxDecoration(
                        color: AppTheme.error,
                        shape: BoxShape.circle,
                      ),
                      constraints: BoxConstraints(
                        minWidth: 18.w,
                        minHeight: 18.h,
                      ),
                      child: Center(
                        child: Text(
                          unreadMessagesCount > 99 ? '99+' : unreadMessagesCount.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
