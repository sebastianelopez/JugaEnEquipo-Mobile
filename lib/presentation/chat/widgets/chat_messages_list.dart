import 'package:flutter/material.dart';
import 'package:jugaenequipo/presentation/chat/business_logic/chat_provider.dart';
import 'package:jugaenequipo/presentation/chat/widgets/widgets.dart';
import 'package:provider/provider.dart';

class ChatMessagesList extends StatefulWidget {
  const ChatMessagesList({super.key});

  @override
  State<ChatMessagesList> createState() => _ChatMessagesListState();
}

class _ChatMessagesListState extends State<ChatMessagesList> {
  final ScrollController _scrollController = ScrollController();
  ChatProvider? _provider;

  @override
  void initState() {
    super.initState();
    // Initial scroll after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newProvider = context.read<ChatProvider>();
    if (!identical(newProvider, _provider)) {
      _provider?.removeListener(_onProviderChange);
      _provider = newProvider;
      _provider?.addListener(_onProviderChange);
    }
  }

  @override
  void dispose() {
    _provider?.removeListener(_onProviderChange);
    _scrollController.dispose();
    super.dispose();
  }

  void _onProviderChange() {
    // Scroll after UI updates
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position.maxScrollExtent;
    _scrollController.animateTo(
      position,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);

    return SingleChildScrollView(
      controller: _scrollController,
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
                const EdgeInsets.only(left: 16, right: 16, top: 5, bottom: 5),
            child: Align(
              alignment: (chatProvider.messages[index].messageType == "receiver"
                  ? Alignment.topLeft
                  : Alignment.topRight),
              child: ChatMessage(
                type: chatProvider.messages[index].messageType,
                text: chatProvider.messages[index].messageContent,
                timeLabel: _formatTime(chatProvider.messages[index].createdAt),
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatTime(String? isoString) {
    if (isoString == null || isoString.isEmpty) return '';
    final dt = DateTime.tryParse(isoString);
    if (dt == null) return '';
    final two = (int n) => n.toString().padLeft(2, '0');
    return '${two(dt.hour)}:${two(dt.minute)}';
  }
}
