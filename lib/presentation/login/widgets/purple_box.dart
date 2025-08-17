import 'package:flutter/material.dart';
import 'package:jugaenequipo/theme/app_theme.dart';

// ignore: use_key_in_widget_constructors
class PurpleBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: size.height * 0.4,
      decoration: _purpleBackground(),
      child: Stack(children: [
        Positioned(
          top: 90,
          left: 30,
          child: _Bubble(),
        ),
        Positioned(
          top: -40,
          left: -30,
          child: _Bubble(),
        ),
        Positioned(
          top: -50,
          right: -20,
          child: _Bubble(),
        ),
        Positioned(
          bottom: -50,
          left: 10,
          child: _Bubble(),
        ),
        Positioned(
          bottom: 120,
          right: 20,
          child: _Bubble(),
        )
      ]),
    );
  }

  BoxDecoration _purpleBackground() => BoxDecoration(
          gradient: LinearGradient(colors: [
        AppTheme.primary,
        AppTheme.primary.withValues(alpha: 0.85),
      ]));
}

class _Bubble extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: AppTheme.white.withValues(alpha: 0.05)),
    );
  }
}
