import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jugaenequipo/providers/providers.dart';
import 'package:jugaenequipo/ui/input_decorations.dart';
import 'package:jugaenequipo/utils/validator.dart';
import 'package:jugaenequipo/widgets/widgets.dart';
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
                  child: _LoginForm(),
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
            height: 50,
          ),
        ],
      ),
    )));
  }
}

class _LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);
    final email = loginForm.email;
    final password = loginForm.password;
    final isLoading = loginForm.isLoading;

    return Form(
        key: loginForm.formKey,
        child: Column(
          children: [
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: email,
              style: const TextStyle(color: Colors.white),
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'User',
                hintTextColor: Colors.white,
                labelTextColor: Colors.white,
              ),
              onTapOutside: (event) =>
                  FocusManager.instance.primaryFocus?.unfocus(),
              onChanged: (value) => email.text = value,
              validator: (value) => value != null
                  ? Validators.isEmail(value: value)
                  : 'Email is required',
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: password,
              style: const TextStyle(color: Colors.white),
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'Password',
                hintTextColor: Colors.white,
                labelTextColor: Colors.white,
              ),
              onTapOutside: (event) =>
                  FocusManager.instance.primaryFocus?.unfocus(),
              onChanged: (value) => password.text = value,
              validator: (value) {
                return (value != null && value.length >= 6)
                    ? null
                    : 'The password must be at least six characters.';
              },
            ),
            const SizedBox(
              height: 25,
            ),
            MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                disabledColor: Colors.grey,
                elevation: 0,
                color: const Color(0xFFD72323),
                onPressed: isLoading
                    ? null
                    : () {
                        //hide keyboard
                        FocusScope.of(context).unfocus();

                        if (!loginForm.isValidForm()) return;
                        loginForm.isLoading = true;

                        Future.delayed(const Duration(seconds: 2));

                        loginForm.isLoading = false;
                        Navigator.pushReplacementNamed(context, 'home');
                      },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                  child: Text(
                    'Log in',
                    style: GoogleFonts.openSans(
                        textStyle: const TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.w900,
                            fontSize: 16.0)),
                  ),
                ))
          ],
        ));
  }
}
