import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primary = Color(0xFFD72323);

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
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: primary),
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: primary),
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
    ),

    textTheme: GoogleFonts.openSansTextTheme(),
  );

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
      primaryColor: primary,

      //AppBar Theme
      appBarTheme: const AppBarTheme(color: primary, elevation: 0),
      scaffoldBackgroundColor: Colors.black);
}
