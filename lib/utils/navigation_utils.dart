import 'package:flutter/material.dart';

/// Navigation utilities for custom page transitions
class NavigationUtils {
  /// Creates a slide transition from the specified direction
  ///
  /// [child] - The widget to navigate to
  /// [direction] - The direction from which to slide (default: right)
  /// [duration] - Animation duration in milliseconds (default: 300)
  /// [curve] - Animation curve (default: Curves.easeInOut)
  static PageRouteBuilder<T> slideTransition<T extends Object?>(
    Widget child, {
    SlideDirection direction = SlideDirection.fromRight,
    int duration = 300,
    Curve curve = Curves.easeInOut,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionDuration: Duration(milliseconds: duration),
      reverseTransitionDuration: Duration(milliseconds: duration),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final begin = _getOffsetForDirection(direction);
        const end = Offset.zero;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  /// Creates a fade transition
  ///
  /// [child] - The widget to navigate to
  /// [duration] - Animation duration in milliseconds (default: 300)
  /// [curve] - Animation curve (default: Curves.easeInOut)
  static PageRouteBuilder<T> fadeTransition<T extends Object?>(
    Widget child, {
    int duration = 300,
    Curve curve = Curves.easeInOut,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionDuration: Duration(milliseconds: duration),
      reverseTransitionDuration: Duration(milliseconds: duration),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var tween = Tween(begin: 0.0, end: 1.0).chain(
          CurveTween(curve: curve),
        );

        return FadeTransition(
          opacity: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  /// Creates a scale transition
  ///
  /// [child] - The widget to navigate to
  /// [duration] - Animation duration in milliseconds (default: 300)
  /// [curve] - Animation curve (default: Curves.easeInOut)
  static PageRouteBuilder<T> scaleTransition<T extends Object?>(
    Widget child, {
    int duration = 300,
    Curve curve = Curves.easeInOut,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionDuration: Duration(milliseconds: duration),
      reverseTransitionDuration: Duration(milliseconds: duration),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var tween = Tween(begin: 0.0, end: 1.0).chain(
          CurveTween(curve: curve),
        );

        return ScaleTransition(
          scale: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  /// Creates a no transition (instant navigation)
  ///
  /// [child] - The widget to navigate to
  static PageRouteBuilder<T> noTransition<T extends Object?>(Widget child) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    );
  }

  /// Creates a custom transition that animates from a specific position on screen
  /// Perfect for FloatingActionButton or other positioned widgets
  ///
  /// [child] - The widget to navigate to
  /// [startPosition] - The global position where the animation should start from
  /// [duration] - Animation duration in milliseconds (default: 400)
  /// [curve] - Animation curve (default: Curves.easeInOut)
  static PageRouteBuilder<T> expandFromPosition<T extends Object?>(
    Widget child, {
    required Offset startPosition,
    int duration = 400,
    Curve curve = Curves.easeInOut,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionDuration: Duration(milliseconds: duration),
      reverseTransitionDuration: Duration(milliseconds: duration),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final screenSize = MediaQuery.of(context).size;

        // Calculate the maximum distance from the start position to any corner
        final maxDistance = [
          startPosition.distance, // Top-left
          (startPosition - Offset(screenSize.width, 0)).distance, // Top-right
          (startPosition - Offset(0, screenSize.height))
              .distance, // Bottom-left
          (startPosition - screenSize.bottomRight(Offset.zero))
              .distance, // Bottom-right
        ].reduce((a, b) => a > b ? a : b);

        // Create a circular reveal effect
        return ClipPath(
          clipper: CircularRevealClipper(
            center: startPosition,
            radius: animation
                .drive(
                  Tween(begin: 0.0, end: maxDistance).chain(
                    CurveTween(curve: curve),
                  ),
                )
                .value,
          ),
          child: child,
        );
      },
    );
  }

  /// Creates a combined scale and fade transition from a specific position
  /// Alternative to expandFromPosition with a different visual effect
  ///
  /// [child] - The widget to navigate to
  /// [startPosition] - The global position where the animation should start from
  /// [duration] - Animation duration in milliseconds (default: 300)
  /// [curve] - Animation curve (default: Curves.easeInOut)
  static PageRouteBuilder<T> scaleFromPosition<T extends Object?>(
    Widget child, {
    required Offset startPosition,
    int duration = 300,
    Curve curve = Curves.easeInOut,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionDuration: Duration(milliseconds: duration),
      reverseTransitionDuration: Duration(milliseconds: duration),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final screenSize = MediaQuery.of(context).size;
        final centerOffset =
            Offset(screenSize.width / 2, screenSize.height / 2);
        final translationOffset = startPosition - centerOffset;

        final scaleAnimation = Tween(begin: 0.0, end: 1.0).chain(
          CurveTween(curve: curve),
        );

        final fadeAnimation = Tween(begin: 0.0, end: 1.0).chain(
          CurveTween(curve: curve),
        );

        final translateAnimation = Tween(
          begin: translationOffset,
          end: Offset.zero,
        ).chain(
          CurveTween(curve: curve),
        );

        return Transform.translate(
          offset: animation.drive(translateAnimation).value,
          child: Transform.scale(
            scale: animation.drive(scaleAnimation).value,
            child: FadeTransition(
              opacity: animation.drive(fadeAnimation),
              child: child,
            ),
          ),
        );
      },
    );
  }

  /// Helper method to get the offset for a given slide direction
  static Offset _getOffsetForDirection(SlideDirection direction) {
    switch (direction) {
      case SlideDirection.fromRight:
        return const Offset(1.0, 0.0);
      case SlideDirection.fromLeft:
        return const Offset(-1.0, 0.0);
      case SlideDirection.fromTop:
        return const Offset(0.0, -1.0);
      case SlideDirection.fromBottom:
        return const Offset(0.0, 1.0);
    }
  }
}

/// Enum for slide directions
enum SlideDirection {
  fromRight,
  fromLeft,
  fromTop,
  fromBottom,
}

/// Custom clipper for circular reveal animation
class CircularRevealClipper extends CustomClipper<Path> {
  final Offset center;
  final double radius;

  CircularRevealClipper({
    required this.center,
    required this.radius,
  });

  @override
  Path getClip(Size size) {
    final path = Path();
    path.addOval(Rect.fromCircle(center: center, radius: radius));
    return path;
  }

  @override
  bool shouldReclip(CircularRevealClipper oldClipper) {
    return oldClipper.center != center || oldClipper.radius != radius;
  }
}
