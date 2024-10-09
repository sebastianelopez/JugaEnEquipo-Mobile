import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/user_use_cases/get_user_use_case.dart';
import 'package:jugaenequipo/datasources/user_use_cases/login_use_case.dart';
import 'package:jugaenequipo/providers/providers.dart';
import 'package:provider/provider.dart';

class LoginFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController email =
      TextEditingController(text: 'lopezsebastian.emanuel@gmail.com');
  TextEditingController password = TextEditingController(text: '123456');

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  var storage = const FlutterSecureStorage();

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
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final result = await login(email, password);

    switch (result) {
      case LoginResult.success:
        var token = await storage.read(key: 'access_token');

        if (token == null) {
          isLoading = false;
          throw const FormatException('Token is null');
        }

        // Split the token into its three parts
        final parts = token.split('.');
        if (parts.length != 3) {
          throw const FormatException('Invalid token');
        }

        // Decode the second part (payload)
        final payload = parts[1];
        final normalized = base64.normalize(payload);
        final decodedBytes = base64.decode(normalized);
        final decodedString = utf8.decode(decodedBytes);

        // Extract the user ID from the decoded payload
        final payloadMap = json.decode(decodedString);
        final decodedId = payloadMap['id'];

        if (decodedId == null) {
          throw const FormatException('ID not found in token payload');
        }

        var user = await getUserById(decodedId);

        if (user == null) {
          throw Exception('User not found');
        }
        userProvider.setUser(user!);

        isLoading = false;
        Navigator.pushReplacementNamed(context, 'tabs');
        break;
      case LoginResult.unauthorized:
        isLoading = false;
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
