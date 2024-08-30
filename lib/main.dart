import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:jugaenequipo/providers/providers.dart';
import 'package:jugaenequipo/router/app_routes.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (context) => InternalizationProvider(),
      builder: (context, child) {
        final internalization = Provider.of<InternalizationProvider>(context);

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Juga en Equipo',
          initialRoute: AppRoutes.initialRoute,
          routes: AppRoutes.getAppRoutes(),
          onGenerateRoute: AppRoutes.onGenerateRoute,
          theme: AppTheme.lightTheme,
          locale: internalization.currentlanguage,
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('es', 'AR'),
            Locale('pt', 'BR'),
          ],
          localizationsDelegates: AppLocalizations.localizationsDelegates,
        );
      });
}
