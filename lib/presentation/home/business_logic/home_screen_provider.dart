import 'package:flutter/material.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:jugaenequipo/datasources/post_use_cases/get_posts_by_user_use_case.dart';
import 'package:jugaenequipo/presentation/home/widgets/widgets.dart';
import 'package:jugaenequipo/providers/providers.dart';
import 'package:provider/provider.dart';

class HomeScreenProvider extends ChangeNotifier {
  final ScrollController scrollController = ScrollController();
  BuildContext context;
  late UserModel? user;
  var posts = <PostModel>[];

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

  List<CommentModel> commentsMocks = [
    CommentModel(
        id: 'asd873738',
        userId: 'asdasdsadds',
        copy: "Excelente!",
        createdAt: "2024-05-04 15:00:04Z",
        updatedAt: "2024-05-04 15:00:04Z",
        deletedAt: ""),
    CommentModel(
        id: 'asd873738',
        userId: 'asdasdsadds',
        copy: "Merecidisimo!",
        createdAt: "2024-05-04 15:00:04Z",
        updatedAt: "2024-05-04 15:00:04Z",
        deletedAt: ""),
    CommentModel(
        id: 'asd873738',
        userId: '1502689a-5483-421a-b836-0d08b3ba2731',
        copy: "Gracias!",
        createdAt: "2024-05-04 15:00:04Z",
        updatedAt: "2024-05-04 15:00:04Z",
        deletedAt: ""),
    CommentModel(
        id: 'asd873738',
        userId: 'asdasdsadds',
        copy: "Excelente!",
        createdAt: "2024-05-04 15:00:04Z",
        updatedAt: "2024-05-04 15:00:04Z",
        deletedAt: ""),
    CommentModel(
        id: 'asd873738',
        userId: 'asdasdsadds',
        copy: "Merecidisimo!",
        createdAt: "2024-05-04 15:00:04Z",
        updatedAt: "2024-05-04 15:00:04Z",
        deletedAt: ""),
    CommentModel(
        id: 'asd873738',
        userId: 'asdasdsadds',
        copy: "Excelente!",
        createdAt: "2024-05-04 15:00:04Z",
        updatedAt: "2024-05-04 15:00:04Z",
        deletedAt: ""),
    CommentModel(
        id: 'asd873738',
        userId: 'asdasdsadds',
        copy: "Merecidisimo!",
        createdAt: "2024-05-04 15:00:04Z",
        updatedAt: "2024-05-04 15:00:04Z",
        deletedAt: ""),
    CommentModel(
        id: 'asd873738',
        userId: 'asdasdsadds',
        copy: "Excelente!",
        createdAt: "2024-05-04 15:00:04Z",
        updatedAt: "2024-05-04 15:00:04Z",
        deletedAt: ""),
    CommentModel(
        id: 'asd873738',
        userId: 'asdasdsadds',
        copy: "Merecidisimo!",
        createdAt: "2024-05-04 15:00:04Z",
        updatedAt: "2024-05-04 15:00:04Z",
        deletedAt: ""),
  ];

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
      if(user == null) return;
      final fetchedPosts =
          await getPostsByUserId(user!.id);
      if (fetchedPosts != null) {
        posts = fetchedPosts;
        notifyListeners();
      }
    } catch (e) {
      print('Error fetching posts: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }

    add5();

    isLoading = false;

    if (scrollController.position.pixels + 100 <=
        scrollController.position.maxScrollExtent) return;
    scrollController.animateTo(scrollController.position.pixels + 120,
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn);
  }

  void add5() {
    /* final lastId = imageIds.last;

    imageIds.addAll([1, 2, 3, 4, 5].map((e) => lastId + e));
    setState(() {}); */
  }

  Future<dynamic> openCommentsModal(BuildContext context,
      {bool? autofocus = false}) {
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
              autofocus: autofocus ?? false,
            ),
          ),
        );
      },
    );
  }
}
