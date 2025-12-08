import 'package:flutter/material.dart';
import 'package:jugaenequipo/presentation/messages/business_logic/messages_provider.dart';
import 'package:jugaenequipo/presentation/messages/widgets/widgets.dart';
import 'package:jugaenequipo/presentation/notifications/business_logic/notifications_provider.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';
import 'package:jugaenequipo/global_widgets/widgets.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  @override
  void initState() {
    super.initState();
    // Mark all messages as read when screen is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notificationsProvider =
          Provider.of<NotificationsProvider>(context, listen: false);
      notificationsProvider.markAllMessagesAsRead();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Silently refresh conversations when screen becomes visible again
    // Add a small delay to ensure backend has updated unreadCount
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 300), () {
        try {
          if (!mounted) return;
          final messagesProvider =
              Provider.of<MessagesProvider>(context, listen: false);
          // Only do silent refresh if we already have conversations loaded
          // Otherwise, let the initial load handle it
          if (messagesProvider.conversations.isNotEmpty) {
            messagesProvider.silentRefreshConversations();
            // Do a second silent refresh after a bit more time to ensure backend has updated
            Future.delayed(const Duration(milliseconds: 1000), () {
              try {
                if (messagesProvider.conversations.isNotEmpty) {
                  messagesProvider.silentRefreshConversations();
                }
              } catch (e) {
                // Provider might not be available
              }
            });
          }
        } catch (e) {
          // Provider might not be available yet
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final provider = MessagesProvider();
        // Set up callback to update notifications when unread count changes
        WidgetsBinding.instance.addPostFrameCallback((_) {
          try {
            final notificationsProvider =
                Provider.of<NotificationsProvider>(context, listen: false);
            provider.setOnUnreadCountChangedCallback(() {
              // When unread count changes, mark message notifications as read if count is 0
              // or refresh to sync with backend
              notificationsProvider.markAllMessagesAsRead();
            });
          } catch (e) {
            // NotificationsProvider might not be available
          }
        });
        return provider;
      },
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
