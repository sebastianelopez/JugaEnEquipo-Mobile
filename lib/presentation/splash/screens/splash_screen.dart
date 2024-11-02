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
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var token;
  var storage = const FlutterSecureStorage();

  getToken() async {
    token = await storage.read(key: 'access_token');
    print('hay token: $token');
  }

  @override
  void initState() {
    getToken();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(seconds: 3));
      if (token != null) {
        if (mounted) {
          final userProvider =
              Provider.of<UserProvider>(context, listen: false);
          final decodedId = decodeUserIdByToken(token);
          print(decodedId);
          var user = await getUserById(decodedId);
          print(user);
          if (user == null) {
            print('User not found');
            await Navigator.of(context).pushReplacementNamed('login');
            return;
          }
          userProvider.setUser(user!);
          await Navigator.of(context).pushReplacementNamed('tabs');
        }
      } else {
        if (mounted) await Navigator.of(context).pushReplacementNamed('login');
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                  color: Colors.blueGrey,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w900),
            )
          ],
        ),
      ),
    );
  }
}
