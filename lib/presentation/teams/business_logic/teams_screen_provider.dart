import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:jugaenequipo/datasources/post_use_cases/get_feed_by_user_use_case.dart';
import 'package:jugaenequipo/providers/providers.dart';
import 'package:provider/provider.dart';

class TeamsScreenProvider extends ChangeNotifier {
  final ScrollController scrollController = ScrollController();
  BuildContext context;
  late UserModel? user;
  var initialTeams = <TeamModel>[];

  TeamsScreenProvider({required this.context}) {
    user = Provider.of<UserProvider>(context, listen: false).user;
    //initData();
  }

  bool isLoading = false;

  List<TeamModel> teams = [
    TeamModel(
        id: '1',
        name: 'Kru ESports',
        membersIds: ["1", "2", "3"],
        game: GameModel(
          id: '1',
          name: 'Game 1',
          image: 'https://picsum.photos/80/80',
        ),
        teamImage:
            'https://www.kruesports.gg/assets/img/teams/teams/July2022/wXk2hPFVHNav2r910xWY.png',
        verified: true),
    TeamModel(
        id: '2',
        name: 'Cloud 9',
        membersIds: ["1", "2", "3", "5", "7"],
        game: GameModel(
          id: '2',
          name: 'Game 2',
          image: 'https://picsum.photos/80/80',
        ),
        teamImage:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTDvpcooEBU2rWLN9YS4z_VSqcHLxPV8HQIqA&s',
        verified: true),
    TeamModel(
        id: '3',
        name: 'Furia',
        membersIds: ["1", "2", "3", "4"],
        game: GameModel(
          id: '3',
          name: 'Game 3',
          image: 'https://picsum.photos/80/80',
        ),
        teamImage:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRyvyyAZmtUF1lwLae-NxWrMJi7k4ohptUTNw&s',
        verified: true),
    TeamModel(
        id: '4',
        name: 'Team 4',
        membersIds: ["1", "2", "3"],
        game: GameModel(
          id: '4',
          name: 'Game 4',
          image: 'https://picsum.photos/80/80',
        ),
        teamImage: 'https://picsum.photos/80/80',
        verified: false),
    TeamModel(
        id: '5',
        name: 'Team 5',
        membersIds: ["1", "2", "3"],
        game: GameModel(
          id: '5',
          name: 'Game 5',
          image: 'https://picsum.photos/80/80',
        ),
        teamImage: 'https://picsum.photos/80/80',
        verified: false),
    TeamModel(
        id: '6',
        name: 'Team 6',
        membersIds: ["1", "2", "3"],
        game: GameModel(
          id: '6',
          name: 'Game 6',
          image: 'https://picsum.photos/80/80',
        ),
        teamImage: 'https://picsum.photos/80/80',
        verified: false),
    TeamModel(
        id: '7',
        name: 'Team 7',
        membersIds: ["1", "2", "3"],
        game: GameModel(
          id: '7',
          name: 'Game 7',
          image: 'https://picsum.photos/80/80',
        ),
        teamImage: 'https://picsum.photos/80/80',
        verified: false),
    TeamModel(
        id: '8',
        name: 'Team 8',
        membersIds: ["1", "2", "3"],
        game: GameModel(
          id: '7',
          name: 'Game 7',
          image: 'https://picsum.photos/80/80',
        ),
        teamImage: 'https://picsum.photos/80/80',
        verified: false),
  ];

  Future<void> initData() async {
    // fetchData();
    if (teams.isNotEmpty) {
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
    // await fetchData();
  }

  Future fetchData() async {
    if (isLoading) return;

    isLoading = true;
    notifyListeners();
    try {
      if (user == null) return;
      final fetchedTeams = await getFeedByUserId();
      if (fetchedTeams != null) {
        // teams = fetchedTeams;
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

    if (scrollController.position.pixels + 100 <=
        scrollController.position.maxScrollExtent) {
      return;
    }
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
