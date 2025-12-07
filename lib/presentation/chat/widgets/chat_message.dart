import 'package:flutter/material.dart';
import 'package:jugaenequipo/theme/app_theme.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage({
    super.key,
    required this.type,
    required this.text,
    required this.timeLabel,
    this.isRead,
  });

  final String type;
  final String text;
  final String timeLabel;
  final bool? isRead; // Only relevant for sender messages

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: (type == "receiver"
            ? Theme.of(context).colorScheme.secondary.withOpacity( 0.2)
            : Theme.of(context).colorScheme.primary),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: type == 'receiver'
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 15,
              color: (type == "receiver"
                  ? Theme.of(context).colorScheme.onSurface
                  : AppTheme.white),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: type == 'receiver' 
                ? MainAxisAlignment.start 
                : MainAxisAlignment.end,
            children: [
              Text(
                timeLabel,
                style: TextStyle(
                  fontSize: 11,
                  color: (type == "receiver"
                      ? Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity( 0.6)
                      : AppTheme.white.withOpacity( 0.6)),
                ),
              ),
              // Show read indicator only for sender messages
              if (type == "sender") ...[
                const SizedBox(width: 4),
                Icon(
                  isRead == true ? Icons.done_all : Icons.done,
                  size: 14,
                  color: isRead == true 
                      ? AppTheme.white.withOpacity(0.9)
                      : AppTheme.white.withOpacity(0.6),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
