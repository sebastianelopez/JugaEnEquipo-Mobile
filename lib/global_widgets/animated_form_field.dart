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
  final AutovalidateMode autovalidateMode;
  final void Function(bool)? onFocusChange;

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
    this.autovalidateMode = AutovalidateMode.disabled,
    this.onFocusChange,
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

  final GlobalKey<FormFieldState<String>> _formFieldKey = GlobalKey<FormFieldState<String>>();

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
    
    // Listen to controller changes to update FormField
    widget.controller.addListener(_onControllerChanged);
  }
  
  void _onControllerChanged() {
    final fieldState = _formFieldKey.currentState;
    if (fieldState != null && fieldState.value != widget.controller.text) {
      fieldState.didChange(widget.controller.text);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    _animationController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    final wasFocused = _isFocused;
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });

    if (_isFocused != wasFocused) {
      widget.onFocusChange?.call(_isFocused);
    }

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
    // Check for external errorText prop
    if (widget.errorText != null && widget.errorText != _currentError) {
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
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Transform.scale(
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
                  child: FormField<String>(
                    key: _formFieldKey,
                    initialValue: widget.controller.text,
                    validator: widget.validator,
                    autovalidateMode: widget.autovalidateMode,
                    builder: (FormFieldState<String> field) {
                      // Update error state when field state changes
                      final errorText = field.errorText;
                      if (errorText != _currentError) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (mounted) {
                            setState(() {
                              _currentError = errorText;
                              _hasError = errorText != null;
                            });
                            if (_hasError) {
                              _triggerErrorAnimation();
                            }
                          }
                        });
                      }

                      return TextFormField(
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
                          errorText: null,
                          errorStyle: const TextStyle(height: 0, fontSize: 0),
                        ),
                        onChanged: (value) {
                          widget.onChanged?.call(value);
                          field.didChange(value);
                        },
                        onTapOutside: (event) =>
                            FocusManager.instance.primaryFocus?.unfocus(),
                      );
                    },
                  ),
                ),
              ),
            ),
            if (_hasError && _currentError != null)
              Padding(
                padding: EdgeInsets.only(top: 8.h, left: 4.w),
                child: Text(
                  _currentError!,
                  style: TextStyle(
                    color: Colors.red.withOpacity(0.8),
                    fontSize: 12.h,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                  maxLines: null,
                  softWrap: true,
                ),
              ),
          ],
        );
      },
    );
  }
}
