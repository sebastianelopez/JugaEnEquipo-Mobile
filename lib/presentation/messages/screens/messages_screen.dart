import 'package:flutter/material.dart';
import 'package:jugaenequipo/presentation/messages/business_logic/messages_provider.dart';
import 'package:jugaenequipo/presentation/messages/widgets/widgets.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';
import 'package:jugaenequipo/global_widgets/widgets.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MessagesProvider(),
      child: Scaffold(
        appBar: BackAppBar(
          label: AppLocalizations.of(context)!.messagesPageLabel,
          backgroundColor: AppTheme.primary,
        ),
        body: const SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MessagesList(),
            ],
          ),
        ),
      ),
    );
  }
}
