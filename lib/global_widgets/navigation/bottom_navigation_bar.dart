import 'package:flutter/material.dart';
import 'package:jugaenequipo/providers/providers.dart';
import 'package:jugaenequipo/router/app_routes.dart';
import 'package:jugaenequipo/global_widgets/create_post.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:provider/provider.dart';

class BottomNavigationBarCustom extends StatefulWidget {
  const BottomNavigationBarCustom({Key? key}) : super(key: key);

  @override
  State<BottomNavigationBarCustom> createState() => _BottomNavigationBarState();
}

class _BottomNavigationBarState extends State<BottomNavigationBarCustom> {
  final mainNavigationOptions = AppRoutes.mainNavigationOptions;

  @override
  Widget build(BuildContext context) {
    final navigation = Provider.of<NavigationProvider>(context);

    void onItemTapped(int index) {
      if (mainNavigationOptions[index].route == "notifications") {
        FocusScope.of(context).unfocus();
        Navigator.pushNamed(context, mainNavigationOptions[index].route);
      } else if (mainNavigationOptions[index].route == "createPost") {
        showModalBottomSheet(
          context: context,
          constraints: BoxConstraints(
            maxHeight: 600.h,
            maxWidth: 1200,
          ),
          isScrollControlled: true,
          useSafeArea: true,
          builder: (BuildContext context) {
            return CreatePost();
          },
        );
      } else {
        navigation.setCurrentPage = index;
      }
    }

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      currentIndex: navigation.currentPage,
      onTap: (i) => onItemTapped(i),
      selectedItemColor: Colors.red[900],
      items: mainNavigationOptions.map((option) {
        return BottomNavigationBarItem(
          icon: Icon(
            size: 24.h,
            option.icon,
          ),
          label: '',
        );
      }).toList(),
    );
  }
}
