import 'package:flutter/material.dart';
import 'package:jugaenequipo/global_widgets/drawer_nav.dart';
import 'package:jugaenequipo/global_widgets/navigation/bottom_navigation_bar.dart';
import 'package:jugaenequipo/global_widgets/navigation/main_navbar.dart';
import 'package:jugaenequipo/presentation/screens.dart';
import 'package:jugaenequipo/providers/providers.dart';
import 'package:provider/provider.dart';

class TabsScreen extends StatelessWidget {
  const TabsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainNavbar(),
      drawer: const DrawerNav(),
      body: _Pages(),
      bottomNavigationBar: const BottomNavigationBarCustom(),
    );
  }
}

class _Pages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final navigation = Provider.of<NavigationProvider>(context);

    return PageView(
      controller: navigation.pageController,
      physics: const NeverScrollableScrollPhysics(),
      onPageChanged: navigation.onPageChanged,
      children: <Widget>[
        const HomeScreen(),
        const TeamsScreen(),
        // The following Container() is a placeholder
        // for the createPost to make match the index
        Container(),
        const TournamentsScreen(),
      ],
    );
  }
}
