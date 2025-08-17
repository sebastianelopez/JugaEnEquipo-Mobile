import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jugaenequipo/presentation/login/business_logic/login_form_provider.dart';
import 'package:jugaenequipo/ui/input_decorations.dart';
import 'package:jugaenequipo/utils/validator.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 16.h),
              autocorrect: false,
              enableSuggestions: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: AppLocalizations.of(context)!.loginUserHintText,
                hintTextColor: Theme.of(context).colorScheme.onPrimary,
                labelTextColor: Theme.of(context).colorScheme.onPrimary,
              ),
              onTapOutside: (event) =>
                  FocusManager.instance.primaryFocus?.unfocus(),
              onChanged: (value) => email.text = value,
              validator: (value) => value != null
                  ? Validators.isEmail(value: value, context: context)
                  : AppLocalizations.of(context)!.loginUserRequiredValidation,
            ),
            SizedBox(
              height: 30.h,
            ),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: password,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 16.h),
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: AppLocalizations.of(context)!.loginPasswordHintText,
                hintTextColor: Theme.of(context).colorScheme.onPrimary,
                labelTextColor: Theme.of(context).colorScheme.onPrimary,
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
            SizedBox(
              height: 25.w,
            ),
            MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                disabledColor: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.5),
                elevation: 0,
                color: Theme.of(context).colorScheme.primary,
                onPressed: isLoading
                    ? null
                    : () {
                        loginForm.handleLogin(
                            context, email.text, password.text);
                      },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                  child: Text(
                    AppLocalizations.of(context)!.loginButton,
                    style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimary
                                .withValues(alpha: 0.7),
                            fontWeight: FontWeight.w900,
                            fontSize: 16.0.h)),
                  ),
                ))
          ],
        ));
  }
}
