import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';
import 'package:jugaenequipo/datasources/user_use_cases/get_user_use_case.dart';
import 'package:jugaenequipo/datasources/user_use_cases/login_use_case.dart';
import 'package:jugaenequipo/providers/providers.dart';
import 'package:jugaenequipo/utils/utils.dart';
import 'package:provider/provider.dart';

class LoginFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController email = TextEditingController(text: '');
  TextEditingController password = TextEditingController(text: '');

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  var storage = const FlutterSecureStorage();

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }

  Future<void> handleLogin(
      BuildContext context, String email, String password) async {
    FocusScope.of(context).unfocus();
    if (!isValidForm()) return;
    isLoading = true;
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final result = await login(email, password);

    if (!context.mounted) {
      isLoading = false;
      return;
    }

    switch (result) {
      case Result.success:
        var token = await storage.read(key: 'access_token');

        if (token == null) {
          isLoading = false;
          throw const FormatException('Token is null');
        }

        final decodedId = decodeUserIdByToken(token);

        var user = await getUserById(decodedId);

        if (!context.mounted) {
          isLoading = false;
          return;
        }

        if (user == null) {
          throw Exception('User not found');
        }
        userProvider.setUser(user);

        isLoading = false;
        if (!context.mounted) return;
        Navigator.pushReplacementNamed(context, 'tabs');
        break;
      case Result.unauthorized:
        isLoading = false;
        if (!context.mounted) return;
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
      case Result.error:
        isLoading = false;
        if (!context.mounted) return;
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
