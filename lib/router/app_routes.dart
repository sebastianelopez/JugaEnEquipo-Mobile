import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:jugaenequipo/presentation/chat/screens/chat_screen.dart';
import 'package:jugaenequipo/presentation/messages/screens/messages_screen.dart';
import 'package:jugaenequipo/presentation/profile/screens/profile_screen.dart';
import 'package:jugaenequipo/presentation/screens.dart';
import 'package:jugaenequipo/presentation/settings/screens/settings_screen.dart';
import 'package:jugaenequipo/presentation/splash/screens/splash_screen.dart';
import 'package:jugaenequipo/presentation/tabs/screens/tabs_screen.dart';

class AppRoutes {
  static const initialRoute = 'splash';

  static final menuOptions = <MenuOptionModel>[
    MenuOptionModel(
        route: 'register',
        name: 'Register Screen',
        screen: const RegisterScreen(),
        icon: Icons.list_alt_outlined),
    MenuOptionModel(
        route: 'login',
        name: 'Login Screen',
        screen: const LoginScreen(),
        icon: Icons.list_alt_outlined),
    MenuOptionModel(
        route: 'splash', name: 'Splash Screen', screen: const SplashScreen()),
  ];

  static final mainNavigationOptions = <MainNavigationOptionModel>[
    MainNavigationOptionModel(
        route: 'home', icon: Icons.home),
    MainNavigationOptionModel(
        route: 'teams',
        icon: Icons.supervisor_account),
    MainNavigationOptionModel(route: 'createPost', icon: Icons.add_circle),
    MainNavigationOptionModel(
        route: 'tournaments',
        icon: Icons.emoji_events),
    MainNavigationOptionModel(
        route: 'notifications',
        screen: const NotificationsScreen(),
        icon: Icons.notifications)
  ];

  static List<MenuOptionModel> getDrawerOptions([BuildContext? context]) {
    return [
      MenuOptionModel(
          route: 'profile',
          name: context != null
              ? AppLocalizations.of(context)!.drawerProfileLabel
              : '',
          screen: const ProfileScreen()),
          MenuOptionModel(
          route: 'settings',
          name: context != null
              ? AppLocalizations.of(context)!.drawerSettingsLabel
              : '',
          screen: const SettingsScreen()),
    ];
  }

  static final otherRoutes = <MenuOptionModel>[
    MenuOptionModel(
        route: 'tabs',
        name: 'tabs screen',
        screen: const TabsScreen()),
    MenuOptionModel(
        route: 'messages',
        name: 'Messages Screen',
        screen: const MessagesScreen()),
    MenuOptionModel(
        route: 'chat', name: 'Chat Screen', screen: const ChatScreen()),
  ];

  static Map<String, Widget Function(BuildContext)> getAppRoutes() {
    Map<String, Widget Function(BuildContext)> appRoutes = {};

    appRoutes
        .addAll({'splash': (BuildContext context) => const SplashScreen()});

    for (final option in menuOptions) {
      appRoutes.addAll({option.route: (BuildContext context) => option.screen});
    }

    for (final option in mainNavigationOptions) {
      appRoutes.addAll({
        option.route: (BuildContext context) => option.screen ?? Container()
      });
    }

    for (final option in getDrawerOptions()) {
      appRoutes.addAll({option.route: (BuildContext context) => option.screen});
    }

    for (final option in otherRoutes) {
      appRoutes.addAll({option.route: (BuildContext context) => option.screen});
    }

    return appRoutes;
  }

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(builder: (context) => const SplashScreen());
  }
}
