import 'package:flutter/material.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InputDecorations {
  static InputDecoration authInputDecoration(
      {required String hintText,
      Color? hintTextColor,
      String? labelText,
      Color? labelTextColor,
      IconData? prefixIcon}) {
    return InputDecoration(
      enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppTheme.primary),
          borderRadius: BorderRadius.all(Radius.circular(15))),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: AppTheme.primary, width: 2),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      border: const OutlineInputBorder(
        borderSide: BorderSide(color: AppTheme.primary, width: 2),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      contentPadding:
          EdgeInsets.only(left: 30.h, bottom: 15.h, top: 10.h, right: 15.h),
      hintFadeDuration: const Duration(milliseconds: 300),
      hintText: hintText,
      hintStyle:
          TextStyle(color: hintTextColor ?? AppTheme.white, fontSize: 16.h),
      labelText: labelText,
      labelStyle: TextStyle(color: labelTextColor ?? AppTheme.white),
      prefixIcon: prefixIcon != null
          ? Icon(
              prefixIcon,
              color: AppTheme.primary,
            )
          : null,
    );
  }

  static InputDecoration productInputDecoration(
      {required String hintText,
      required String labelText,
      IconData? prefixIcon}) {
    return InputDecoration(
      enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppTheme.primary)),
      focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppTheme.primary, width: 2)),
      hintText: hintText,
      labelText: labelText,
      labelStyle: const TextStyle(color: AppTheme.secondary),
      prefixIcon: prefixIcon != null
          ? Icon(
              prefixIcon,
              color: AppTheme.primary,
            )
          : null,
    );
  }
}
