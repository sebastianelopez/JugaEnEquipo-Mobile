import 'package:flutter/material.dart';
import 'package:jugaenequipo/theme/app_theme.dart';

class LoadingIcon extends StatefulWidget {
  const LoadingIcon({
    super.key,
  });

  @override
  State<LoadingIcon> createState() => _LoadingIconState();
}

class _LoadingIconState extends State<LoadingIcon>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _pulseController.repeat(reverse: true);
    _rotationController.repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_pulseAnimation, _rotationController]),
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Transform.rotate(
            angle: _rotationController.value * 2 * 3.14159,
            child: Container(
              padding: const EdgeInsets.all(10),
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: AppTheme.white.withOpacity( 0.95),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primary.withOpacity( 0.3),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: CircularProgressIndicator(
                color: AppTheme.primary,
                strokeWidth: 3,
                value: null,
              ),
            ),
          ),
        );
      },
    );
  }
}
