import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:jugaenequipo/datasources/post_use_cases/delete_post_use_case.dart';
import 'package:jugaenequipo/datasources/post_use_cases/get_feed_by_user_use_case.dart';
import 'package:jugaenequipo/presentation/home/widgets/widgets.dart';
import 'package:jugaenequipo/providers/providers.dart';
import 'package:provider/provider.dart';

class HomeScreenProvider extends ChangeNotifier {
  final ScrollController scrollController = ScrollController();
  BuildContext context;
  late UserModel? user;
  var posts = <PostModel>[];

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  HomeScreenProvider({required this.context}) {
    user = Provider.of<UserProvider>(context, listen: false).user;
    initData();
  }
  late FocusNode focusNode;

  bool isLoading = false;
  bool _hasFocus = false;

  bool get hasFocus => _hasFocus;

  void setFocus(bool hasFocus) {
    _hasFocus = hasFocus;
    notifyListeners();
  }

  Future<void> initData() async {
    fetchData();
    if (posts.isNotEmpty) {
      scrollController.addListener(() {
        if ((scrollController.position.pixels + 500) >=
            scrollController.position.maxScrollExtent) {
          fetchData();
        }
      });
    }

    notifyListeners();
  }

  Future<void> onRefresh() async {
    await fetchData();
  }

  Future fetchData() async {
    if (isLoading) return;

    isLoading = true;
    notifyListeners();
    try {
      if (user == null) {
        debugPrint('User is null');
        return;
      }
      final fetchedPosts = await getFeedByUserId();
      if (fetchedPosts != null) {
        posts = fetchedPosts
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching posts: $e');
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }

    add5();

    isLoading = false;

    // Only handle scroll animation if controller is attached
    if (scrollController.hasClients) {
      _handleScrollAnimation();
    }
  }

  void add5() {
    /* final lastId = imageIds.last;

    imageIds.addAll([1, 2, 3, 4, 5].map((e) => lastId + e));
    setState(() {}); */
  }

  void _handleScrollAnimation() {
    if (!scrollController.hasClients) return;

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

  Future<dynamic> openCommentsModal(BuildContext context,
      {bool? autofocus = false, required String postId}) {
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
            ),
          ),
        );
      },
    );
  }
}
