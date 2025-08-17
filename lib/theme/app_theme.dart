import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primary = Color(0xFFA91F27);
  static const Color black = Color(0xff070d23);

  static ThemeData baseTheme(ThemeData theme) {
    return theme.copyWith(
      primaryColor: primary,
      appBarTheme: const AppBarTheme(backgroundColor: primary, elevation: 0),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: primary, elevation: 5),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD72323),
              shape: const StadiumBorder(),
              elevation: 0)),
      inputDecorationTheme: const InputDecorationTheme(
        floatingLabelStyle: TextStyle(color: primary),
      ),
    );
  }

  static final ThemeData lightTheme = baseTheme(ThemeData.light()).copyWith(
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: primary),
    ),
    textTheme: GoogleFonts.openSansTextTheme(
      ThemeData.light().textTheme,
    ),
  );

  static final ThemeData darkTheme = baseTheme(ThemeData.dark()).copyWith(
    scaffoldBackgroundColor: Colors.black,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: black,
      selectedItemColor: primary,
      unselectedItemColor: Colors.white,
      selectedIconTheme: IconThemeData(color: primary),
      unselectedIconTheme: IconThemeData(color: Colors.white),
    ),
    textTheme: GoogleFonts.openSansTextTheme(
      ThemeData.dark().textTheme,
    ),
  );
}
