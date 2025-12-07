import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:jugaenequipo/datasources/chat_use_cases/get_all_conversations_use_case.dart';
import 'package:jugaenequipo/datasources/models/chat/conversations_response_model.dart';
import 'package:jugaenequipo/datasources/notifications_use_cases/notifications_sse_service.dart';

class MessagesProvider extends ChangeNotifier {
  List<ConversationModel> conversations = [];
  ConversationsMetadata metadata = ConversationsMetadata(total: 0, totalUnreadMessages: 0);
  bool isLoading = false;
  String? errorMessage;
  
  final NotificationsSSEService _sseService = NotificationsSSEService();
  StreamSubscription<NotificationModel>? _sseSubscription;
  bool _isInitialized = false;
  
  // Callback to notify when unread count changes (for updating notifications)
  void Function()? _onUnreadCountChanged;

  MessagesProvider() {
    loadConversations();
    _subscribeToNotifications();
  }
  
  void setOnUnreadCountChangedCallback(void Function() callback) {
    _onUnreadCountChanged = callback;
  }

  void _subscribeToNotifications() {
    if (_isInitialized) return;
    _isInitialized = true;
    
    _sseSubscription?.cancel();
    _sseSubscription = _sseService.connect().listen((notification) {
      // Listen for new_message notifications to update conversations list
      if (notification.type == 'new_message') {
        if (kDebugMode) {
          debugPrint('MessagesProvider: Received new_message notification');
        }
        // Add a small delay to batch multiple notifications and avoid too many refreshes
        Future.delayed(const Duration(milliseconds: 300), () {
          if (_isInitialized) {
            silentRefreshConversations();
          }
        });
      }
    }, onError: (error) {
      if (kDebugMode) {
        debugPrint('MessagesProvider: SSE subscription error: $error');
      }
      // Try to reconnect after a delay
      Future.delayed(const Duration(seconds: 5), () {
        if (_isInitialized) {
          _subscribeToNotifications();
        }
      });
    }, onDone: () {
      if (kDebugMode) {
        debugPrint('MessagesProvider: SSE stream closed, reconnecting...');
      }
      Future.delayed(const Duration(seconds: 2), () {
        if (_isInitialized) {
          _subscribeToNotifications();
        }
      });
    });
  }

  Future<void> loadConversations() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await getAllConversations();
      // Save previous unread count before updating
      final previousUnreadCount = metadata.totalUnreadMessages;
      
      conversations = response.conversations;
      metadata = response.metadata;
      
      // Sort conversations by lastMessageDate (most recent first)
      _sortConversations();
      
      // Notify if unread count changed (for updating notifications badge)
      if (metadata.totalUnreadMessages != previousUnreadCount) {
        _onUnreadCountChanged?.call();
      }
      
      if (kDebugMode) {
        debugPrint('MessagesProvider: Loaded ${conversations.length} conversations');
        debugPrint('MessagesProvider: Metadata - total: ${metadata.total}, unread: ${metadata.totalUnreadMessages}');
      }
      if (conversations.isEmpty && errorMessage == null) {
        // No error occurred, just empty list
        errorMessage = null;
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('MessagesProvider error: $e');
        debugPrint('Stack trace: $stackTrace');
      }
      errorMessage = 'errorLoadingConversations';
      conversations = [];
      metadata = ConversationsMetadata(total: 0, totalUnreadMessages: 0);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshConversations() async {
    await loadConversations();
  }

  /// Silent refresh without showing loading state (for real-time updates)
  Future<void> silentRefreshConversations() async {
    try {
      final response = await getAllConversations();
      final oldConversations = List<ConversationModel>.from(conversations);
      // Save previous unread count before updating
      final previousUnreadCount = metadata.totalUnreadMessages;
      
      conversations = response.conversations;
      metadata = response.metadata;
      
      // Sort conversations by lastMessageDate (most recent first)
      _sortConversations();
      
      // Check if order changed to trigger animation
      final orderChanged = _hasOrderChanged(oldConversations, conversations);
      
      // Notify if unread count changed (for updating notifications badge)
      if (metadata.totalUnreadMessages != previousUnreadCount) {
        _onUnreadCountChanged?.call();
      }
      
      if (kDebugMode) {
        debugPrint('MessagesProvider: Silent refresh - ${conversations.length} conversations');
        debugPrint('MessagesProvider: Order changed: $orderChanged');
      }
      
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('MessagesProvider: Silent refresh error: $e');
      }
      // On error, do a full refresh (but only if we have no conversations)
      if (conversations.isEmpty) {
        refreshConversations();
      }
    }
  }

  /// Check if the order of conversations has changed
  bool _hasOrderChanged(List<ConversationModel> oldList, List<ConversationModel> newList) {
    if (oldList.length != newList.length) return true;
    for (int i = 0; i < oldList.length; i++) {
      if (oldList[i].id != newList[i].id) return true;
    }
    return false;
  }

  /// Update a specific conversation when a new message arrives
  void updateConversationOnNewMessage({
    required String conversationId,
    required String lastMessageText,
    required String lastMessageDate,
    int? unreadCount,
  }) {
    final index = conversations.indexWhere((c) => c.id == conversationId);
    if (index != -1) {
      // Update existing conversation
      final updated = ConversationModel(
        id: conversations[index].id,
        otherUserId: conversations[index].otherUserId,
        otherUsername: conversations[index].otherUsername,
        otherFirstname: conversations[index].otherFirstname,
        otherLastname: conversations[index].otherLastname,
        otherProfileImage: conversations[index].otherProfileImage,
        lastMessageText: lastMessageText,
        lastMessageDate: lastMessageDate,
        unreadCount: unreadCount ?? conversations[index].unreadCount,
      );
      conversations[index] = updated;
    } else {
      // New conversation, need to reload all
      refreshConversations();
      return;
    }
    
    // Re-sort conversations
    _sortConversations();
    notifyListeners();
  }

  void _sortConversations() {
    DateTime? _parseDate(String? dateString) {
      if (dateString == null || dateString.isEmpty) return null;
      try {
        // Try parsing ISO8601 format first
        return DateTime.tryParse(dateString);
      } catch (e) {
        // Try parsing "YYYY-MM-DD HH:mm:ss" format
        try {
          final dateTimeParts = dateString.split(' ');
          if (dateTimeParts.length == 2) {
            final dateParts = dateTimeParts[0].split('-');
            final timeParts = dateTimeParts[1].split(':');
            if (dateParts.length == 3 && timeParts.length == 3) {
              return DateTime(
                int.parse(dateParts[0]),
                int.parse(dateParts[1]),
                int.parse(dateParts[2]),
                int.parse(timeParts[0]),
                int.parse(timeParts[1]),
                int.parse(timeParts[2]),
              );
            }
          }
        } catch (_) {}
        return null;
      }
    }

    conversations.sort((a, b) {
      final dateA = _parseDate(a.lastMessageDate);
      final dateB = _parseDate(b.lastMessageDate);
      
      // If both have dates, sort by date (most recent first)
      if (dateA != null && dateB != null) {
        return dateB.compareTo(dateA); // Reverse order (newest first)
      }
      
      // If only one has a date, prioritize it
      if (dateA != null) return -1;
      if (dateB != null) return 1;
      
      // If neither has a date, maintain current order
      return 0;
    });
  }

  @override
  void dispose() {
    _sseSubscription?.cancel();
    _sseService.disconnect();
    _isInitialized = false;
    super.dispose();
  }
}
