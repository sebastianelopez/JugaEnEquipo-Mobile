import 'package:flutter/material.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';

/// Password validation patterns matching frontend requirements
class PasswordPatterns {
  static final RegExp minLength = RegExp(r'.{8,}');
  static final RegExp hasUpperCase = RegExp(r'[A-Z]');
  static final RegExp hasLowerCase = RegExp(r'[a-z]');
  static final RegExp hasNumber = RegExp(r'\d');
  static final RegExp hasSpecialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
}

/// Password strength check result
class PasswordStrength {
  final bool minLength;
  final bool hasUpperCase;
  final bool hasLowerCase;
  final bool hasNumber;
  final bool hasSpecialChar;
  final double strength;
  final bool isValid;

  PasswordStrength({
    required this.minLength,
    required this.hasUpperCase,
    required this.hasLowerCase,
    required this.hasNumber,
    required this.hasSpecialChar,
    required this.strength,
    required this.isValid,
  });
}

/// Reusable validation functions matching frontend schema
class Validators {
  /// Validates first name: min 2, max 50, required
  static String? firstName({
    required String? value,
    required BuildContext context,
  }) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.validationRequired;
    }
    if (value.trim().length < 2) {
      return AppLocalizations.of(context)!.validationFirstNameMin;
    }
    if (value.trim().length > 50) {
      return AppLocalizations.of(context)!.validationFirstNameMax;
    }
    return null;
  }

  /// Validates last name: min 2, max 50, required
  static String? lastName({
    required String? value,
    required BuildContext context,
  }) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.validationRequired;
    }
    if (value.trim().length < 2) {
      return AppLocalizations.of(context)!.validationLastNameMin;
    }
    if (value.trim().length > 50) {
      return AppLocalizations.of(context)!.validationLastNameMax;
    }
    return null;
  }

  /// Validates email: valid email format, required
  static String? email({
    required String? value,
    required BuildContext context,
  }) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.validationRequired;
    }
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value.trim())) {
      return AppLocalizations.of(context)!.validationInvalidEmail;
    }
    return null;
  }

  /// Validates username: min 3, max 20, only letters/numbers/underscores/dots, required
  static String? username({
    required String? value,
    required BuildContext context,
  }) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.validationRequired;
    }
    if (value.trim().length < 3) {
      return AppLocalizations.of(context)!.validationUsernameMin;
    }
    if (value.trim().length > 20) {
      return AppLocalizations.of(context)!.validationUsernameMax;
    }
    final usernamePattern = RegExp(r'^[a-zA-Z0-9_\.]+$');
    if (!usernamePattern.hasMatch(value.trim())) {
      return AppLocalizations.of(context)!.validationUsernameInvalid;
    }
    return null;
  }

  /// Validates password: min 8, uppercase, lowercase, number, special char, required
  static String? password({
    required String? value,
    required BuildContext context,
  }) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.validationRequired;
    }
    if (!PasswordPatterns.minLength.hasMatch(value)) {
      return AppLocalizations.of(context)!.validationPasswordMinLength;
    }
    if (!PasswordPatterns.hasUpperCase.hasMatch(value)) {
      return AppLocalizations.of(context)!.validationPasswordHasUpperCase;
    }
    if (!PasswordPatterns.hasLowerCase.hasMatch(value)) {
      return AppLocalizations.of(context)!.validationPasswordHasLowerCase;
    }
    if (!PasswordPatterns.hasNumber.hasMatch(value)) {
      return AppLocalizations.of(context)!.validationPasswordHasNumber;
    }
    if (!PasswordPatterns.hasSpecialChar.hasMatch(value)) {
      return AppLocalizations.of(context)!.validationPasswordHasSpecialChar;
    }
    return null;
  }

  /// Validates confirm password: must match password, required
  static String? confirmPassword({
    required String? value,
    required String passwordValue,
    required BuildContext context,
  }) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.validationRequired;
    }
    if (value != passwordValue) {
      return AppLocalizations.of(context)!.validationPasswordsDontMatch;
    }
    return null;
  }

  /// Checks password strength and returns detailed result
  static PasswordStrength checkPasswordStrength(String password) {
    final checks = {
      'minLength': PasswordPatterns.minLength.hasMatch(password),
      'hasUpperCase': PasswordPatterns.hasUpperCase.hasMatch(password),
      'hasLowerCase': PasswordPatterns.hasLowerCase.hasMatch(password),
      'hasNumber': PasswordPatterns.hasNumber.hasMatch(password),
      'hasSpecialChar': PasswordPatterns.hasSpecialChar.hasMatch(password),
    };

    final passedChecks = checks.values.where((v) => v).length;
    final strength = (passedChecks / 5) * 100;

    return PasswordStrength(
      minLength: checks['minLength']!,
      hasUpperCase: checks['hasUpperCase']!,
      hasLowerCase: checks['hasLowerCase']!,
      hasNumber: checks['hasNumber']!,
      hasSpecialChar: checks['hasSpecialChar']!,
      strength: strength,
      isValid: passedChecks == 5,
    );
  }

  /// Legacy method for backward compatibility
  static String? isEmail({
    required String value,
    required BuildContext context,
  }) {
    return email(value: value, context: context);
  }
}
