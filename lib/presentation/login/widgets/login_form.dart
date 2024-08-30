import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jugaenequipo/datasources/user_use_cases/login_use_case.dart';
import 'package:jugaenequipo/presentation/login/business_logic/login_form_provider.dart';
import 'package:jugaenequipo/ui/input_decorations.dart';
import 'package:jugaenequipo/utils/validator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

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
                hintText: AppLocalizations.of(context)!.loginUserHintText,
                hintTextColor: Colors.white,
                labelTextColor: Colors.white,
              ),
              onTapOutside: (event) =>
                  FocusManager.instance.primaryFocus?.unfocus(),
              onChanged: (value) => email.text = value,
              validator: (value) => value != null
                  ? Validators.isEmail(value: value, context: context)
                  : AppLocalizations.of(context)!.loginUserRequiredValidation,
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
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: AppLocalizations.of(context)!.loginPasswordHintText,
                hintTextColor: Colors.white,
                labelTextColor: Colors.white,
              ),
              onTapOutside: (event) =>
                  FocusManager.instance.primaryFocus?.unfocus(),
              onChanged: (value) => password.text = value,
              validator: (value) {
                return (value != null && value.length >= 6)
                    ? null
                    : AppLocalizations.of(context)!.loginPasswordValidation;
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
                    : () async {
                        //hide keyboard
                        FocusScope.of(context).unfocus();

                        if (!loginForm.isValidForm()) return;
                        loginForm.isLoading = true;

                        var wasLoginSuccesfull =
                            await login(email.text, password.text);

                        if (wasLoginSuccesfull) {
                          loginForm.isLoading = false;
                          Navigator.pushReplacementNamed(context, 'home');
                        }

                        loginForm.isLoading = false;
                      },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 80, vertical: 12),
                  child: Text(
                    AppLocalizations.of(context)!.loginButton,
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
