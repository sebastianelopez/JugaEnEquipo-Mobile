import 'package:flutter/material.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';

class Validators {
  static String? isEmail({
    required String value,
    required BuildContext context,
  }) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = RegExp(pattern);

    return regExp.hasMatch(value)
        ? null
        : AppLocalizations.of(context)!.loginUserValidation;
  }
}
