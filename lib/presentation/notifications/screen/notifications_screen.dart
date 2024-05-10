import 'package:flutter/material.dart';
import 'package:jugaenequipo/presentation/notifications/business_logic/notifications_provider.dart';
import 'package:jugaenequipo/presentation/notifications/widgets/widgets.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:jugaenequipo/widgets/widgets.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size(double.infinity, 50),
          child: BackAppBar(
            label: AppLocalizations.of(context)!.notificationsPageLabel,
            backgroundColor: AppTheme.primary,
          )),
      body: ChangeNotifierProvider(
        create: (context) => NotificationsProvider(),
        child: const SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NotificationsList(),
            ],
          ),
        ),
      ),
    );
  }
}
