import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:jugaenequipo/datasources/chat_use_cases/chat_sse_service.dart';
import 'package:jugaenequipo/datasources/chat_use_cases/get_conversation_messages_use_case.dart';
import 'package:jugaenequipo/datasources/chat_use_cases/send_message_use_case.dart';
import 'package:jugaenequipo/datasources/chat_use_cases/mark_message_as_read_use_case.dart';
import 'package:uuid/uuid.dart';

class ChatProvider extends ChangeNotifier {
  final ChatSSEService _sseService = ChatSSEService();
  final List<ChatMessageModel> messages = [];
  String? _conversationId;
  String? _currentUsername;
  Stream<ChatMessageModel>? _inboundStream;
  StreamSubscription<ChatMessageModel>? _inboundSubscription;

  // Callback to notify when a message is sent (for updating conversations list)
  void Function({
    required String conversationId,
    required String messageText,
    required String messageDate,
  })? _onMessageSent;

  void setOnMessageSentCallback(
      void Function({
        required String conversationId,
        required String messageText,
        required String messageDate,
      }) callback) {
    _onMessageSent = callback;
  }

  void dispose() {
    closeConversation();
    super.dispose();
  }

  /// Close the conversation and disconnect SSE
  void closeConversation() {
    if (kDebugMode) {
      debugPrint('ChatProvider: Closing conversation and disconnecting SSE');
    }
    _inboundSubscription?.cancel();
    _inboundSubscription = null;
    _inboundStream = null;
    _sseService.disconnect();
    _conversationId = null;
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

    // Mark all unread messages as read when opening the conversation
    // (searchMessages automatically marks previous messages as read on backend,
    // but we ensure local state is updated)
    await _markAllUnreadMessagesAsRead();

    notifyListeners();

    _subscribeSSE();
  }

  Future<void> _markAllUnreadMessagesAsRead() async {
    final conversationId = _conversationId;
    if (conversationId == null) return;

    final unreadMessages = messages
        .where((msg) =>
            msg.mine == false &&
            msg.id != null &&
            (msg.isRead == null || msg.isRead == false))
        .toList();

    if (kDebugMode) {
      debugPrint('Marking ${unreadMessages.length} unread messages as read');
    }

    // Mark all unread messages as read
    for (final msg in unreadMessages) {
      final messageId = msg.id;
      if (messageId != null && _conversationId != null) {
        await markMessageAsRead(
          conversationId: _conversationId!,
          messageId: messageId,
        ).then((success) {
          if (success) {
            msg.isRead = true;
          }
        }).catchError((error) {
          if (kDebugMode) {
            debugPrint('Error marking message ${msg.id} as read: $error');
          }
        });
      }
    }
  }

  void _subscribeSSE() {
    if (_conversationId == null) return;
    final conversationId =
        _conversationId; // Store local copy to avoid null issues
    if (conversationId == null) return;

    _inboundSubscription?.cancel();
    _inboundStream = _sseService.connect(conversationId: conversationId);
    if (_inboundStream == null) return;

    _inboundSubscription = _inboundStream!.listen((incoming) {
      // Check if conversation is still active
      if (_conversationId == null) return;

      _normalizeOwnership(incoming);

      // Check if message already exists (by id) and update it if it does
      if (incoming.id != null) {
        final existingIndex = messages.indexWhere((m) => m.id == incoming.id);
        if (existingIndex != -1) {
          // Update existing message (e.g., when read status changes)
          messages[existingIndex] = incoming;
          _sortMessagesAscending();
          notifyListeners();
          return;
        }
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

          // Notify that a message was sent (for updating conversations list)
          final currentConversationId = _conversationId;
          if (currentConversationId != null) {
            _onMessageSent?.call(
              conversationId: currentConversationId,
              messageText: incoming.messageContent,
              messageDate:
                  incoming.createdAt ?? DateTime.now().toIso8601String(),
            );
          }
          return;
        }
      }

      messages.add(incoming);
      _sortMessagesAscending();
      notifyListeners();

      // Mark message as read if it's not from the current user and conversation is active
      final currentConversationId = _conversationId;
      if (incoming.mine == false &&
          incoming.id != null &&
          currentConversationId != null) {
        if (kDebugMode) {
          debugPrint('Marking incoming message ${incoming.id} as read');
        }
        markMessageAsRead(
          conversationId: currentConversationId,
          messageId: incoming.id!,
        ).then((success) {
          if (kDebugMode) {
            debugPrint('markMessageAsRead result for ${incoming.id}: $success');
          }
          if (success && incoming.id != null && _conversationId != null) {
            // Update local state to reflect that message is read
            final msgIndex = messages.indexWhere((m) => m.id == incoming.id);
            if (msgIndex != -1) {
              messages[msgIndex].isRead = true;
              if (kDebugMode) {
                debugPrint(
                    'Updated local state: message ${incoming.id} is now marked as read');
              }
              notifyListeners();
            }
          }
        }).catchError((error) {
          if (kDebugMode) {
            debugPrint('Error marking message as read: $error');
          }
        });
      }
    });
  }

  Future<void> send(String content) async {
    final conversationId = _conversationId;
    if (conversationId == null || content.trim().isEmpty) return;

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
      conversationId: conversationId,
      messageId: tempId,
      content: content,
    );

    if (!ok) {
      messages.removeWhere((m) => m.id == optimistic.id);
      notifyListeners();
    } else {
      // Notify immediately that a message was sent (optimistic update)
      // Check again if conversation is still active
      final currentConversationId = _conversationId;
      if (currentConversationId != null) {
        _onMessageSent?.call(
          conversationId: currentConversationId,
          messageText: content,
          messageDate: optimistic.createdAt ?? DateTime.now().toIso8601String(),
        );
      }
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
    final currentUsername = _currentUsername;
    if (currentUsername == null) return;
    final mine =
        (message.username ?? '').toLowerCase() == currentUsername.toLowerCase();
    message.mine = mine;
    message.messageType = mine ? 'sender' : 'receiver';
  }
}
