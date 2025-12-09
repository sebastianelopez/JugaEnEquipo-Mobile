import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jugaenequipo/presentation/messages/business_logic/messages_provider.dart';
import 'package:jugaenequipo/providers/providers.dart';
import 'package:jugaenequipo/providers/theme_provider.dart';
import 'package:jugaenequipo/router/app_routes.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:jugaenequipo/share_preferences/preferences.dart';
import 'package:jugaenequipo/presentation/notifications/business_logic/notifications_provider.dart';
import 'package:jugaenequipo/services/deep_link_service.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:jugaenequipo/presentation/home/business_logic/home_screen_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences.init();

  // Inicializar el servicio de deep linking
  await DeepLinkService().initialize();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => ThemeProvider(isDarkmode: Preferences.isDarkmode)),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => PostProvider()),
        ChangeNotifierProvider(create: (_) => ImagePickerProvider()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
        ChangeNotifierProvider(create: (_) => TeamSearchProvider()),
        ChangeNotifierProvider(
          create: (_) => MessagesProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => HomeScreenProvider(context: context),
        ),
        ChangeNotifierProvider(
          create: (context) {
            final provider = NotificationsProvider();
            // Setup callback for post moderation notifications
            provider.onPostModerated = (notification) {
              _handlePostModerated(context, notification);
            };
            provider.initialize();
            return provider;
          },
        ),
      ],
      child: const MyApp(),
    ),
  );
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// Handle post moderated notifications
void _handlePostModerated(
    BuildContext providerContext, NotificationModel notification) {
  debugPrint('=== POST_MODERATED notification received ===');
  debugPrint('Notification postId: ${notification.postId}');

  // Use navigator key to get current context
  final context = navigatorKey.currentContext;
  if (context == null) {
    debugPrint('Navigator context is null, cannot remove post');
    return;
  }

  // Try to get the HomeScreenProvider to remove the optimistic post
  try {
    final homeProvider =
        Provider.of<HomeScreenProvider>(context, listen: false);

    debugPrint(
        'HomeScreenProvider found, current posts count: ${homeProvider.posts.length}');

    // Remove the optimistic post if postId is available
    if (notification.postId != null && notification.postId!.isNotEmpty) {
      debugPrint('Searching for post with ID: ${notification.postId}');

      // Log all post IDs for debugging
      for (var i = 0; i < homeProvider.posts.length; i++) {
        debugPrint('Post[$i] ID: ${homeProvider.posts[i].id}');
      }

      final postIndex = homeProvider.posts
          .indexWhere((post) => post.id == notification.postId);

      if (postIndex != -1) {
        debugPrint('Found post at index $postIndex, removing...');
        homeProvider.posts.removeAt(postIndex);
        homeProvider.notifyListeners();
        debugPrint('✅ Post optimista eliminado: ${notification.postId}');
        debugPrint('Remaining posts count: ${homeProvider.posts.length}');
      } else {
        debugPrint('⚠️ Post not found in feed with ID: ${notification.postId}');
      }
    } else {
      debugPrint('⚠️ Notification postId is null or empty');
    }
  } catch (e, stackTrace) {
    // HomeScreenProvider might not be available in all contexts
    debugPrint('❌ Could not remove optimistic post: $e');
    debugPrint('Stack trace: $stackTrace');
  }

  // Show snackbar
  final localizations = AppLocalizations.of(context);
  if (localizations != null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          localizations.notificationPostModerated(''),
        ),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: localizations.okButton,
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (context) => InternalizationProvider(),
      builder: (context, child) {
        final internalization = Provider.of<InternalizationProvider>(context);

        return ScreenUtilInit(
          designSize: const Size(375, 812),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) => MaterialApp(
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            theme: Provider.of<ThemeProvider>(context).currentTheme ==
                    ThemeData.dark()
                ? AppTheme.darkTheme
                : AppTheme.lightTheme,
            title: 'Juga en Equipo',
            initialRoute: AppRoutes.initialRoute,
            routes: AppRoutes.getAppRoutes(),
            onGenerateRoute: AppRoutes.onGenerateRoute,
            locale: internalization.currentlanguage,
            supportedLocales: const [
              Locale('en', 'US'),
              Locale('es', 'AR'),
              Locale('pt', 'BR'),
            ],
            localizationsDelegates: AppLocalizations.localizationsDelegates,
          ),
        );
      });
}
