import 'package:flutter/material.dart';
import 'package:jugaenequipo/theme/app_theme.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage({
    super.key,
    required this.type,
    required this.text,
    required this.timeLabel,
  });

  final String type;
  final String text;
  final String timeLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: (type == "receiver"
            ? Theme.of(context).colorScheme.secondary.withValues(alpha: 0.2)
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
          Text(
            timeLabel,
            style: TextStyle(
              fontSize: 11,
              color: (type == "receiver"
                  ? Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.6)
                  : AppTheme.white.withValues(alpha: 0.6)),
            ),
          ),
        ],
      ),
    );
  }
}
