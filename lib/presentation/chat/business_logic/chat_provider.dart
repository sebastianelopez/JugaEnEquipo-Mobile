import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:jugaenequipo/datasources/chat_use_cases/chat_sse_service.dart';
import 'package:jugaenequipo/datasources/chat_use_cases/get_conversation_messages_use_case.dart';
import 'package:jugaenequipo/datasources/chat_use_cases/send_message_use_case.dart';
import 'package:uuid/uuid.dart';

class ChatProvider extends ChangeNotifier {
  final ChatSSEService _sseService = ChatSSEService();
  final List<ChatMessageModel> messages = [];
  String? _conversationId;
  String? _currentUsername;
  Stream<ChatMessageModel>? _inboundStream;
  StreamSubscription<ChatMessageModel>? _inboundSubscription;

  void dispose() {
    _inboundSubscription?.cancel();
    _sseService.disconnect();
    super.dispose();
  }

  void setCurrentUsername(String? username) {
    _currentUsername = username;
  }

  Future<void> loadConversation(String conversationId) async {
    _conversationId = conversationId;
    messages.clear();
    final history = await getConversationMessages(conversationId);
    for (final msg in history) {
      _normalizeOwnership(msg);
      messages.add(msg);
    }
    _sortMessagesAscending();
    notifyListeners();

    _subscribeSSE();
  }

  void _subscribeSSE() {
    if (_conversationId == null) return;
    _inboundSubscription?.cancel();
    _inboundStream = _sseService.connect(conversationId: _conversationId!);
    _inboundSubscription = _inboundStream!.listen((incoming) {
      _normalizeOwnership(incoming);
      // Prevent duplicates by id if available
      if (incoming.id != null && messages.any((m) => m.id == incoming.id)) {
        return;
      }

      // Replace optimistic message (temp-*) when server confirmation arrives
      if (incoming.mine == true) {
        final tempIndex = messages.lastIndexWhere(
          (m) =>
              (m.mine == true) &&
              (m.messageContent == incoming.messageContent) &&
              ((m.id ?? '').startsWith('temp-')),
        );
        if (tempIndex != -1) {
          messages[tempIndex] = incoming;
          _sortMessagesAscending();
          notifyListeners();
          return;
        }
      }

      messages.add(incoming);
      _sortMessagesAscending();
      notifyListeners();
    });
  }

  Future<void> send(String content) async {
    if (_conversationId == null || content.trim().isEmpty) return;
    final tempId = const Uuid().v4();
    final optimistic = ChatMessageModel(
      id: 'temp-$tempId',
      messageContent: content,
      messageType: 'sender',
      mine: true,
      createdAt: DateTime.now().toIso8601String(),
    );
    messages.add(optimistic);
    _sortMessagesAscending();
    notifyListeners();

    final ok = await sendMessage(
      conversationId: _conversationId!,
      messageId: tempId,
      content: content,
    );

    if (!ok) {
      messages.removeWhere((m) => m.id == optimistic.id);
      notifyListeners();
    }
    // Success path: real message will arrive via SSE and replace visually
  }

  void _sortMessagesAscending() {
    DateTime _parseDate(String? value) {
      return DateTime.tryParse(value ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0);
    }

    messages.sort((a, b) {
      final da = _parseDate(a.createdAt);
      final db = _parseDate(b.createdAt);
      final cmp = da.compareTo(db);
      if (cmp != 0) return cmp;
      // Tie-breaker by id to keep order stable when timestamps equal/missing
      return (a.id ?? '').compareTo(b.id ?? '');
    });
  }

  void _normalizeOwnership(ChatMessageModel message) {
    if (_currentUsername == null) return;
    final mine = (message.username ?? '').toLowerCase() ==
        _currentUsername!.toLowerCase();
    message.mine = mine;
    message.messageType = mine ? 'sender' : 'receiver';
  }
}
