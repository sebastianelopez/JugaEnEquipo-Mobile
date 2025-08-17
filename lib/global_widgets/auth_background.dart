import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;

  // ignore: use_key_in_widget_constructors
  const AuthBackground({Key? key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ShaderMask(
            shaderCallback: (Rect bounds) {
              return const LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black,
                    Colors.transparent,
                  ],
                  stops: [
                    0.05,
                    0.9
                  ]).createShader(bounds);
            },
            blendMode: BlendMode.darken,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/login.png'),
                  fit: BoxFit.cover,
                ),
              ),
            )),
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: child,
        )
      ],
    );
  }
}
