import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jugaenequipo/datasources/user_use_cases/create_user_use_case.dart';
import 'package:jugaenequipo/presentation/register/business_logic/register_form_provider.dart';
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
            backgroundColor: Colors.transparent,
            child: Column(
              children: [
                ChangeNotifierProvider(
                  create: (_) => RegisterFormProvider(),
                  child: _RegisterForm(),
                ),
              ],
            ),
          ),
          TextButton(
            child: const Text('¿Ya tienes cuenta? Inicia Sesion',
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

    final firstName = registerForm.firstName;
    final lastName = registerForm.lastName;
    final userName = registerForm.user;
    final email = registerForm.email;
    final password = registerForm.password;
    final confirmationPassword = registerForm.confirmationPassword;

    final isLoading = registerForm.isLoading;

    return Form(
        key: registerForm.formKey,
        child: Column(
          children: [
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: firstName,
              style: const TextStyle(color: Colors.white),
              autocorrect: false,
              keyboardType: TextInputType.text,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'First Name',
                hintTextColor: Colors.white,
                labelTextColor: Colors.white,
              ),
              onTapOutside: (event) =>
                  FocusManager.instance.primaryFocus?.unfocus(),
              onChanged: (value) => firstName.text = value,
              validator: (value) {
                return (value != null && value.length > 2)
                    ? null
                    : 'Enter a valid name.';
              },
            ),
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: lastName,
              style: const TextStyle(color: Colors.white),
              autocorrect: false,
              keyboardType: TextInputType.text,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'Last Name',
                hintTextColor: Colors.white,
                labelTextColor: Colors.white,
              ),
              onTapOutside: (event) =>
                  FocusManager.instance.primaryFocus?.unfocus(),
              onChanged: (value) => lastName.text = value,
              validator: (value) {
                return (value != null && value.isNotEmpty)
                    ? null
                    : 'Last name is required';
              },
            ),
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: userName,
              style: const TextStyle(color: Colors.white),
              autocorrect: false,
              keyboardType: TextInputType.text,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'User',
                hintTextColor: Colors.white,
                labelTextColor: Colors.white,
              ),
              onTapOutside: (event) =>
                  FocusManager.instance.primaryFocus?.unfocus(),
              onChanged: (value) => userName.text = value,
              validator: (value) {
                return (value != null && value.length > 2)
                    ? null
                    : 'User name should have at least 3 characters';
              },
            ),
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: email,
              style: const TextStyle(color: Colors.white),
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'Email',
                hintTextColor: Colors.white,
                labelTextColor: Colors.white,
              ),
              onTapOutside: (event) =>
                  FocusManager.instance.primaryFocus?.unfocus(),
              onChanged: (value) => email.text = value,
              validator: (value) => value != null
                  ? Validators.isEmail(value: value, context: context)
                  : 'Email is required',
            ),
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: password,
              style: const TextStyle(color: Colors.white),
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
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
              height: 30,
            ),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: confirmationPassword,
              style: const TextStyle(color: Colors.white),
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'Repeat password',
                hintTextColor: Colors.white,
                labelTextColor: Colors.white,
              ),
              onTapOutside: (event) =>
                  FocusManager.instance.primaryFocus?.unfocus(),
              onChanged: (value) => confirmationPassword.text = value,
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

                        if (!registerForm.isValidForm()) return;
                        registerForm.isLoading = true;

                        Future.delayed(const Duration(seconds: 2));

                        registerForm.isLoading = false;
                        Navigator.pushReplacementNamed(context, 'home');
                      },
                
                  
                  child: TextButton(
                    onPressed: () {
                      createUser(firstName.text, lastName.text, userName.text, email.text, password.text, confirmationPassword.text);
                    },
                    
                    child: Text('Register',
                        style: GoogleFonts.openSans(
                            textStyle: const TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.w900,
                          fontSize: 16.0,
                        ))),
                  ),
                )
          ],
        ));
  }
}
