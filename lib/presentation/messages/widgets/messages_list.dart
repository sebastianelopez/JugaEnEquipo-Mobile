
import 'package:flutter/material.dart';
import 'package:jugaenequipo/presentation/messages/business_logic/messages_provider.dart';
import 'package:jugaenequipo/presentation/messages/widgets/widgets.dart';
import 'package:provider/provider.dart';

class MessagesList extends StatelessWidget {
  const MessagesList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final messagesProvider = Provider.of<MessagesProvider>(context);

    return ListView.builder(
      itemCount: messagesProvider.chatsMocks.length,
      shrinkWrap: true,
      padding: const EdgeInsets.only(top: 16),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return MessagesListItem(
          user: messagesProvider.chatsMocks[index].user,
          messageText:
              messagesProvider.chatsMocks[index].messageText,
          time: messagesProvider.chatsMocks[index].time,
          isMessageRead:
              (index == 0 || index == 3) ? true : false,
        );
      },
    );
  }
}