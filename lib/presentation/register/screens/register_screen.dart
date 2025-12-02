import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:jugaenequipo/datasources/user_use_cases/create_user_use_case.dart';
import 'package:jugaenequipo/presentation/register/business_logic/register_form_provider.dart';
import 'package:jugaenequipo/utils/validator.dart';
import 'package:jugaenequipo/global_widgets/widgets.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                      SizedBox(height: 30.h),
                      // Logo sin contenedor, más limpio
                      Image.asset(
                        'assets/logo_text_bottom.png',
                        width: 400.w,
                        height: 180.h,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: 30.h),
                      // Form con fondo sólido del tema
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
                          child: ChangeNotifierProvider(
                            create: (_) => RegisterFormProvider(),
                            child: _RegisterForm(),
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),
                      TextButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          Navigator.pushNamed(context, 'login');
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 24.w,
                            vertical: 12.h,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: AppTheme.primary.withOpacity(0.5),
                              width: 2,
                            ),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!
                                .registerAlreadyHaveAccount,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primary,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),
                      SettingsControls(),
                      SizedBox(height: 40.h),
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

class _RegisterForm extends StatefulWidget {
  @override
  State<_RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<_RegisterForm>
    with TickerProviderStateMixin {
  late AnimationController _formAnimationController;
  late List<Animation<double>> _fieldAnimations;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _showPasswordRequirements = false;

  @override
  void initState() {
    super.initState();

    _formAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fieldAnimations = List.generate(7, (index) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _formAnimationController,
        curve: Interval(
          index * 0.1,
          math.min(1.0, 0.6 + (index * 0.1)),
          curve: Curves.easeOutCubic,
        ),
      ));
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      _formAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _formAnimationController.dispose();
    super.dispose();
  }

  Widget _buildAnimatedField({
    required int index,
    required Widget child,
  }) {
    return AnimatedBuilder(
      animation: _fieldAnimations[index],
      builder: (context, _) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - _fieldAnimations[index].value)),
          child: Opacity(
            opacity: _fieldAnimations[index].value,
            child: child,
          ),
        );
      },
    );
  }

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
          _buildAnimatedField(
            index: 0,
            child: AnimatedFormField(
              controller: firstName,
              hintText: AppLocalizations.of(context)!.registerFirstNameHint,
              prefixIcon: Icons.person_outline,
              textColor: Theme.of(context).colorScheme.onSurface,
              hintTextColor:
                  Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              validator: (value) => Validators.firstName(
                value: value,
                context: context,
              ),
              onChanged: (value) => firstName.text = value,
            ),
          ),
          SizedBox(height: 16.h),
          _buildAnimatedField(
            index: 1,
            child: AnimatedFormField(
              controller: lastName,
              hintText: AppLocalizations.of(context)!.registerLastNameHint,
              prefixIcon: Icons.person_outline,
              textColor: Theme.of(context).colorScheme.onSurface,
              hintTextColor:
                  Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              validator: (value) => Validators.lastName(
                value: value,
                context: context,
              ),
              onChanged: (value) => lastName.text = value,
            ),
          ),
          SizedBox(height: 16.h),
          _buildAnimatedField(
            index: 2,
            child: AnimatedFormField(
              controller: userName,
              hintText: AppLocalizations.of(context)!.registerUsernameHint,
              prefixIcon: Icons.alternate_email,
              textColor: Theme.of(context).colorScheme.onSurface,
              hintTextColor:
                  Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              validator: (value) => Validators.username(
                value: value,
                context: context,
              ),
              onChanged: (value) => userName.text = value,
            ),
          ),
          SizedBox(height: 16.h),
          _buildAnimatedField(
            index: 3,
            child: AnimatedFormField(
              controller: email,
              hintText: AppLocalizations.of(context)!.registerEmailHint,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icons.email_outlined,
              textColor: Theme.of(context).colorScheme.onSurface,
              hintTextColor:
                  Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              validator: (value) => Validators.email(
                value: value,
                context: context,
              ),
              onChanged: (value) => email.text = value,
            ),
          ),
          SizedBox(height: 16.h),
          _buildAnimatedField(
            index: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedFormField(
                  controller: password,
                  hintText: AppLocalizations.of(context)!.registerPasswordHint,
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
                  hintTextColor:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  validator: (value) {
                    final error = Validators.password(
                      value: value,
                      context: context,
                    );
                    // Update requirements visibility based on error
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {
                        setState(() {
                          _showPasswordRequirements =
                              password.text.isNotEmpty || error != null;
                        });
                      }
                    });
                    return error;
                  },
                  onChanged: (value) {
                    password.text = value;
                    setState(() {
                      _showPasswordRequirements = value.isNotEmpty;
                    });
                  },
                  onFocusChange: (isFocused) {
                    setState(() {
                      _showPasswordRequirements =
                          isFocused || password.text.isNotEmpty;
                    });
                  },
                ),
                PasswordRequirements(
                  password: password.text,
                  isVisible: _showPasswordRequirements,
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          _buildAnimatedField(
            index: 5,
            child: AnimatedFormField(
              controller: confirmationPassword,
              hintText:
                  AppLocalizations.of(context)!.registerConfirmPasswordHint,
              obscureText: _obscureConfirmPassword,
              prefixIcon: Icons.lock_outline,
              suffixIcon: _obscureConfirmPassword
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              onSuffixIconTap: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },
              textColor: Theme.of(context).colorScheme.onSurface,
              hintTextColor:
                  Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              validator: (value) => Validators.confirmPassword(
                value: value,
                passwordValue: password.text,
                context: context,
              ),
              onChanged: (value) => confirmationPassword.text = value,
            ),
          ),
          SizedBox(height: 24.h),
          _buildAnimatedField(
            index: 6,
            child: SizedBox(
              width: double.infinity,
              child: AnimatedButton(
                text: AppLocalizations.of(context)!.registerButton,
                isLoading: isLoading,
                icon: Icons.person_add,
                onPressed: isLoading
                    ? null
                    : () async {
                        FocusScope.of(context).unfocus();

                        if (registerForm.formKey.currentState?.validate() ??
                            false) {
                          registerForm.isLoading = true;

                          try {
                            await createUser(
                              firstName.text,
                              lastName.text,
                              userName.text,
                              email.text,
                              password.text,
                              confirmationPassword.text,
                            );

                            if (context.mounted) {
                              Navigator.pushReplacementNamed(context, 'home');
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    '${AppLocalizations.of(context)!.registerErrorCreatingAccount}: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          } finally {
                            registerForm.isLoading = false;
                          }
                        }
                      },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
