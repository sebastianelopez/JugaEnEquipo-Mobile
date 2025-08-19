import 'package:flutter/material.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:jugaenequipo/presentation/chat/business_logic/chat_provider.dart';

class ChatAppbar extends StatelessWidget {
  final String? displayName;
  final String? avatarUrl;

  const ChatAppbar({
    super.key,
    this.displayName,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    // Try to resolve name from provided value; if not present, infer from messages
    String resolvedName = (displayName ?? '').trim();
    if (resolvedName.isEmpty) {
      final chatProvider = context.read<ChatProvider?>();
      if (chatProvider != null) {
        for (final message in chatProvider.messages) {
          final isOther =
              (message.mine == false) || (message.messageType == 'receiver');
          if (isOther) {
            resolvedName = (message.username ?? '').trim();
            if (resolvedName.isNotEmpty) break;
          }
        }
      }
    }
    if (resolvedName.isEmpty) {
      resolvedName = 'Chat';
    }

    final String? imageUrl =
        (avatarUrl != null && avatarUrl!.isNotEmpty) ? avatarUrl : null;

    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: AppTheme.primary,
      flexibleSpace: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(right: 16),
          child: Row(
            children: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              const SizedBox(
                width: 2,
              ),
              CircleAvatar(
                backgroundImage: (imageUrl != null &&
                        (imageUrl.startsWith('http://') ||
                            imageUrl.startsWith('https://')))
                    ? Image.network(
                        imageUrl,
                        errorBuilder: (context, error, stackTrace) =>
                            Image.asset('assets/error.png'),
                      ).image
                    : const AssetImage('assets/user_image.jpg')
                        as ImageProvider,
                maxRadius: 20,
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      resolvedName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      "Online",
                      style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimary
                              .withValues(alpha: 0.7),
                          fontSize: 13),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.settings,
                color: Theme.of(context)
                    .colorScheme
                    .onPrimary
                    .withValues(alpha: 0.6),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
