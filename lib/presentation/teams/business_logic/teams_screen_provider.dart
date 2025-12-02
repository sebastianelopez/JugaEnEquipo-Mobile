import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:jugaenequipo/datasources/teams_use_cases/get_initial_teams_user_use_case.dart';
import 'package:jugaenequipo/providers/providers.dart';
import 'package:provider/provider.dart';

class TeamsScreenProvider extends ChangeNotifier {
  final ScrollController scrollController = ScrollController();
  BuildContext context;
  late UserModel? user;

  TeamsScreenProvider({required this.context}) {
    user = Provider.of<UserProvider>(context, listen: false).user;
    initData();
  }

  bool isLoading = false;
  String? error;
  List<TeamModel> teams = [];

  Future<void> initData() async {
    await fetchData();

    scrollController.addListener(() {
      if (scrollController.hasClients &&
          (scrollController.position.pixels + 500) >=
              scrollController.position.maxScrollExtent) {
        fetchData();
      }
    });

    notifyListeners();
  }

  Future<void> onRefresh() async {
    await fetchData();
  }

  Future<void> fetchData() async {
    if (isLoading) return;

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final fetchedTeams = await getInitialTeams();

      if (fetchedTeams != null) {
        teams = fetchedTeams;
        error = null;
      } else {
        error = 'No se pudieron cargar los equipos';
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching teams: $e');
      }
      error = 'Error al cargar equipos: ${e.toString()}';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
