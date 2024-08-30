import 'package:flutter/material.dart';
import 'package:jugaenequipo/presentation/login/business_logic/login_form_provider.dart';
import 'package:jugaenequipo/presentation/login/widgets/login_form.dart';
import 'package:jugaenequipo/global_widgets/widgets.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AuthBackground(
            child: SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 400,
          ),
          CardContainer(
            backgroundColor: Colors.transparent,
            child: Column(
              children: [
                ChangeNotifierProvider(
                  create: (_) => LoginFormProvider(),
                  child: const LoginForm(),
                ),
              ],
            ),
          ),
          TextButton(
            child: const Text('Crear una nueva cuenta',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70)),
            onPressed: () {
              //hide keyboard
              FocusScope.of(context).unfocus();
              Navigator.pushNamed(context, 'register');
            },
          ),
          const SizedBox(
            height: 40,
          ),
          const LanguageDropdown(
            showLabel: true,
            alignment: Alignment.center,
          ),
        ],
      ),
    )));
  }
}
