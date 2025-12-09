import 'package:flutter/material.dart';
import 'package:jugaenequipo/presentation/notifications/business_logic/notifications_provider.dart';
import 'package:jugaenequipo/presentation/notifications/widgets/widgets.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';
import 'package:jugaenequipo/global_widgets/widgets.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  NotificationsProvider? _provider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Save reference to provider when dependencies change
    _provider = Provider.of<NotificationsProvider>(context, listen: false);
  }

  @override
  void initState() {
    super.initState();
    // Initialize the provider if not already initialized
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      final provider =
          Provider.of<NotificationsProvider>(context, listen: false);

      if (!provider.isInitialized) {
        await provider.initialize();
      }
    });
  }

  @override
  void dispose() {
    // Mark all unread notifications as read when leaving the screen
    // Execute asynchronously after dispose to avoid widget tree lock
    final provider = _provider;
    if (provider != null && provider.unreadCount > 0) {
      // Schedule the operation to run after the current frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        provider.markAllUnreadAsRead();
      });
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        label: AppLocalizations.of(context)!.notificationsPageLabel,
        backgroundColor: AppTheme.primary,
      ),
      body: const NotificationsList(),
    );
  }
}
