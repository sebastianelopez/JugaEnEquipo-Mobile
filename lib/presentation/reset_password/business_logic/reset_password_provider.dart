import 'package:flutter/material.dart';
import 'package:jugaenequipo/datasources/api_service.dart';
import 'package:jugaenequipo/datasources/user_use_cases/reset_password_with_token_use_case.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';

class ResetPasswordProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmationPassword = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isSuccess = false;
  bool get isSuccess => _isSuccess;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  set isSuccess(bool value) {
    _isSuccess = value;
    notifyListeners();
  }

  set errorMessage(String? value) {
    _errorMessage = value;
    notifyListeners();
  }

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }

  Future<void> resetPassword(String token, BuildContext context) async {
    FocusScope.of(context).unfocus();
    if (!isValidForm()) return;

    isLoading = true;
    errorMessage = null;

    final result = await resetPasswordWithToken(
      token,
      newPassword.text,
      confirmationPassword.text,
    );

    isLoading = false;

    if (!context.mounted) return;

    final localizations = AppLocalizations.of(context)!;

    switch (result) {
      case Result.success:
        isSuccess = true;
        break;
      case Result.unauthorized:
        errorMessage = localizations.resetPasswordInvalidToken;
        break;
      case Result.error:
        errorMessage = localizations.resetPasswordError;
        break;
    }
  }

  @override
  void dispose() {
    newPassword.dispose();
    confirmationPassword.dispose();
    super.dispose();
  }
}
