import 'package:flutter/material.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:jugaenequipo/presentation/profile/widgets/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:jugaenequipo/providers/user_provider.dart';
import 'package:jugaenequipo/share_preferences/preferences.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:jugaenequipo/global_widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserModel? user = Provider.of<UserProvider>(context).user;

    return Scaffold(
        backgroundColor: AppTheme.primary,
        appBar: BackAppBar(
          label: AppLocalizations.of(context)!.profilePageLabel,
        ),
      body: ChangeNotifierProvider(
        create: (context) => ProfileProvider(
          context: context,
          userId: userId, // Pass userId to provider
        ),
        child: const ProfileContent(),
      ),
    );
  }
}
