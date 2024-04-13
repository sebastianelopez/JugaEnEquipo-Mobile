import 'package:flutter/material.dart';

import 'package:jugaenequipo/models/models.dart';
import 'package:jugaenequipo/presentation/screens.dart';

class AppRoutes {
  static const initialRoute = 'login';

  static final menuOptions = <MenuOption>[
    MenuOption(
        route: 'register',
        name: 'Register Screen',
        screen: const RegisterScreen(),
        icon: Icons.list_alt_outlined),
    MenuOption(
        route: 'login',
        name: 'Login Screen',
        screen: const LoginScreen(),
        icon: Icons.list_alt_outlined),
  ];

  static final mainNavigationOptions = <MainNavigationOption>[
    MainNavigationOption(
        route: 'home', screen: const HomeScreen(), icon: Icons.home),
    MainNavigationOption(
        route: 'teams',
        screen: const TeamsScreen(),
        icon: Icons.supervisor_account),
    MainNavigationOption(
        route: 'teams', screen: const TeamsScreen(), icon: Icons.add_circle),
    MainNavigationOption(
        route: 'tournaments', screen: const TournamentsScreen(), icon: Icons.emoji_events),
    MainNavigationOption(
        route: 'notifications', screen: const NotificationsScreen(), icon: Icons.notifications)
  ];

  static Map<String, Widget Function(BuildContext)> getAppRoutes() {
    Map<String, Widget Function(BuildContext)> appRoutes = {};

    appRoutes.addAll({'login': (BuildContext context) => const LoginScreen()});

    for (final option in menuOptions) {
      appRoutes.addAll({option.route: (BuildContext context) => option.screen});
    }

    for (final option in mainNavigationOptions) {
      appRoutes.addAll({option.route: (BuildContext context) => option.screen});
    }

    return appRoutes;
  }

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(builder: (context) => const LoginScreen());
  }
}
