import 'package:flutter/material.dart';
import 'package:jugaenequipo/providers/providers.dart';
import 'package:jugaenequipo/ui/input_decorations.dart';
import 'package:jugaenequipo/utils/validator.dart';
import 'package:jugaenequipo/widgets/widgets.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AuthBackground(
            child: SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 250,
          ),
          CardContainer(
            backgroundColor: Colors.white.withOpacity(0.3),
            child: Column(
              children: [
                ChangeNotifierProvider(
                  create: (_) => RegisterFormProvider(),
                  child: _RegisterForm(),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          TextButton(
            child: const Text('¿Ya tenes cuenta?',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70)),
            onPressed: () {
              //hide keyboard
              FocusScope.of(context).unfocus();
              Navigator.pushNamed(context, 'login');
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

class _RegisterForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final registerForm = Provider.of<RegisterFormProvider>(context);

    return Form(
        key: registerForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                  hintText: 'user123',
                  hintTextColor: Colors.white60,
                  labelText: 'User',
                  labelTextColor: Colors.white60,
                  prefixIcon: Icons.alternate_email_rounded),
              onChanged: (value) => registerForm.email = value,
              validator: (value) =>
                  value != null ? Validators.isEmail(value: value) : '',
            ),
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                  hintText: 'user@gmail.com',
                  hintTextColor: Colors.white60,
                  labelText: 'Email',
                  labelTextColor: Colors.white60,
                  prefixIcon: Icons.alternate_email_rounded),
              onChanged: (value) => registerForm.email = value,
              validator: (value) =>
                  value != null ? Validators.isEmail(value: value) : '',
            ),
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                  hintText: '*******',
                  hintTextColor: Colors.white60,
                  labelText: 'Password',
                  labelTextColor: Colors.white60,
                  prefixIcon: Icons.lock_outlined),
              onChanged: (value) => registerForm.password = value,
              validator: (value) {
                return (value != null && value.length >= 6)
                    ? null
                    : 'The password must be at least six characters.';
              },
            ),
            TextFormField(
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                  hintText: '*******',
                  hintTextColor: Colors.white60,
                  labelText: 'Repeat password',
                  labelTextColor: Colors.white60,
                  prefixIcon: Icons.lock_outlined),
              onChanged: (value) => registerForm.password = value,
              validator: (value) {
                return (value != null && value.length >= 6)
                    ? null
                    : 'The password must be at least six characters.';
              },
            ),
            const SizedBox(
              height: 30,
            ),
            MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                disabledColor: Colors.grey,
                elevation: 0,
                color: const Color(0xFFD72323),
                onPressed: registerForm.isLoading
                    ? null
                    : () {
                        //hide keyboard
                        FocusScope.of(context).unfocus();

                        if (!registerForm.isValidForm()) return;
                        registerForm.isLoading = true;

                        Future.delayed(const Duration(seconds: 2));

                        registerForm.isLoading = false;
                        Navigator.pushNamed(context, 'login');
                      },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                  child: Text(
                    registerForm.isLoading ? 'Wait...' : 'Sign in',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ))
          ],
        ));
  }
}
