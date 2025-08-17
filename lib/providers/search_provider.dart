import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:jugaenequipo/datasources/user_use_cases/get_users_by_username_use_case.dart';

class SearchProvider with ChangeNotifier {
  final Duration debounceDuration;

  SearchProvider({this.debounceDuration = const Duration(milliseconds: 400)});

  final List<UserModel> _suggestions = <UserModel>[];
  bool _isLoading = false;
  Timer? _debounce;

  List<UserModel> get suggestions => List.unmodifiable(_suggestions);
  bool get isLoading => _isLoading;

  void onQueryChanged(String rawQuery) {
    final String query = rawQuery.trim();
    _debounce?.cancel();

    if (query.isEmpty) {
      _clearInternal();
      notifyListeners();
      return;
    }

    _debounce = Timer(debounceDuration, () async {
      try {
        _isLoading = true;
        notifyListeners();

        final List<UserModel>? users = await getUsersByUsername(query);
        _suggestions
          ..clear()
          ..addAll(users ?? <UserModel>[]);
      } catch (e) {
        if (kDebugMode) {
          debugPrint('SearchProvider - error fetching users: $e');
        }
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    });
  }

  void clearResults() {
    _clearInternal();
    notifyListeners();
  }

  void _clearInternal() {
    _isLoading = false;
    _suggestions.clear();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
