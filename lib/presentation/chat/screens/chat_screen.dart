import 'package:flutter/material.dart';
import 'package:jugaenequipo/datasources/models/user_model.dart';
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
  String? _appBarName;
  String? _appBarAvatar;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentUsername = context.read<UserProvider?>()?.user?.userName;
      if (currentUsername != null && currentUsername.isNotEmpty) {
        _provider.setCurrentUsername(currentUsername);
      }
      final args = ModalRoute.of(context)?.settings.arguments;
      String? conversationId;
      String? otherDisplayName;
      String? otherAvatar;

      if (args is Map) {
        if (args['conversationId'] is String) {
          conversationId = args['conversationId'] as String?;
        }
        if (args['otherUserName'] is String) {
          otherDisplayName = args['otherUserName'] as String?;
        }
        if (args['otherUserAvatar'] is String) {
          otherAvatar = args['otherUserAvatar'] as String?;
        }
      } else if (args is UserModel) {
        otherDisplayName = args.userName;
        otherAvatar = args.profileImage;
      }
      if (conversationId != null) {
        _provider.loadConversation(conversationId);
      }
      setState(() {
        _appBarName = otherDisplayName;
        _appBarAvatar = otherAvatar;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Resolve app bar info from initial args or messages as fallback in the app bar itself
    return ChangeNotifierProvider.value(
      value: _provider,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: ChatAppbar(
            displayName: _appBarName,
            avatarUrl: _appBarAvatar,
          ),
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
