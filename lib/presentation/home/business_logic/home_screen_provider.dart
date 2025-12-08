import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:jugaenequipo/datasources/post_use_cases/delete_post_use_case.dart';
import 'package:jugaenequipo/datasources/post_use_cases/get_feed_by_user_use_case.dart';
import 'package:jugaenequipo/datasources/post_use_cases/get_post_comments_use_case.dart';
import 'package:jugaenequipo/presentation/home/widgets/widgets.dart';
import 'package:jugaenequipo/providers/providers.dart';
import 'package:provider/provider.dart';

class HomeScreenProvider extends ChangeNotifier {
  final ScrollController scrollController = ScrollController();
  BuildContext context;
  late UserModel? user;
  var posts = <PostModel>[];

  // Pagination variables
  int _currentOffset = 0;
  final int _pageSize = 10;
  bool _hasMorePosts = true;
  bool _isLoadingMore = false;
  bool _mounted = true;

  // Comments count management (shared across all posts)
  final Map<String, int> _commentsCountMap = {};

  // Track which posts have already fetched their comment count
  final Set<String> _fetchedCommentCounts = {};

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

  HomeScreenProvider({required this.context}) {
    user = Provider.of<UserProvider>(context, listen: false).user;
    initData();
  }
  late FocusNode focusNode;

  bool isLoading = false;
  bool _hasFocus = false;

  bool get hasFocus => _hasFocus;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMorePosts => _hasMorePosts;

  void setFocus(bool hasFocus) {
    _hasFocus = hasFocus;
    notifyListeners();
  }

  Future<void> initData() async {
    await fetchData(refresh: true);

    // Add scroll listener for pagination
    scrollController.addListener(_scrollListener);

    notifyListeners();
  }

  void _scrollListener() {
    if (!_mounted || !scrollController.hasClients) return;

    // Load more when user is 300px from the bottom
    if (!_isLoadingMore &&
        _hasMorePosts &&
        scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 300) {
      _loadMorePosts();
    }
  }

  Future<void> onRefresh() async {
    await fetchData(refresh: true);
  }

  Future fetchData({bool refresh = false}) async {
    if (isLoading) return;

    if (refresh) {
      _currentOffset = 0;
      _hasMorePosts = true;
      posts.clear();
      // Clear comment count cache on refresh
      _fetchedCommentCounts.clear();
      _commentsCountMap.clear();
    }

    isLoading = true;
    notifyListeners();

    try {
      if (user == null) {
        debugPrint('User is null');
        return;
      }

      if (kDebugMode) {
        debugPrint(
            'Fetching posts with offset: $_currentOffset, limit: $_pageSize');
      }

      final fetchedPosts = await getFeedByUserId(
        limit: _pageSize,
        offset: _currentOffset,
      );

      if (fetchedPosts != null) {
        if (fetchedPosts.length < _pageSize) {
          _hasMorePosts = false;
        }

        if (refresh) {
          posts = fetchedPosts;
        } else {
          posts.addAll(fetchedPosts);
        }

        posts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        _currentOffset += fetchedPosts.length;

        if (kDebugMode) {
          debugPrint(
              'Loaded ${fetchedPosts.length} posts. Total: ${posts.length}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching posts: $e');
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }

    // Only handle scroll animation if controller is attached and mounted
    if (_mounted && scrollController.hasClients && !refresh) {
      _handleScrollAnimation();
    }
  }

  Future<void> _loadMorePosts() async {
    if (_isLoadingMore || !_hasMorePosts) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      if (user == null) {
        debugPrint('User is null');
        return;
      }

      if (kDebugMode) {
        debugPrint('Loading more posts with offset: $_currentOffset');
      }

      final fetchedPosts = await getFeedByUserId(
        limit: _pageSize,
        offset: _currentOffset,
      );

      if (fetchedPosts != null) {
        if (fetchedPosts.length < _pageSize) {
          _hasMorePosts = false;
        }

        posts.addAll(fetchedPosts);
        posts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        _currentOffset += fetchedPosts.length;

        if (kDebugMode) {
          debugPrint(
              'Loaded ${fetchedPosts.length} more posts. Total: ${posts.length}');
        }
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

  void add5() {
    /* final lastId = imageIds.last;

    imageIds.addAll([1, 2, 3, 4, 5].map((e) => lastId + e));
    setState(() {}); */
  }

  void _handleScrollAnimation() {
    if (!_mounted || !scrollController.hasClients) return;

    final position = scrollController.position;
    if (position.pixels + 100 <= position.maxScrollExtent) return;

    scrollController.animateTo(scrollController.position.pixels + 120,
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn);
  }

  void _setPostHeight(String postId, double height) {
    final postIndex = posts.indexWhere((post) => post.id == postId);
    if (postIndex != -1) {
      posts[postIndex].height = height;
      notifyListeners();
    }
  }

  void addOptimisticPost(PostModel post) {
    // Add post at the beginning of the list (most recent first)
    posts.insert(0, post);
    notifyListeners();
  }

  void handlePostMenuOptionClick(Menu option, String postId) async {
    switch (option) {
      case Menu.delete:
        final postIndex = posts.indexWhere((post) => post.id == postId);
        if (postIndex != -1) {
          posts[postIndex].isVisible = false;
          notifyListeners();

          await Future.delayed(const Duration(milliseconds: 400));
          _setPostHeight(postId, 0);
          await deletePost(postId);
          posts.removeAt(postIndex);
          notifyListeners();
        }
        break;
    }
  }

  Future<void> getCommentsQuantity(String postId) async {
    try {
      if (postId.isEmpty) return;

      // Skip if we've already fetched comments for this post
      if (_fetchedCommentCounts.contains(postId)) {
        return;
      }

      // Mark as fetched to prevent duplicate requests
      _fetchedCommentCounts.add(postId);

      final fetchedComments = await getPostComments(postId);
      _commentsCountMap[postId] = fetchedComments?.length ?? 0;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching comment quantity: $e');
      }
      // Remove from fetched set on error to allow retry
      _fetchedCommentCounts.remove(postId);
    }
  }

  int getCommentsCountForPost(String postId) {
    return _commentsCountMap[postId] ?? 0;
  }

  // Force refresh comment count (used after adding a comment)
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
      builder: (BuildContext context) {
        return ChangeNotifierProvider(
          create: (context) => HomeScreenProvider(context: context),
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Comments(
              key: Key(postId),
              autofocus: autofocus ?? false,
              postId: postId,
              onCommentAdded: onCommentAdded,
            ),
          ),
        );
      },
    );
  }
}
