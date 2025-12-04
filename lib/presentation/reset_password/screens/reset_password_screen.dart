import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jugaenequipo/global_widgets/widgets.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';
import 'package:jugaenequipo/presentation/reset_password/business_logic/reset_password_provider.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:jugaenequipo/utils/validator.dart';
import 'package:provider/provider.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String token;

  const ResetPasswordScreen({super.key, required this.token});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  bool _obscureNewPassword = true;
  bool _obscureConfirmationPassword = true;
  bool _showPasswordRequirements = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final resetPasswordProvider =
        Provider.of<ResetPasswordProvider>(context, listen: true);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    AppTheme.darkBg,
                    AppTheme.primary.withOpacity(0.3),
                    AppTheme.darkBg,
                  ]
                : [
                    AppTheme.lightBg,
                    AppTheme.primary.withOpacity(0.1),
                    AppTheme.accent.withOpacity(0.15),
                  ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Decorative circles
            Positioned(
              top: -100.h,
              right: -100.w,
              child: Container(
                width: 300.w,
                height: 300.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppTheme.primary.withOpacity(0.2),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -150.h,
              left: -150.w,
              child: Container(
                width: 400.w,
                height: 400.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppTheme.accent.withOpacity(0.15),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            // Content
            SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    children: [
                      SizedBox(height: 40.h),
                      // Back button
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      // Logo
                      Image.asset(
                        'assets/juga-en-equipo_violeta-1.png',
                        width: 300.w,
                        height: 150.h,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: 30.h),
                      // Form
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(20.r),
                          boxShadow: [
                            BoxShadow(
                              color: isDark
                                  ? Colors.black.withOpacity(0.3)
                                  : Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              spreadRadius: 0,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(28.w),
                          child: Form(
                            key: resetPasswordProvider.formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!
                                      .resetPasswordTitle,
                                  style: TextStyle(
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  AppLocalizations.of(context)!
                                      .resetPasswordSubtitle,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withOpacity(0.7),
                                  ),
                                ),
                                SizedBox(height: 30.h),
                                if (resetPasswordProvider.errorMessage != null)
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
                                            resetPasswordProvider.errorMessage!,
                                            style: TextStyle(
                                              color: AppTheme.error,
                                              fontSize: 12.sp,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                if (resetPasswordProvider.isSuccess)
                                  Container(
                                    padding: EdgeInsets.all(12.w),
                                    margin: EdgeInsets.only(bottom: 20.h),
                                    decoration: BoxDecoration(
                                      color: AppTheme.success.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8.r),
                                      border: Border.all(
                                        color:
                                            AppTheme.success.withOpacity(0.3),
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
                                            AppLocalizations.of(context)!
                                                .resetPasswordSuccess,
                                            style: TextStyle(
                                              color: AppTheme.success,
                                              fontSize: 12.sp,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                AnimatedFormField(
                                  controller:
                                      resetPasswordProvider.newPassword,
                                  hintText: AppLocalizations.of(context)!
                                      .registerPasswordHint,
                                  obscureText: _obscureNewPassword,
                                  prefixIcon: Icons.lock_outline,
                                  suffixIcon: _obscureNewPassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  onSuffixIconTap: () {
                                    setState(() {
                                      _obscureNewPassword =
                                          !_obscureNewPassword;
                                    });
                                  },
                                  textColor:
                                      Theme.of(context).colorScheme.onSurface,
                                  hintTextColor: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.6),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    final error = Validators.password(
                                      value: value,
                                      context: context,
                                    );
                                    if (error != null) {
                                      setState(() {
                                        _showPasswordRequirements = true;
                                      });
                                    } else {
                                      setState(() {
                                        _showPasswordRequirements = false;
                                      });
                                    }
                                    return error;
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      _showPasswordRequirements =
                                          value.isNotEmpty;
                                    });
                                    resetPasswordProvider.newPassword.text =
                                        value;
                                  },
                                ),
                                PasswordRequirements(
                                  password:
                                      resetPasswordProvider.newPassword.text,
                                  isVisible: _showPasswordRequirements,
                                ),
                                SizedBox(height: 20.h),
                                AnimatedFormField(
                                  controller: resetPasswordProvider
                                      .confirmationPassword,
                                  hintText: AppLocalizations.of(context)!
                                      .registerConfirmPasswordHint,
                                  obscureText: _obscureConfirmationPassword,
                                  prefixIcon: Icons.lock_outline,
                                  suffixIcon: _obscureConfirmationPassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  onSuffixIconTap: () {
                                    setState(() {
                                      _obscureConfirmationPassword =
                                          !_obscureConfirmationPassword;
                                    });
                                  },
                                  textColor:
                                      Theme.of(context).colorScheme.onSurface,
                                  hintTextColor: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.6),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) => Validators
                                      .confirmPassword(
                                    value: value,
                                    passwordValue:
                                        resetPasswordProvider.newPassword.text,
                                    context: context,
                                  ),
                                  onChanged: (value) {
                                    resetPasswordProvider
                                        .confirmationPassword.text = value;
                                  },
                                ),
                                SizedBox(height: 30.h),
                                SizedBox(
                                  width: double.infinity,
                                  child: AnimatedButton(
                                    text: resetPasswordProvider.isSuccess
                                        ? AppLocalizations.of(context)!
                                            .resetPasswordGoToLogin
                                        : AppLocalizations.of(context)!
                                            .resetPasswordButton,
                                    isLoading: resetPasswordProvider.isLoading,
                                    icon: resetPasswordProvider.isSuccess
                                        ? Icons.login
                                        : Icons.lock_reset,
                                    onPressed: resetPasswordProvider.isLoading
                                        ? null
                                        : resetPasswordProvider.isSuccess
                                            ? () {
                                                Navigator.pushReplacementNamed(
                                                    context, 'login');
                                              }
                                            : () {
                                                resetPasswordProvider
                                                    .resetPassword(
                                                        widget.token, context);
                                              },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

