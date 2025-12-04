import 'package:flutter/material.dart';
import 'package:jugaenequipo/presentation/login/business_logic/login_form_provider.dart';
import 'package:jugaenequipo/presentation/login/widgets/login_form.dart';
import 'package:jugaenequipo/global_widgets/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:jugaenequipo/theme/app_theme.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
                      SizedBox(height: 40.h),
                      // Logo sin contenedor, más limpio
                      Image.asset(
                        'assets/juga-en-equipo_violeta-1.png',
                        width: 400.w,
                        height: 200.h,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: 50.h),
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
                            create: (_) => LoginFormProvider(),
                            child: const LoginForm(),
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),
                      TextButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          Navigator.pushNamed(context, 'register');
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
                            'Crear una nueva cuenta',
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
