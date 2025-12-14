import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:jugaenequipo/datasources/post_use_cases/get_posts_by_hashtag_use_case.dart';
import 'package:jugaenequipo/datasources/post_use_cases/get_post_comments_use_case.dart';
import 'package:jugaenequipo/presentation/home/widgets/widgets.dart';

class HashtagPostsProvider extends ChangeNotifier {
  final String hashtag;
  final ScrollController scrollController = ScrollController();
  var posts = <PostModel>[];

  int _currentOffset = 0;
  final int _pageSize = 10;
  bool _hasMorePosts = true;
  bool _isLoadingMore = false;
  bool _mounted = true;

  final Set<String> _loadedPostIds = {};
  final Map<String, int> _commentsCountMap = {};
  final Set<String> _fetchedCommentCounts = {};

  bool isLoading = false;

  bool get isLoadingMore => _isLoadingMore;
  bool get hasMorePosts => _hasMorePosts;

  HashtagPostsProvider({required this.hashtag}) {
    initData();
  }

  @override
  void dispose() {
    _mounted = false;
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (_mounted) {
      super.notifyListeners();
    }
  }

  Future<void> initData() async {
    await fetchData(refresh: true);
    scrollController.addListener(_scrollListener);
    notifyListeners();
  }

  void _scrollListener() {
    if (!_mounted || !scrollController.hasClients) return;
    if (_isLoadingMore || !_hasMorePosts) return;

    final position = scrollController.position;
    if (!position.hasContentDimensions || position.maxScrollExtent <= 0) {
      return;
    }

    final distanceFromBottom = position.maxScrollExtent - position.pixels;
    if (distanceFromBottom <= 300) {
      _loadMorePosts();
    }
  }

  Future<void> onRefresh() async {
    await fetchData(refresh: true);
  }

  Future<void> fetchData({bool refresh = false}) async {
    if (isLoading) return;

    if (refresh) {
      _currentOffset = 0;
      _hasMorePosts = true;
      posts.clear();
      _loadedPostIds.clear();
      _fetchedCommentCounts.clear();
      _commentsCountMap.clear();
    }

    isLoading = true;
    notifyListeners();

    try {
      if (kDebugMode) {
        debugPrint('Fetching posts for hashtag: $hashtag with offset: $_currentOffset, limit: $_pageSize');
      }

      final fetchedPosts = await getPostsByHashtag(
        hashtag: hashtag,
        limit: _pageSize,
        offset: _currentOffset,
      );

      if (fetchedPosts != null && fetchedPosts.isNotEmpty) {
        final newPosts = fetchedPosts
            .where((post) => !_loadedPostIds.contains(post.id))
            .toList();

        _currentOffset += fetchedPosts.length;

        if (newPosts.isEmpty) {
          _hasMorePosts = false;
        } else {
          for (final post in newPosts) {
            _loadedPostIds.add(post.id);
          }

          if (fetchedPosts.length < _pageSize) {
            _hasMorePosts = false;
          }

          if (refresh) {
            posts = newPosts;
          } else {
            posts.addAll(newPosts);
          }

          posts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        }
      } else if (fetchedPosts != null && fetchedPosts.isEmpty) {
        _hasMorePosts = false;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching posts: $e');
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadMorePosts() async {
    if (_isLoadingMore || !_hasMorePosts) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final fetchedPosts = await getPostsByHashtag(
        hashtag: hashtag,
        limit: _pageSize,
        offset: _currentOffset,
      );

      if (fetchedPosts != null && fetchedPosts.isNotEmpty) {
        final newPosts = fetchedPosts
            .where((post) => !_loadedPostIds.contains(post.id))
            .toList();

        _currentOffset += fetchedPosts.length;

        if (newPosts.isEmpty) {
          _hasMorePosts = false;
        } else {
          for (final post in newPosts) {
            _loadedPostIds.add(post.id);
          }

          if (fetchedPosts.length < _pageSize) {
            _hasMorePosts = false;
          }

          posts.addAll(newPosts);
          posts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        }
      } else {
        _hasMorePosts = false;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error loading more posts: $e');
      }
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> getCommentsQuantity(String postId) async {
    try {
      if (postId.isEmpty) return;
      if (_fetchedCommentCounts.contains(postId)) {
        return;
      }

      _fetchedCommentCounts.add(postId);
      final fetchedComments = await getPostComments(postId);
      _commentsCountMap[postId] = fetchedComments?.length ?? 0;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching comment quantity: $e');
      }
      _fetchedCommentCounts.remove(postId);
    }
  }

  int getCommentsCountForPost(String postId) {
    return _commentsCountMap[postId] ?? 0;
  }

  Future<void> refreshCommentsQuantity(String postId) async {
    _fetchedCommentCounts.remove(postId);
    await getCommentsQuantity(postId);
  }

  Future<dynamic> openCommentsModal(BuildContext context,
      {bool? autofocus = false,
      required String postId,
      VoidCallback? onCommentAdded}) {
    return showModalBottomSheet(
      enableDrag: true,
      context: context,
      constraints: const BoxConstraints(
        maxWidth: 1200,
      ),
      isScrollControlled: true,
      useSafeArea: true,
      builder: (BuildContext modalContext) {
        return Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(modalContext).viewInsets.bottom),
          child: Comments(
            key: Key(postId),
            autofocus: autofocus ?? false,
            postId: postId,
            onCommentAdded: onCommentAdded,
          ),
        );
      },
    );
  }
}

