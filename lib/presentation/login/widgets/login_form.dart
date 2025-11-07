import 'package:flutter/material.dart';
import 'package:jugaenequipo/presentation/login/business_logic/login_form_provider.dart';
import 'package:jugaenequipo/utils/validator.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';
import 'package:jugaenequipo/global_widgets/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> with TickerProviderStateMixin {
  late AnimationController _formAnimationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _formAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _formAnimationController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _formAnimationController,
      curve: Curves.easeInOut,
    ));

    Future.delayed(const Duration(milliseconds: 200), () {
      _formAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _formAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);
    final email = loginForm.email;
    final password = loginForm.password;
    final isLoading = loginForm.isLoading;

    return AnimatedBuilder(
      animation: _formAnimationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Form(
              key: loginForm.formKey,
              child: Column(
                children: [
                  AnimatedFormField(
                    controller: email,
                    hintText: AppLocalizations.of(context)!.loginUserHintText,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                    textColor: Theme.of(context).colorScheme.onPrimary,
                    hintTextColor: Theme.of(context)
                        .colorScheme
                        .onPrimary
                        .withOpacity( 0.7),
                    validator: (value) => value != null
                        ? Validators.isEmail(value: value, context: context)
                        : AppLocalizations.of(context)!
                            .loginUserRequiredValidation,
                    onChanged: (value) => email.text = value,
                  ),
                  SizedBox(height: 20.h),
                  AnimatedFormField(
                    controller: password,
                    hintText:
                        AppLocalizations.of(context)!.loginPasswordHintText,
                    obscureText: true,
                    prefixIcon: Icons.lock_outline,
                    textColor: Theme.of(context).colorScheme.onPrimary,
                    hintTextColor: Theme.of(context)
                        .colorScheme
                        .onPrimary
                        .withOpacity( 0.7),
                    validator: (value) {
                      return (value != null && value.length >= 6)
                          ? null
                          : AppLocalizations.of(context)!
                              .loginPasswordValidation;
                    },
                    onChanged: (value) => password.text = value,
                  ),
                  SizedBox(height: 30.h),
                  SizedBox(
                    width: double.infinity,
                    child: AnimatedButton(
                      text: AppLocalizations.of(context)!.loginButton,
                      isLoading: isLoading,
                      icon: Icons.login,
                      onPressed: isLoading
                          ? null
                          : () {
                              if (loginForm.formKey.currentState?.validate() ??
                                  false) {
                                loginForm.handleLogin(
                                    context, email.text, password.text);
                              }
                            },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
