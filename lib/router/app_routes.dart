import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/models/models.dart';
import 'package:jugaenequipo/presentation/chat/screens/chat_screen.dart';
import 'package:jugaenequipo/presentation/messages/screens/messages_screen.dart';
import 'package:jugaenequipo/presentation/profile/screens/profile_screen.dart';
import 'package:jugaenequipo/presentation/screens.dart';
import 'package:jugaenequipo/presentation/splash/screens/splash_screen.dart';

class AppRoutes {
  static const initialRoute = 'splash';

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
    MainNavigationOption(route: 'createPost', icon: Icons.add_circle),
    MainNavigationOption(
        route: 'tournaments',
        screen: const TournamentsScreen(),
        icon: Icons.emoji_events),
    MainNavigationOption(
        route: 'notifications',
        screen: const NotificationsScreen(),
        icon: Icons.notifications)
  ];

  static List<MenuOption> getDrawerOptions([BuildContext? context]) {
    return [
      MenuOption(
          route: 'profile',
          name: context != null
              ? AppLocalizations.of(context)!.drawerProfileLabel
              : '',
          screen: const ProfileScreen()),
    ];
  }

  static final otherRoutes = <MenuOption>[
    MenuOption(
        route: 'messages',
        name: 'Messages Screen',
        screen: const MessagesScreen()),
    MenuOption(route: 'chat', name: 'Chat Screen', screen: const ChatScreen()),
    MenuOption(route: 'splash', name: 'Splash Screen', screen: const SplashScreen()),
  ];

  static Map<String, Widget Function(BuildContext)> getAppRoutes() {
    Map<String, Widget Function(BuildContext)> appRoutes = {};

    appRoutes.addAll({'login': (BuildContext context) => const LoginScreen()});

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
