import 'package:flutter/material.dart';
import 'package:jugaenequipo/theme/app_theme.dart';

class LoadingIcon extends StatelessWidget {
  const LoadingIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        height: 60,
        width: 60,
        decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9), shape: BoxShape.circle),
        child: const CircularProgressIndicator(
          color: AppTheme.primary,
        ));
  }
}
