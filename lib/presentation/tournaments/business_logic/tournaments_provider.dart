import 'package:flutter/material.dart';
import 'package:jugaenequipo/datasources/models/models.dart';

class TournamentsProvider extends ChangeNotifier {
  final ScrollController scrollController = ScrollController();

  TournamentsProvider() {
    initData();
  }

  bool isLoading = false;

  List<TournamentModel> tournamentsMocks = [
    TournamentModel(
      id: "asdas353",
      title: 'Overwatch deathmatch',
      game: GameModel(name: 'Overwatch', image: ''),
      isOfficial: true,
      registeredPlayersIds: [
        "asda54498",
        "asda544998",
      ],
    ),
    TournamentModel(
      id: "asdas343",
      title: 'CS PVP',
      game: GameModel(name: 'Counter Strike', image: ''),
      isOfficial: true,
      registeredPlayersIds: [
        "asda4544968",
        "asdau54498",
        "asda5t4498",
        "asda54p498",
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
