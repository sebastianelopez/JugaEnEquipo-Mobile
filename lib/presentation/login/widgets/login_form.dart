import 'package:flutter/material.dart';
import 'package:jugaenequipo/presentation/login/business_logic/login_form_provider.dart';
import 'package:jugaenequipo/utils/validator.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';
import 'package:jugaenequipo/global_widgets/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:jugaenequipo/datasources/user_use_cases/forgot_password_use_case.dart';
import 'package:jugaenequipo/datasources/api_service.dart';
import 'package:jugaenequipo/theme/app_theme.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> with TickerProviderStateMixin {
  late AnimationController _formAnimationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;
  bool _obscurePassword = true;

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
                    textColor: Theme.of(context).colorScheme.onSurface,
                    hintTextColor: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6),
                    autovalidateMode: AutovalidateMode.onUnfocus,
                    validator: (value) => Validators.email(
                      value: value,
                      context: context,
                    ),
                    onChanged: (value) => email.text = value,
                  ),
                  SizedBox(height: 20.h),
                  AnimatedFormField(
                    controller: password,
                    hintText:
                        AppLocalizations.of(context)!.loginPasswordHintText,
                    obscureText: _obscurePassword,
                    prefixIcon: Icons.lock_outline,
                    suffixIcon: _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    onSuffixIconTap: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    textColor: Theme.of(context).colorScheme.onSurface,
                    hintTextColor: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6),
                    autovalidateMode: AutovalidateMode.onUnfocus,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!
                            .loginPasswordValidation;
                      }
                      return null;
                    },
                    onChanged: (value) => password.text = value,
                  ),
                  SizedBox(height: 12.h),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        _showForgotPasswordDialog(context);
                      },
                      child: Text(
                        AppLocalizations.of(context)!.loginForgotPassword,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppTheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
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

  void _showForgotPasswordDialog(BuildContext context) {
    final emailController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool isLoading = false;
    bool isSuccess = false;
    String? errorMessage;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          title: Text(
            AppLocalizations.of(context)!.forgotPasswordTitle,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.forgotPasswordSubtitle,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.7),
                  ),
                ),
                SizedBox(height: 20.h),
                if (isSuccess)
                  Container(
                    padding: EdgeInsets.all(12.w),
                    margin: EdgeInsets.only(bottom: 20.h),
                    decoration: BoxDecoration(
                      color: AppTheme.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: AppTheme.success.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          color: AppTheme.success,
                          size: 20.sp,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            AppLocalizations.of(context)!.forgotPasswordSuccess,
                            style: TextStyle(
                              color: AppTheme.success,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (errorMessage != null)
                  Container(
                    padding: EdgeInsets.all(12.w),
                    margin: EdgeInsets.only(bottom: 20.h),
                    decoration: BoxDecoration(
                      color: AppTheme.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: AppTheme.error.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: AppTheme.error,
                          size: 20.sp,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            errorMessage!,
                            style: TextStyle(
                              color: AppTheme.error,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (!isSuccess)
                  Form(
                    key: formKey,
                    child: AnimatedFormField(
                      controller: emailController,
                      hintText:
                          AppLocalizations.of(context)!.forgotPasswordEmailHint,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icons.email_outlined,
                      textColor: Theme.of(context).colorScheme.onSurface,
                      hintTextColor: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.6),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) =>
                          Validators.email(value: value, context: context),
                      onChanged: (value) => emailController.text = value,
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            if (!isSuccess)
              TextButton(
                onPressed: isLoading ? null : () => Navigator.of(context).pop(),
                child: Text(
                  'Cancelar',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            if (isSuccess)
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Cerrar',
                  style: TextStyle(
                    color: AppTheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            else
              TextButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        if (formKey.currentState?.validate() ?? false) {
                          setState(() {
                            isLoading = true;
                            errorMessage = null;
                          });

                          final result = await forgotPassword(
                            emailController.text.trim(),
                          );

                          setState(() {
                            isLoading = false;
                            if (result == Result.success) {
                              isSuccess = true;
                            } else {
                              errorMessage = AppLocalizations.of(context)!
                                  .forgotPasswordError;
                            }
                          });
                        }
                      },
                child: isLoading
                    ? SizedBox(
                        width: 16.w,
                        height: 16.h,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.primary,
                          ),
                        ),
                      )
                    : Text(
                        AppLocalizations.of(context)!.forgotPasswordButton,
                        style: TextStyle(
                          color: AppTheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
          ],
        ),
      ),
    );
  }
}
