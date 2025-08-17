import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/user_use_cases/get_user_use_case.dart';
import 'package:jugaenequipo/providers/providers.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:jugaenequipo/utils/utils.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var token;
  var storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      debugPrint('Starting splash screen initialization...');
      token = await storage.read(key: 'access_token');
      debugPrint('Token read result: ${token != null ? 'exists' : 'null'}');

      if (!mounted) return;

      debugPrint('Starting 3 second delay...');
      await Future.delayed(const Duration(seconds: 3));
      debugPrint('Delay completed');

      if (!mounted) return;

      if (token != null) {
        debugPrint('Token exists, attempting to decode and fetch user...');
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        final decodedId = decodeUserIdByToken(token);
        debugPrint('Decoded user ID: $decodedId');

        // Add timeout and error handling for user fetch
        final user = await Future.any([
          getUserById(decodedId).timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              debugPrint('User fetch timeout');
              return null;
            },
          ),
          Future.delayed(const Duration(seconds: 10), () => null)
        ]).catchError((error) {
          debugPrint('Error fetching user: $error');
          return null;
        });

        if (!mounted) return;

        if (user == null) {
          debugPrint('User fetch failed, navigating to login...');
          await Navigator.of(context).pushReplacementNamed('login');
          return;
        }

        debugPrint('User fetch successful, navigating to tabs...');
        userProvider.setUser(user);
        await Navigator.of(context).pushReplacementNamed('tabs');
      } else {
        debugPrint('No token found, navigating to login...');
        await Navigator.of(context).pushReplacementNamed('login');
      }
    } catch (e) {
      debugPrint('Error in splash screen: $e');
      if (mounted) {
        await Navigator.of(context).pushReplacementNamed('login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 50.h),
              child: LoadingAnimationWidget.flickr(
                leftDotColor: AppTheme.primary,
                rightDotColor: AppTheme.black,
                size: 200.h,
              ),
            ),
            Text(
              "Juga en Equipo",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w900),
            )
          ],
        ),
      ),
    );
  }
}
