import 'package:flutter/material.dart';

import 'package:jugaenequipo/models/models.dart';
import 'package:jugaenequipo/screens/screens.dart';

class AppRoutes {
  static const initialRoute = 'login';

  static final menuOptions = <MenuOption>[
    MenuOption(
        route: 'home',
        name: 'Alert Screen',
        screen: const HomeScreen(),
        icon: Icons.list_alt_outlined),
    MenuOption(
        route: 'register',
        name: 'Register Screen',
        screen: const RegisterScreen(),
        icon: Icons.list_alt_outlined),
    MenuOption(
        route: 'login',
        name: 'Login Screen',
        screen: const LoginScreen(),
        icon: Icons.list_alt_outlined)
  ];

  static Map<String, Widget Function(BuildContext)> getAppRoutes() {
    Map<String, Widget Function(BuildContext)> appRoutes = {};

    appRoutes.addAll({'login': (BuildContext context) => const LoginScreen()});

    for (final option in menuOptions) {
      appRoutes.addAll({option.route: (BuildContext context) => option.screen});
    }

    return appRoutes;
  }

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(builder: (context) => const LoginScreen());
  }
}
