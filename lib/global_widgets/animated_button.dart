import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AnimatedButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? disabledColor;
  final double? width;
  final double? height;
  final IconData? icon;
  final bool showLoadingIndicator;

  const AnimatedButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.disabledColor,
    this.width,
    this.height,
    this.icon,
    this.showLoadingIndicator = true,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with TickerProviderStateMixin {
  late AnimationController _pressController;
  late AnimationController _loadingController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  bool _isPressed = false;

  @override
  void initState() {
    super.initState();

    _pressController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    _loadingController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _pressController,
      curve: Curves.easeInOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _loadingController,
      curve: Curves.linear,
    ));

    if (widget.isLoading) {
      _loadingController.repeat();
    }
  }

  @override
  void didUpdateWidget(AnimatedButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isLoading != oldWidget.isLoading) {
      if (widget.isLoading) {
        _loadingController.repeat();
      } else {
        _loadingController.stop();
        _loadingController.reset();
      }
    }
  }

  @override
  void dispose() {
    _pressController.dispose();
    _loadingController.dispose();
    super.dispose();
  }

  void _onTapDown() {
    setState(() {
      _isPressed = true;
    });
    _pressController.forward();
  }

  void _onTapUp() {
    setState(() {
      _isPressed = false;
    });
    _pressController.reverse();
  }

  void _onTapCancel() {
    setState(() {
      _isPressed = false;
    });
    _pressController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.onPressed != null && !widget.isLoading;

    return GestureDetector(
      onTapDown: isEnabled ? (_) => _onTapDown() : null,
      onTapUp: isEnabled ? (_) => _onTapUp() : null,
      onTapCancel: isEnabled ? _onTapCancel : null,
      child: AnimatedBuilder(
        animation: Listenable.merge([_scaleAnimation, _rotationAnimation]),
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: widget.width,
              height: widget.height ?? 50.h,
              decoration: BoxDecoration(
                color: isEnabled
                    ? (widget.backgroundColor ??
                        Theme.of(context).colorScheme.primary)
                    : (widget.disabledColor ??
                        Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity( 0.5)),
                borderRadius: BorderRadius.circular(12),
                boxShadow: isEnabled && !_isPressed
                    ? [
                        BoxShadow(
                          color: (widget.backgroundColor ??
                                  Theme.of(context).colorScheme.primary)
                              .withOpacity( 0.3),
                          blurRadius: 8,
                          spreadRadius: 0,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: isEnabled ? widget.onPressed : null,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.isLoading && widget.showLoadingIndicator)
                          Transform.rotate(
                            angle: _rotationAnimation.value * 2 * 3.14159,
                            child: SizedBox(
                              width: 20.w,
                              height: 20.h,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  widget.textColor ??
                                      Theme.of(context)
                                          .colorScheme
                                          .onPrimary
                                          .withOpacity( 0.8),
                                ),
                              ),
                            ),
                          )
                        else if (widget.icon != null)
                          AnimatedScale(
                            scale: _isPressed ? 0.9 : 1.0,
                            duration: const Duration(milliseconds: 100),
                            child: Icon(
                              widget.icon,
                              color: widget.textColor ??
                                  Theme.of(context)
                                      .colorScheme
                                      .onPrimary
                                      .withOpacity( 0.8),
                              size: 20.h,
                            ),
                          ),
                        if ((widget.isLoading && widget.showLoadingIndicator) ||
                            widget.icon != null)
                          SizedBox(width: 8.w),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: Text(
                            widget.isLoading ? 'Cargando...' : widget.text,
                            key:
                                ValueKey(widget.isLoading ? 'loading' : 'text'),
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                color: widget.textColor ??
                                    Theme.of(context)
                                        .colorScheme
                                        .onPrimary
                                        .withOpacity( 0.8),
                                fontWeight: FontWeight.w700,
                                fontSize: 16.h,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
