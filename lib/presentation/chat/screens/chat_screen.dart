import 'package:flutter/material.dart';
import 'package:jugaenequipo/presentation/chat/business_logic/chat_provider.dart';
import 'package:jugaenequipo/presentation/chat/widgets/widgets.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: ChatAppbar(),
      ),
      body: Stack(
        children: <Widget>[
          ChangeNotifierProvider(
            create: (context) => ChatProvider(),
            child: const ChatMessagesList(),
          ),
          const ChatBottomBar(),
        ],
      ),
    );
  }
}
