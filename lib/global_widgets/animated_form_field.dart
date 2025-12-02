import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jugaenequipo/theme/app_theme.dart';

class AnimatedFormField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool obscureText;
  final void Function(String)? onChanged;
  final Color? hintTextColor;
  final Color? labelTextColor;
  final Color? textColor;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconTap;
  final bool enabled;
  final String? errorText;

  const AnimatedFormField({
    super.key,
    required this.controller,
    required this.hintText,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.onChanged,
    this.hintTextColor,
    this.labelTextColor,
    this.textColor,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconTap,
    this.enabled = true,
    this.errorText,
  });

  @override
  State<AnimatedFormField> createState() => _AnimatedFormFieldState();
}

class _AnimatedFormFieldState extends State<AnimatedFormField>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shakeAnimation;
  late FocusNode _focusNode;

  bool _isFocused = false;
  bool _hasError = false;
  String? _currentError;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _shakeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticIn,
    ));

    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });

    if (_isFocused) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void _triggerErrorAnimation() {
    _animationController.reset();
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.errorText != _currentError) {
      _currentError = widget.errorText;
      _hasError = widget.errorText != null;

      if (_hasError) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _triggerErrorAnimation();
        });
      }
    }

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.translate(
            offset: _hasError
                ? Offset(
                    _shakeAnimation.value *
                        10 *
                        ((_animationController.value * 4).round() % 2 == 0
                            ? 1
                            : -1),
                    0)
                : Offset.zero,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _hasError
                      ? Colors.red.withOpacity( 0.8)
                      : _isFocused
                          ? Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity( 0.8)
                          : Colors.transparent,
                  width: _hasError || _isFocused ? 2 : 0,
                ),
                boxShadow: _isFocused
                    ? [
                        BoxShadow(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity( 0.3),
                          blurRadius: 8,
                          spreadRadius: 0,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : _hasError
                        ? [
                            BoxShadow(
                              color: Colors.red.withOpacity( 0.3),
                              blurRadius: 8,
                              spreadRadius: 0,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : [],
              ),
              child: TextFormField(
                controller: widget.controller,
                focusNode: _focusNode,
                enabled: widget.enabled,
                style: TextStyle(
                  color: widget.textColor ??
                      Theme.of(context).colorScheme.onSurface,
                  fontSize: 16.h,
                ),
                keyboardType: widget.keyboardType,
                obscureText: widget.obscureText,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: TextStyle(
                    color: widget.hintTextColor ??
                        Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.6),
                    fontSize: 16.h,
                  ),
                  prefixIcon: widget.prefixIcon != null
                      ? AnimatedScale(
                          scale: _isFocused ? 1.1 : 1.0,
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            widget.prefixIcon,
                            color: _isFocused
                                ? Theme.of(context).colorScheme.primary
                                : widget.hintTextColor ??
                                    Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withOpacity(0.6),
                          ),
                        )
                      : null,
                  suffixIcon: widget.suffixIcon != null
                      ? GestureDetector(
                          onTap: widget.onSuffixIconTap,
                          child: AnimatedScale(
                            scale: _isFocused ? 1.1 : 1.0,
                            duration: const Duration(milliseconds: 200),
                            child: Icon(
                              widget.suffixIcon,
                              color: _isFocused
                                  ? Theme.of(context).colorScheme.primary
                                  : widget.hintTextColor ??
                                      Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withOpacity(0.6),
                            ),
                          ),
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.05)
                      : AppTheme.primary.withOpacity(0.03),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  errorStyle: TextStyle(
                    color: Colors.red.withOpacity( 0.8),
                    fontSize: 12.h,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onChanged: widget.onChanged,
                validator: widget.validator,
                onTapOutside: (event) =>
                    FocusManager.instance.primaryFocus?.unfocus(),
              ),
            ),
          ),
        );
      },
    );
  }
}
