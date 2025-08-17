import 'package:flutter/material.dart';
import 'package:jugaenequipo/providers/providers.dart';
import 'package:jugaenequipo/router/app_routes.dart';
import 'package:jugaenequipo/global_widgets/create_post.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class BottomNavigationBarCustom extends StatefulWidget {
  const BottomNavigationBarCustom({super.key});

  @override
  State<BottomNavigationBarCustom> createState() => _BottomNavigationBarState();
}

class _BottomNavigationBarState extends State<BottomNavigationBarCustom> {
  final mainNavigationOptions = AppRoutes.mainNavigationOptions;
  late PostProvider postProvider;
  late ImagePickerProvider imageProvider;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      postProvider = Provider.of<PostProvider>(context, listen: false);
      imageProvider = Provider.of<ImagePickerProvider>(context, listen: false);
    });
  }

  Future<void> _showCreatePostModal() async {
    try {
      postProvider.generatePostId();
      await showModalBottomSheet(
        context: context,
        constraints: BoxConstraints(
          maxHeight: 600.h,
          maxWidth: MediaQuery.of(context).size.width,
        ),
        isScrollControlled: true,
        useSafeArea: true,
        builder: (BuildContext context) => CreatePost(),
      );
    } catch (e) {
      debugPrint('Error showing modal: $e');
    } finally {
      postProvider.clearPostId();
      imageProvider.clearMediaFileList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final navigation = Provider.of<NavigationProvider>(context);

    void onItemTapped(int index) {
      if (mainNavigationOptions[index].route == "notifications") {
        FocusScope.of(context).unfocus();
        Navigator.pushNamed(context, mainNavigationOptions[index].route);
      } else if (mainNavigationOptions[index].route == "createPost") {
        _showCreatePostModal();
      } else {
        navigation.setCurrentPage = index;
      }
    }

    return BottomNavigationBar(
      currentIndex: navigation.currentPage,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      onTap: (i) => onItemTapped(i),
      selectedItemColor: Theme.of(context).colorScheme.primary,
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
