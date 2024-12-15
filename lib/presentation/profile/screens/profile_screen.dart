import 'package:flutter/material.dart';
import 'package:jugaenequipo/presentation/profile/business_logic/profile_provider.dart';
import 'package:jugaenequipo/presentation/profile/widgets/profile_content.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:jugaenequipo/global_widgets/widgets.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  final String? userId; // Optional - if null, shows logged user profile

  const ProfileScreen({
    Key? key,
    this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
