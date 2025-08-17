import 'package:flutter/material.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:jugaenequipo/presentation/messages/screens/messages_screen.dart';
import 'package:jugaenequipo/providers/providers.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

double _toolbarHeight = 50.0.h;

class MainNavbar extends StatelessWidget implements PreferredSizeWidget {
  const MainNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    UserModel? user = Provider.of<UserProvider>(context).user;
    final searchProvider = Provider.of<SearchProvider>(context);
    final hasSuggestions =
        searchProvider.suggestions.isNotEmpty || searchProvider.isLoading;
    final double dropdownMaxHeight = 220.0.h;

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
              labelStyle: const TextStyle()),
          onChanged: (value) {
            if (value.trim().isEmpty) {
              searchProvider.clearResults();
              return;
            }
            searchProvider.onQueryChanged(value);
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
          padding: const EdgeInsets.symmetric(vertical: 7.0),
          child: CircleAvatar(
            backgroundImage: (user?.profileImage != null &&
                    (user!.profileImage?.isNotEmpty ?? false) &&
                    (user.profileImage!.startsWith('http://') ||
                        user.profileImage!.startsWith('https://')))
                ? NetworkImage(user.profileImage!)
                : const AssetImage('assets/user_image.jpg') as ImageProvider,
            radius: 16.w,
            backgroundColor: Colors.white,
          ),
        ),
      ),
      shadowColor: Colors.black,
      bottom: hasSuggestions
          ? PreferredSize(
              preferredSize: Size.fromHeight(dropdownMaxHeight),
              child: Container(
                alignment: Alignment.topLeft,
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 16.0.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.0.h),
                    bottomRight: Radius.circular(10.0.h),
                  ),
                ),
                child: SizedBox(
                  height: dropdownMaxHeight,
                  child: Column(
                    children: [
                      if (searchProvider.isLoading)
                        const LinearProgressIndicator(minHeight: 2),
                      Expanded(
                        child: ListView.separated(
                          padding: EdgeInsets.zero,
                          itemCount: searchProvider.suggestions.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final suggestion =
                                searchProvider.suggestions[index];
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage: (suggestion.profileImage !=
                                            null &&
                                        suggestion.profileImage!.isNotEmpty &&
                                        (suggestion.profileImage!
                                                .startsWith('http://') ||
                                            suggestion.profileImage!
                                                .startsWith('https://')))
                                    ? NetworkImage(suggestion.profileImage!)
                                    : const AssetImage('assets/user_image.jpg')
                                        as ImageProvider,
                              ),
                              title: Text(
                                suggestion.userName,
                                style: const TextStyle(color: Colors.black),
                              ),
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                searchProvider.clearResults();
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : null,
      actions: [
        IconButton(
          color: Colors.white,
          icon: const Icon(Icons.message),
          iconSize: 30.h,
          onPressed: () {
            //hide keyboard
            FocusScope.of(context).unfocus();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MessagesScreen(),
                fullscreenDialog: true,
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(_toolbarHeight);
}
