import 'package:flutter/material.dart';
import 'package:jugaenequipo/presentation/chat/business_logic/chat_provider.dart';
import 'package:jugaenequipo/providers/user_provider.dart';
import 'package:jugaenequipo/presentation/chat/widgets/widgets.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatProvider _provider = ChatProvider();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentUsername = context.read<UserProvider?>()?.user?.userName;
      if (currentUsername != null && currentUsername.isNotEmpty) {
        _provider.setCurrentUsername(currentUsername);
      }
      final args = ModalRoute.of(context)?.settings.arguments;
      final conversationId = (args is Map && args['conversationId'] is String)
          ? args['conversationId'] as String
          : null;
      if (conversationId != null) {
        _provider.loadConversation(conversationId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _provider,
      child: Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: ChatAppbar(),
        ),
        body: Container(
          color: Theme.of(context).colorScheme.surface,
          child: SafeArea(
            child: Stack(
              children: <Widget>[
                Container(
                  color: Theme.of(context).colorScheme.surface,
                  child: const ChatMessagesList(),
                ),
                const ChatBottomBar(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
