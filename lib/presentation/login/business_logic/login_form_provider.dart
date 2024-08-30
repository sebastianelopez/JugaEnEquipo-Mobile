import 'package:flutter/material.dart';
import 'package:jugaenequipo/datasources/user_use_cases/login_use_case.dart';

class LoginFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;

    //return true;
  }

  Future<void> handleLogin(
      BuildContext context, String email, String password) async {
    FocusScope.of(context).unfocus();
    if (!isValidForm()) return;
    isLoading = true;
    final result = await login(email, password);

    switch (result) {
      case LoginResult.success:
        isLoading = false;
        Navigator.pushReplacementNamed(context, 'home');
        break;
      case LoginResult.unauthorized:
        isLoading = false;
        // Show a custom error message to the user (e.g., "Invalid email or password")
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('El mail o la contraseña no son correctas'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Aceptar'),
                ),
              ],
            );
          },
        );
        break;
      case LoginResult.error:
        isLoading = false;
        // Show a generic error message to the user (optional: retry button)
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text(
                  'Ocurrió un error inesperado. Por favor, inténtalo de nuevo.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Aceptar'),
                ),
              ],
            );
          },
        );

        break;
    }
  }
}
