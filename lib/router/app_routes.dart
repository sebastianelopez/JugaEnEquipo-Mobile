import 'package:flutter/material.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:jugaenequipo/presentation/advanced_search/screens/advanced_search_screen.dart';
import 'package:jugaenequipo/presentation/chat/screens/chat_screen.dart';
import 'package:jugaenequipo/presentation/messages/screens/messages_screen.dart';
import 'package:jugaenequipo/presentation/profile/screens/profile_screen.dart';
import 'package:jugaenequipo/presentation/screens.dart';
import 'package:jugaenequipo/presentation/settings/screens/settings_screen.dart';
import 'package:jugaenequipo/presentation/splash/screens/splash_screen.dart';
import 'package:jugaenequipo/presentation/tabs/screens/tabs_screen.dart';
import 'package:jugaenequipo/presentation/reset_password/screens/reset_password_screen.dart';
import 'package:jugaenequipo/presentation/reset_password/business_logic/reset_password_provider.dart';
import 'package:jugaenequipo/presentation/home/screens/post_detail_screen.dart';
import 'package:jugaenequipo/presentation/hashtags/screens/hashtags_list_screen.dart';
import 'package:jugaenequipo/presentation/hashtags/screens/hashtag_posts_screen.dart';
import 'package:provider/provider.dart';

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
    MainNavigationOptionModel(route: 'home', icon: Icons.home),
    MainNavigationOptionModel(route: 'teams', icon: Icons.supervisor_account),
    MainNavigationOptionModel(route: 'createPost', icon: Icons.add_circle),
    MainNavigationOptionModel(route: 'tournaments', icon: Icons.emoji_events),
    MainNavigationOptionModel(
        route: 'notifications',
        screen: const NotificationsScreen(),
        icon: Icons.notifications)
  ];

  static List<MenuOptionModel> getDrawerOptions([BuildContext? context]) {
    return [
      MenuOptionModel(
          route: 'my-profile',
          name: context != null
              ? AppLocalizations.of(context)!.drawerProfileLabel
              : '',
          screen: const ProfileScreen()),
      MenuOptionModel(
          route: 'hashtags',
          name: context != null
              ? 'Hashtags'
              : '',
          screen: const HashtagsListScreen()),
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
        route: 'tabs', name: 'tabs screen', screen: const TabsScreen()),
    MenuOptionModel(
        route: 'messages',
        name: 'Messages Screen',
        screen: const MessagesScreen()),
    MenuOptionModel(
        route: 'chat', name: 'Chat Screen', screen: const ChatScreen()),
    MenuOptionModel(
        route: 'search', name: 'Search Screen', screen: const SearchScreen()),
    MenuOptionModel(
        route: 'advanced-search',
        name: 'Advanced Search Screen',
        screen: const AdvancedSearchScreen()),
    MenuOptionModel(
        route: 'team-profile',
        name: 'Team Profile Screen',
        screen: const ProfileScreen(profileType: ProfileType.team)),
    MenuOptionModel(
        route: 'hashtags',
        name: 'Hashtags List Screen',
        screen: const HashtagsListScreen()),
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
    if (settings.name == 'profile') {
      final args = settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        if (args.containsKey('teamId')) {
          return MaterialPageRoute(
            builder: (context) => ProfileScreen(
              teamId: args['teamId'],
              profileType: ProfileType.team,
            ),
          );
        } else if (args.containsKey('userId')) {
          return MaterialPageRoute(
            builder: (context) => ProfileScreen(
              userId: args['userId'],
              profileType: ProfileType.user,
            ),
          );
        }
      }
      return MaterialPageRoute(builder: (context) => const ProfileScreen());
    } else if (settings.name == 'my-profile') {
      return MaterialPageRoute(builder: (context) => const ProfileScreen());
    } else if (settings.name == 'post-detail') {
      final args = settings.arguments as Map<String, dynamic>?;
      final postId = args?['postId'] as String?;
      if (postId != null && postId.isNotEmpty) {
        return MaterialPageRoute(
          builder: (context) => PostDetailScreen(postId: postId),
        );
      }
      // If no postId, redirect to home
      return MaterialPageRoute(
        builder: (context) => const TabsScreen(),
      );
    } else if (settings.name == 'reset-password') {
      final args = settings.arguments as Map<String, dynamic>?;
      final token = args?['token'] as String?;
      if (token != null && token.isNotEmpty) {
        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (_) => ResetPasswordProvider(),
            child: ResetPasswordScreen(token: token),
          ),
        );
      }
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );
    } else if (settings.name == 'hashtag-posts') {
      final args = settings.arguments as Map<String, dynamic>?;
      final hashtag = args?['hashtag'] as String?;
      if (hashtag != null && hashtag.isNotEmpty) {
        return MaterialPageRoute(
          builder: (context) => HashtagPostsScreen(hashtag: hashtag),
        );
      }
      return MaterialPageRoute(
        builder: (context) => const TabsScreen(),
      );
    }

    return MaterialPageRoute(builder: (context) => const SplashScreen());
  }
}
