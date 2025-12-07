import 'package:flutter/material.dart';
import 'package:jugaenequipo/presentation/messages/business_logic/messages_provider.dart';
import 'package:jugaenequipo/presentation/messages/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';

class MessagesList extends StatefulWidget {
  const MessagesList({
    super.key,
  });

  @override
  State<MessagesList> createState() => _MessagesListState();
}

class _MessagesListState extends State<MessagesList> {
  @override
  Widget build(BuildContext context) {
    final messagesProvider = Provider.of<MessagesProvider>(context);

    if (messagesProvider.isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (messagesProvider.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                messagesProvider.errorMessage == 'errorLoadingConversations'
                    ? AppLocalizations.of(context)!.errorLoadingConversations
                    : messagesProvider.errorMessage!,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => messagesProvider.refreshConversations(),
                child: Text(AppLocalizations.of(context)!.retryButton),
              ),
            ],
          ),
        ),
      );
    }

    if (messagesProvider.conversations.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Text(AppLocalizations.of(context)!.noConversations),
        ),
      );
    }

    return ListView.builder(
      itemCount: messagesProvider.conversations.length,
      shrinkWrap: true,
      padding: const EdgeInsets.only(top: 16),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final conversation = messagesProvider.conversations[index];
        final user = UserModel(
          id: conversation.otherUserId,
          firstName: conversation.otherFirstname,
          lastName: conversation.otherLastname,
          userName: conversation.otherUsername,
          profileImage: conversation.otherProfileImage,
        );

        return _AnimatedConversationItem(
          key: ValueKey(conversation.id), // Stable key for smooth reordering
          conversationId: conversation.id,
          index: index,
          child: MessagesListItem(
            user: user,
            messageText: conversation.lastMessageText ?? '',
            time: conversation.lastMessageDate ?? '',
            isMessageRead: conversation.unreadCount == 0,
            unreadCount: conversation.unreadCount,
            conversationId: conversation.id,
          ),
        );
      },
    );
  }
}

/// Widget that provides smooth animations when items are added or reordered
class _AnimatedConversationItem extends StatefulWidget {
  final String conversationId;
  final int index;
  final Widget child;

  const _AnimatedConversationItem({
    required super.key,
    required this.conversationId,
    required this.index,
    required this.child,
  });

  @override
  State<_AnimatedConversationItem> createState() =>
      _AnimatedConversationItemState();
}

class _AnimatedConversationItemState extends State<_AnimatedConversationItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(_AnimatedConversationItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If item moved to top (index 0), animate a highlight effect
    if (oldWidget.index != 0 && widget.index == 0) {
      _controller.reset();
      _controller.forward();
    } else if (oldWidget.index != widget.index) {
      // Item position changed, do a subtle animation
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: widget.child,
      ),
    );
  }
}
