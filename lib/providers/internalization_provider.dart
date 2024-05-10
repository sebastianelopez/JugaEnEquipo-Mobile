import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InternalizationProvider extends ChangeNotifier {
  final List<Locale> languages = [
    const Locale('en', 'US'),
    const Locale('es', 'AR'),
    const Locale('pt', 'BR'),
  ];

  Locale currentlanguage = const Locale('es', 'AR');

  void setLanguage(Locale locale) {
    if (!AppLocalizations.supportedLocales.contains(locale)) return;

    currentlanguage = locale;
    notifyListeners();
  }
}
