import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:jugaenequipo/datasources/notifications_use_cases/get_notifications_use_case.dart';
import 'package:jugaenequipo/datasources/notifications_use_cases/mark_notification_as_read_use_case.dart';
import 'package:jugaenequipo/datasources/notifications_use_cases/notifications_sse_service.dart';

class NotificationsProvider extends ChangeNotifier {
  final List<NotificationModel> _notifications = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _offset = 0;
  final int _pageSize = 20;
  String? _errorMessage;
  bool _isInitialized = false;

  final NotificationsSSEService _sseService = NotificationsSSEService();
  StreamSubscription<NotificationModel>? _sseSubscription;
  final ScrollController scrollController = ScrollController();

  List<NotificationModel> get notifications =>
      List.unmodifiable(_notifications);

  // Get filtered notifications excluding "new_message" type
  List<NotificationModel> get filteredNotifications => List.unmodifiable(
      _notifications.where((n) => n.type != 'new_message').toList());

  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  String? get errorMessage => _errorMessage;
  bool get isInitialized => _isInitialized;

  // Get count of unread notifications (excluding "new_message" type)
  int get unreadCount => _notifications
      .where((n) => !n.isNotificationRead && n.type != 'new_message')
      .length;

  // Get count of unread message notifications
  int get unreadMessagesCount => _notifications
      .where((n) => !n.isNotificationRead && n.type == 'new_message')
      .length;

  Future<void> initialize() async {
    if (_isInitialized) return;

    // Setup scroll listener for infinite scroll
    scrollController.addListener(_onScroll);

    _isInitialized = true;

    // Only load notifications and subscribe if user is authenticated
    // This will be checked in the use cases
    if (_notifications.isEmpty) {
      await refresh();
    }
    _subscribeSSE();
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent * 0.8) {
      loadMore();
    }
  }

  Future<void> refresh() async {
    _offset = 0;
    _hasMore = true;
    _errorMessage = null;
    _notifications.clear();
    notifyListeners();
    await loadMore();
  }

  Future<void> loadMore() async {
    if (_isLoading || !_hasMore) return;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final result = await getNotifications(limit: _pageSize, offset: _offset);
      if (result != null) {
        _notifications.addAll(result);
        _offset += result.length;
        _hasMore = result.length >= _pageSize;
      } else {
        _hasMore = false;
      }
    } catch (e) {
      _errorMessage = 'Error loading notifications';
      if (_notifications.isEmpty) {
        // Only show error if we have no notifications
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> markAsRead(String notificationId) async {
    final idx = _notifications.indexWhere((n) => n.id == notificationId);
    if (idx != -1 && _notifications[idx].isNotificationRead == false) {
      _notifications[idx] = _notifications[idx].copyWith(
        isNotificationRead: true,
      );
      notifyListeners();
    }
    final ok = await markNotificationAsRead(notificationId);
    if (!ok && idx != -1) {
      // rollback
      _notifications[idx] = _notifications[idx].copyWith(
        isNotificationRead: false,
      );
      notifyListeners();
    }
  }

  /// Mark all message notifications as read
  Future<void> markAllMessagesAsRead() async {
    final messageNotifications = _notifications
        .where((n) => n.type == 'new_message' && !n.isNotificationRead)
        .toList();

    for (final notification in messageNotifications) {
      await markAsRead(notification.id);
    }
  }

  void _subscribeSSE() {
    _sseSubscription?.cancel();
    _sseSubscription = _sseService.connect().listen((incoming) {
      // Avoid duplicates by id if provided
      if (incoming.id.isNotEmpty &&
          _notifications.any((n) => n.id == incoming.id)) {
        return;
      }
      // Add all notifications, including "new_message" type
      // They are filtered when displaying but kept for counting
      _notifications.insert(0, incoming);
      notifyListeners();
    }, onError: (error) {
      // Log error for debugging
      if (kDebugMode) {
        debugPrint('NotificationsSSE subscription error: $error');
      }
      // Try to reconnect after a delay
      Future.delayed(const Duration(seconds: 5), () {
        if (_isInitialized) {
          _subscribeSSE();
        }
      });
    }, onDone: () {
      // Stream closed, try to reconnect
      if (kDebugMode) {
        debugPrint('NotificationsSSE stream closed, reconnecting...');
      }
      Future.delayed(const Duration(seconds: 2), () {
        if (_isInitialized) {
          _subscribeSSE();
        }
      });
    });
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    _sseSubscription?.cancel();
    _sseService.disconnect();
    super.dispose();
  }
}
