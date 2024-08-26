import 'package:flutter/material.dart';
import 'package:jugaenequipo/presentation/splash/business_logic/splash_provider.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:jugaenequipo/presentation/chat/business_logic/chat_provider.dart';
import 'package:jugaenequipo/presentation/chat/widgets/widgets.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SplashProvider(context),
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 50),
                child: LoadingAnimationWidget.flickr(
                  leftDotColor: AppTheme.primary,
                  rightDotColor: AppTheme.black,
                  size: 200,
                ),
              ),
              const Text(
                "Juga en Equipo",
                style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 18,
                    fontWeight: FontWeight.w900),
              )
            ],
          ),
        ),
      ),
    );
  }
}
