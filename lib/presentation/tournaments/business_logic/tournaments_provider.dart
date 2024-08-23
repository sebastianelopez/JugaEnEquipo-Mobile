import 'package:flutter/material.dart';
import 'package:jugaenequipo/models/models.dart';

class TournamentsProvider extends ChangeNotifier {
  final ScrollController scrollController = ScrollController();

  TournamentsProvider() {
    initData();
  }

  bool isLoading = false;

  List<Tournament> tournamentsMocks = [
    Tournament(
      title: 'Overwatch deathmatch',
      game: Game(name: 'Overwatch', image: ''),
      isOfficial: true,
      registeredPlayers: [
        User(
            id: "asda54498",
            firstName: "Carlos",
            lastName: "Sanchez",
            userName: "Cahez",
            email: "",
            profileImage: "",
            team: Team(name: "KruSports", members: [])),
        User(
          id: "asda54498",
          firstName: "Pepe",
          lastName: "Perez",
          userName: "repez",
          email: "",
          profileImage: "",
        )
      ],
    ),
    Tournament(
      title: 'CS PVP',
      game: Game(name: 'Counter Strike', image: ''),
      isOfficial: true,
      registeredPlayers: [
        User(
            id: "asda54498",
            firstName: "Carlos",
            lastName: "Sanchez",
            userName: "Cahez",
            email: "",
            profileImage: "",
            team: Team(name: "KruSports", members: [])),
        User(
          id: "asda54498",
          firstName: "Pepe",
          lastName: "Perez",
          userName: "repez",
          email: "",
          profileImage: "",
        ),
        User(
            id: "asda54498",
            firstName: "Carlos",
            lastName: "Sanchez",
            userName: "Cahez",
            email: "",
            profileImage: "",
            team: Team(name: "KruSports", members: [])),
        User(
          id: "asda54498",
          firstName: "Pepe",
          lastName: "Perez",
          userName: "repez",
          email: "",
          profileImage: "",
        )
      ],
    )
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
