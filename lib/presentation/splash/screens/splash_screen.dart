import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/user_use_cases/get_user_use_case.dart';
import 'package:jugaenequipo/providers/providers.dart';
import 'package:jugaenequipo/utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  var token;
  var storage = const FlutterSecureStorage();
  late AnimationController _lottieController;

  @override
  void initState() {
    super.initState();
    _lottieController = AnimationController(vsync: this);
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
  void dispose() {
    _lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.surface.withValues(alpha: 0.8),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 1200),
              tween: Tween<double>(begin: 0.0, end: 1.0),
              curve: Curves.easeOutBack,
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, -40 * (0 - value)),
                  child: Opacity(
                    opacity: value.clamp(0.0, 1.0),
                    child: Text(
                      "Juga en Equipo",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                );
              },
            ),
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 1500),
              tween: Tween<double>(begin: 0.0, end: 1.0),
              curve: Curves.elasticOut,
              child: SizedBox(
                width: 200.w,
                height: 200.h,
                child: Lottie.asset(
                  'assets/gamecontrollerlottie.json',
                  controller: _lottieController,
                  onLoaded: (composition) {
                    final originalMs = composition.duration.inMilliseconds;
                    final targetMs = (originalMs * 0.5).round();
                    _lottieController.duration =
                        Duration(milliseconds: targetMs);
                    _lottieController.repeat(reverse: true);
                  },
                  frameRate: FrameRate.max,
                ),
              ),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value * 1.5,
                  child: child,
                );
              },
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}
