import 'package:flutter/material.dart';
import 'package:jugaenequipo/presentation/chat/business_logic/chat_provider.dart';
import 'package:provider/provider.dart';

class ChatMessagesList extends StatelessWidget {
  const ChatMessagesList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 50.0),
      scrollDirection: Axis.vertical,
      child: ListView.builder(
        itemCount: chatProvider.messages.length,
        shrinkWrap: true,
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Container(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
            child: Align(
              alignment: (chatProvider.messages[index].messageType == "receiver"
                  ? Alignment.topLeft
                  : Alignment.topRight),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: (chatProvider.messages[index].messageType == "receiver"
                      ? Colors.grey.shade200
                      : Colors.red[200]),
                ),
                padding: const EdgeInsets.all(16),
                child: Text(
                  chatProvider.messages[index].messageContent,
                  style: const TextStyle(fontSize: 15),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
