import 'package:flutter/foundation.dart';
import 'package:jugaenequipo/datasources/post_use_cases/get_popular_hashtags_use_case.dart';

class HashtagsListProvider extends ChangeNotifier {
  List<String> _hashtags = [];
  bool _isLoading = false;
  bool _mounted = true;

  List<String> get hashtags => _hashtags;
  bool get isLoading => _isLoading;

  @override
  void notifyListeners() {
    if (_mounted) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }

  Future<void> fetchHashtags() async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      final fetchedHashtags = await getPopularHashtags();
      if (fetchedHashtags != null) {
        _hashtags = fetchedHashtags;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching hashtags: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await fetchHashtags();
  }
}

