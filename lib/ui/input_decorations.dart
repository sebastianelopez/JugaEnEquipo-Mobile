import 'package:flutter/material.dart';
import 'package:jugaenequipo/theme/app_theme.dart';

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
      contentPadding: const EdgeInsets.only(left: 30, bottom: 20, top: 20, right: 10),
      hintFadeDuration: const Duration(milliseconds: 300),
      hintText: hintText,
      hintStyle: TextStyle(color: hintTextColor ?? Colors.white),
      labelText: labelText,
      labelStyle: TextStyle(color: labelTextColor ?? Colors.white),
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
          borderSide: BorderSide(color: Colors.deepPurple)),
      focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurple, width: 2)),
      hintText: hintText,
      labelText: labelText,
      labelStyle: const TextStyle(color: Colors.grey),
      prefixIcon: prefixIcon != null
          ? Icon(
              prefixIcon,
              color: Colors.deepPurple,
            )
          : null,
    );
  }
}
