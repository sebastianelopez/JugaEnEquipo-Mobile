import 'package:flutter/material.dart';
import 'package:jugaenequipo/presentation/chat/business_logic/chat_provider.dart';
import 'package:jugaenequipo/presentation/chat/widgets/widgets.dart';
import 'package:jugaenequipo/share_preferences/preferences.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Preferences.isDarkmode;
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: ChatAppbar(),
      ),
      body: Container(
        color: isDarkTheme ? Colors.grey[900] : Colors.white,
        child: SafeArea(
          child: Stack(
            children: <Widget>[
              ChangeNotifierProvider(
                create: (context) => ChatProvider(),
                child: Container(
                  color: isDarkTheme ? Colors.grey[850] : Colors.white,
                  child: const ChatMessagesList()),
              ),
              const ChatBottomBar(),
            ],
          ),
        ),
      ),
    );
  }
}
