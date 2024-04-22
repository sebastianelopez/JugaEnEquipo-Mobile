import 'package:flutter/material.dart';
import 'package:jugaenequipo/models/models.dart';

class HomeScreenProvider extends ChangeNotifier {
  final ScrollController scrollController = ScrollController();

  HomeScreenProvider() {
    initData();
  }

  bool isLoading = false;

  List<Post> postsmocks = [
    Post(
        user: User(
            name: "Carlos Sanchez",
            mail: "",
            profileImage: "",
            team: Team(name: "KruSports", members: [])),
        copy: "Acabo de llegar a diamond en Overwatch!",
        postDate: "2024-04-21 19:18:04Z",
        peopleWhoLikeIt: [
          User(
              name: "Carlos Sanchez",
              mail: "",
              profileImage: "",
              team: Team(name: "KruSports", members: [])),
          User(
            name: "Pepe Perez",
            mail: "",
            profileImage: "",
          )
        ],
        comments: []),
    Post(
        user: User(
          name: "Carlos Sanchez",
          mail: "",
          profileImage: "",
        ),
        copy: "Acabo de llegar a diamond en Overwatch!",
        postDate: "2024-04-20 20:18:04Z",
        peopleWhoLikeIt: [],
        comments: []),
    Post(
        user: User(
          name: "Carlos Sanchez",
          mail: "",
          profileImage: "",
        ),
        copy: "Acabo de llegar a diamond en Overwatch!",
        postDate: "2024-03-20 20:18:04Z",
        peopleWhoLikeIt: [],
        comments: []),
  ];

  Future<void> initData() async {
    isLoading = true;
    scrollController.addListener(() {
      if ((scrollController.position.pixels + 500) >=
          scrollController.position.maxScrollExtent) {
        fetchData();
      }
    });
    isLoading = false;
    notifyListeners();
  }

  Future<void> onRefresh() async {
    await Future.delayed(const Duration(seconds: 2));
    /* final lastId = imageIds.last;
    imageIds.clear();
    imageIds.add(lastId + 1); */
    // add5();
  }

  Future fetchData() async {
    if (isLoading) return;

    isLoading = true;
    /* setState(() {}); */

    await Future.delayed(const Duration(seconds: 3));

    add5();

    isLoading = false;
    /* setState(() {}); */

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
}
