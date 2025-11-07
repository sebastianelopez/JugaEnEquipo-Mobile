import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primary = Color(0xFF6C5CE7); // #6C5CE7
  static const Color secondary = Color(0xFF2D3436); // #2D3436
  static const Color accent = Color(0xFF00CEC9); // #00CEC9
  static const Color warning = Color(0xFFFDCB6E); // #FDCB6E
  static const Color success = Color(0xFF00B894); // #00B894
  static const Color error = Color(0xFFE17055); // #E17055
  static const Color white = Color(0xFFFFFFFF); // #FFFFFF
  static const Color black = Color(0xFF000000); // #000000
  static const Color darkBg = Color(0xFF1A1A2E); // #1A1A2E
  static const Color lightBg = Color(0xFFF8F9FA); // #F8F9FA

  static ThemeData baseTheme(ThemeData theme) {
    return theme.copyWith(
      primaryColor: primary,
      dividerColor: secondary.withOpacity(0.2),
      appBarTheme: const AppBarTheme(backgroundColor: primary, elevation: 0),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: primary, elevation: 5),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              shape: const StadiumBorder(),
              elevation: 0)),
      inputDecorationTheme: const InputDecorationTheme(
        floatingLabelStyle: TextStyle(color: primary),
      ),
    );
  }

  static final ThemeData lightTheme = baseTheme(ThemeData.light()).copyWith(
    scaffoldBackgroundColor: lightBg,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: primary,
      onPrimary: white,
      secondary: accent,
      onSecondary: black,
      error: error,
      onError: white,
      surface: white,
      onSurface: secondary,
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: accent,
      contentTextStyle: TextStyle(color: white),
      actionTextColor: black,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    ),
    chipTheme: ThemeData.light().chipTheme.copyWith(
          backgroundColor: accent.withOpacity(0.15),
          selectedColor: success,
          disabledColor: secondary.withOpacity(0.2),
          checkmarkColor: white,
          labelStyle: const TextStyle(color: secondary),
          deleteIconColor: error,
          shape: const StadiumBorder(),
        ),
    switchTheme: const SwitchThemeData(
      thumbColor: WidgetStatePropertyAll(white),
      trackColor: WidgetStatePropertyAll(accent),
    ),
    dialogTheme: const DialogTheme(
      backgroundColor: white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      titleTextStyle: TextStyle(
        color: primary,
        fontWeight: FontWeight.w700,
        fontSize: 20,
      ),
      contentTextStyle: TextStyle(color: secondary),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: primary),
    ),
    textTheme: GoogleFonts.openSansTextTheme(
      ThemeData.light().textTheme,
    ),
  );

  static final ThemeData darkTheme = baseTheme(ThemeData.dark()).copyWith(
    scaffoldBackgroundColor: darkBg,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: primary,
      onPrimary: white,
      secondary: accent,
      onSecondary: black,
      error: error,
      onError: white,
      surface: secondary,
      onSurface: white,
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: accent,
      contentTextStyle: TextStyle(color: white),
      actionTextColor: black,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    ),
    chipTheme: ThemeData.dark().chipTheme.copyWith(
          backgroundColor: accent.withOpacity(0.2),
          selectedColor: success,
          disabledColor: white.withOpacity(0.2),
          checkmarkColor: white,
          labelStyle: const TextStyle(color: white),
          deleteIconColor: error,
          shape: const StadiumBorder(),
        ),
    switchTheme: const SwitchThemeData(
      thumbColor: WidgetStatePropertyAll(white),
      trackColor: WidgetStatePropertyAll(accent),
    ),
    dialogTheme: const DialogTheme(
      backgroundColor: secondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      titleTextStyle: TextStyle(
        color: white,
        fontWeight: FontWeight.w700,
        fontSize: 20,
      ),
      contentTextStyle: TextStyle(color: white),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: secondary,
      selectedItemColor: primary,
      unselectedItemColor: white,
      selectedIconTheme: IconThemeData(color: primary),
      unselectedIconTheme: IconThemeData(color: white),
    ),
    textTheme: GoogleFonts.openSansTextTheme(
      ThemeData.dark().textTheme,
    ),
  );
}
