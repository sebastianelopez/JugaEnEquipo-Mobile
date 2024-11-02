import 'package:flutter/material.dart';
import 'package:jugaenequipo/share_preferences/preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData currentTheme;

  ThemeProvider({required bool isDarkmode})
      : currentTheme = isDarkmode ? ThemeData.dark() : ThemeData.light();

  setLightMode() {
    currentTheme = ThemeData.light();
    Preferences.isDarkmode = false;
    notifyListeners();
  }

  setDarkmode() {
    currentTheme = ThemeData.dark();
    Preferences.isDarkmode = true;
    notifyListeners();
  }
}
