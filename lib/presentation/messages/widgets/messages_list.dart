import 'package:flutter/material.dart';
import 'package:jugaenequipo/presentation/messages/business_logic/messages_provider.dart';
import 'package:jugaenequipo/presentation/messages/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:jugaenequipo/datasources/models/models.dart';

class MessagesList extends StatelessWidget {
  const MessagesList({
    super.key,
  });

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
              Text(messagesProvider.errorMessage!),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => messagesProvider.refreshConversations(),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    if (messagesProvider.conversations.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text('No hay conversaciones'),
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
        
        return MessagesListItem(
          user: user,
          messageText: conversation.lastMessageText ?? '',
          time: conversation.lastMessageDate ?? '',
          isMessageRead: false,
          conversationId: conversation.id,
        );
      },
    );
  }
}