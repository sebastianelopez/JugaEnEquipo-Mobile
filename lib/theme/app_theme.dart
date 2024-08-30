import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primary = Color(0xFFA91F27);
  static const Color black = Color(0xff070d23);

  static final ThemeData lightTheme = ThemeData.light().copyWith(
    primaryColor: primary,

    //AppBar Theme
    appBarTheme: const AppBarTheme(color: primary, elevation: 0),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: primary),
    ),

    //FloatingButtons
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primary, elevation: 5),

    //ElevatedButtons
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD72323),
            shape: const StadiumBorder(),
            elevation: 0)),
    inputDecorationTheme: const InputDecorationTheme(
      floatingLabelStyle: TextStyle(color: primary),
    ),

    textTheme: GoogleFonts.openSansTextTheme(),
  );

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
      primaryColor: primary,

      //AppBar Theme
      appBarTheme: const AppBarTheme(color: primary, elevation: 0),
      scaffoldBackgroundColor: Colors.black);
}
