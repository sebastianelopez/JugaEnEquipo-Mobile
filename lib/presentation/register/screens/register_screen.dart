import 'package:flutter/material.dart';
import 'package:jugaenequipo/datasources/user_use_cases/create_user_use_case.dart';
import 'package:jugaenequipo/presentation/register/business_logic/register_form_provider.dart';
import 'package:jugaenequipo/utils/validator.dart';
import 'package:jugaenequipo/global_widgets/widgets.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AuthBackground(
            child: SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 250.h,
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
            child: Text('¿Ya tienes cuenta? Inicia Sesion',
                style: TextStyle(
                    fontSize: 18.h,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context)
                        .colorScheme
                        .onPrimary
                        .withValues(alpha: 0.7))),
            onPressed: () {
              //hide keyboard
              FocusScope.of(context).unfocus();
              Navigator.pushNamed(context, 'login');
            },
          ),
          SizedBox(
            height: 50.h,
          ),
        ],
      ),
    )));
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
          0.6 + (index * 0.1),
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
              hintText: 'First Name',
              prefixIcon: Icons.person_outline,
              textColor: AppTheme.white,
              hintTextColor: AppTheme.white.withValues(alpha: 0.7),
              validator: (value) {
                return (value != null && value.length > 2)
                    ? null
                    : 'Enter a valid name.';
              },
              onChanged: (value) => firstName.text = value,
            ),
          ),
          SizedBox(height: 16.h),
          _buildAnimatedField(
            index: 1,
            child: AnimatedFormField(
              controller: lastName,
              hintText: 'Last Name',
              prefixIcon: Icons.person_outline,
              textColor: AppTheme.white,
              hintTextColor: AppTheme.white.withValues(alpha: 0.7),
              validator: (value) {
                return (value != null && value.isNotEmpty)
                    ? null
                    : 'Last name is required';
              },
              onChanged: (value) => lastName.text = value,
            ),
          ),
          SizedBox(height: 16.h),
          _buildAnimatedField(
            index: 2,
            child: AnimatedFormField(
              controller: userName,
              hintText: 'Username',
              prefixIcon: Icons.alternate_email,
              textColor: AppTheme.white,
              hintTextColor: AppTheme.white.withValues(alpha: 0.7),
              validator: (value) {
                return (value != null && value.length > 2)
                    ? null
                    : 'User name should have at least 3 characters';
              },
              onChanged: (value) => userName.text = value,
            ),
          ),
          SizedBox(height: 16.h),
          _buildAnimatedField(
            index: 3,
            child: AnimatedFormField(
              controller: email,
              hintText: 'Email',
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icons.email_outlined,
              textColor: AppTheme.white,
              hintTextColor: AppTheme.white.withValues(alpha: 0.7),
              validator: (value) => value != null
                  ? Validators.isEmail(value: value, context: context)
                  : 'Email is required',
              onChanged: (value) => email.text = value,
            ),
          ),
          SizedBox(height: 16.h),
          _buildAnimatedField(
            index: 4,
            child: AnimatedFormField(
              controller: password,
              hintText: 'Password',
              obscureText: true,
              prefixIcon: Icons.lock_outline,
              textColor: AppTheme.white,
              hintTextColor: AppTheme.white.withValues(alpha: 0.7),
              validator: (value) {
                return (value != null && value.length >= 6)
                    ? null
                    : 'The password must be at least six characters.';
              },
              onChanged: (value) => password.text = value,
            ),
          ),
          SizedBox(height: 16.h),
          _buildAnimatedField(
            index: 5,
            child: AnimatedFormField(
              controller: confirmationPassword,
              hintText: 'Repeat password',
              obscureText: true,
              prefixIcon: Icons.lock_outline,
              textColor: AppTheme.white,
              hintTextColor: AppTheme.white.withValues(alpha: 0.7),
              validator: (value) {
                if (value == null || value.length < 6) {
                  return 'The password must be at least six characters.';
                }
                if (value != password.text) {
                  return 'Passwords do not match.';
                }
                return null;
              },
              onChanged: (value) => confirmationPassword.text = value,
            ),
          ),
          SizedBox(height: 24.h),
          _buildAnimatedField(
            index: 6,
            child: SizedBox(
              width: double.infinity,
              child: AnimatedButton(
                text: 'Register',
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
                                content: Text('Error creating account: $e'),
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
