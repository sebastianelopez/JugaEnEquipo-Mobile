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

  Future<void> addComment(String postId, String comment) async {
    await addPostComment(postId, comment);
    notifyListeners();
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
    if (isLoading) return;

    isLoading = true;
    notifyListeners();
    try {
      final fetchedComments = await getPostComments(postId);
      if (fetchedComments != null) {
        comments = fetchedComments
          ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching comments: $e');
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
