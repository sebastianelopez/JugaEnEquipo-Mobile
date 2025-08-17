import 'package:flutter/material.dart';
import 'package:jugaenequipo/presentation/login/business_logic/login_form_provider.dart';
import 'package:jugaenequipo/presentation/login/widgets/login_form.dart';
import 'package:jugaenequipo/global_widgets/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AuthBackground(
            child: SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 400.h,
          ),
          CardContainer(
            backgroundColor: Colors.transparent,
            child: Column(
              children: [
                ChangeNotifierProvider(
                  create: (_) => LoginFormProvider(),
                  child: const LoginForm(),
                ),
              ],
            ),
          ),
          TextButton(
            child: Text('Crear una nueva cuenta',
                style: TextStyle(
                    fontSize: 14.h,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context)
                        .colorScheme
                        .onPrimary
                        .withValues(alpha: 0.7))),
            onPressed: () {
              //hide keyboard
              FocusScope.of(context).unfocus();
              Navigator.pushNamed(context, 'register');
            },
          ),
          SizedBox(
            height: 40.h,
          ),
          const LanguageDropdown(
            showLabel: true,
            alignment: Alignment.center,
          ),
        ],
      ),
    )));
  }
}
