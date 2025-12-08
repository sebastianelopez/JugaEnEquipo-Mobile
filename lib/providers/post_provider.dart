import 'package:flutter/foundation.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:jugaenequipo/datasources/post_use_cases/add_post_comment_use_case.dart';
import 'package:jugaenequipo/datasources/post_use_cases/get_post_comments_use_case.dart';
import 'package:uuid/uuid.dart';

class PostProvider with ChangeNotifier {
  String? _postId;

  String? get postId => _postId;
  bool isLoading = false;
  var comments = <CommentModel>[];
  final Map<String, int> _commentsCountMap = {};

  PostProvider({String? postId}) {
    if (postId != null) {
      _postId = postId;
      fetchData(_postId!);
      debugPrint('PostProvider $_postId');
    }
  }

  void generatePostId() {
    _postId = const Uuid().v4();
    notifyListeners();
  }

  void clearPostId() {
    _postId = null;
    notifyListeners();
  }

  Future<bool> addComment(String postId, String comment) async {
    final success = await addPostComment(postId, comment);
    notifyListeners();
    return success;
  }

  void addOptimisticComment(CommentModel comment) {
    comments.add(comment);
    comments.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    notifyListeners();

    if (kDebugMode) {
      debugPrint(
          'PostProvider.addOptimisticComment - Added optimistic comment, now has ${comments.length} comments');
    }
  }

  void removeComment(CommentModel comment) {
    comments.remove(comment);
    notifyListeners();

    if (kDebugMode) {
      debugPrint(
          'PostProvider.removeComment - Removed comment, now has ${comments.length} comments');
    }
  }

  Future<void> getCommentsQuantity(String postId) async {
    try {
      if (postId.isNotEmpty) {
        final fetchedComments = await getPostComments(postId);
        _commentsCountMap[postId] = fetchedComments?.length ?? 0;
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching comment quantity: $e');
      }
    } finally {
      notifyListeners();
    }
  }

  int getCommentsCountForPost(String postId) {
    return _commentsCountMap[postId] ?? 0;
  }

  Future fetchData(String postId) async {
    if (isLoading) {
      if (kDebugMode) {
        debugPrint('PostProvider.fetchData - Already loading, skipping');
      }
      return;
    }

    if (kDebugMode) {
      debugPrint('PostProvider.fetchData - Starting for postId: $postId');
    }

    isLoading = true;
    notifyListeners();

    try {
      final fetchedComments = await getPostComments(postId);

      if (kDebugMode) {
        debugPrint(
            'PostProvider.fetchData - Fetched ${fetchedComments?.length ?? 0} comments');
      }

      if (fetchedComments != null) {
        comments = fetchedComments
          ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

        if (kDebugMode) {
          debugPrint(
              'PostProvider.fetchData - Updated comments list, now has ${comments.length} comments');
        }
        notifyListeners();
      } else {
        if (kDebugMode) {
          debugPrint('PostProvider.fetchData - fetchedComments is null');
        }
        comments = [];
        notifyListeners();
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('PostProvider.fetchData - Error fetching comments: $e');
        debugPrint('PostProvider.fetchData - Stack trace: $stackTrace');
      }
      comments = [];
    } finally {
      isLoading = false;
      notifyListeners();

      if (kDebugMode) {
        debugPrint('PostProvider.fetchData - Finished, isLoading: $isLoading');
      }
    }
  }
}
