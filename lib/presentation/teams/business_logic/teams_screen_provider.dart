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
  bool _mounted = true;

  TeamsScreenProvider({required this.context}) {
    user = Provider.of<UserProvider>(context, listen: false).user;
    initData();
  }

  @override
  void dispose() {
    _mounted = false;
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (!_mounted || !scrollController.hasClients) return;

    if ((scrollController.position.pixels + 500) >=
        scrollController.position.maxScrollExtent) {
      loadMoreTeams();
    }
  }

  @override
  void notifyListeners() {
    if (_mounted) {
      super.notifyListeners();
    }
  }

  bool isLoading = false;
  bool isLoadingMore = false;
  bool hasMoreData = true;
  String? error;
  List<TeamModel> teams = [];

  static const int _pageSize = 10;
  int _currentOffset = 0;

  Future<void> initData() async {
    scrollController.addListener(_scrollListener);
    await fetchData(isRefresh: true);
    notifyListeners();
  }

  Future<void> onRefresh() async {
    await fetchData(isRefresh: true);
  }

  Future<void> fetchData({bool isRefresh = false}) async {
    if (isLoading || isLoadingMore) return;

    if (isRefresh) {
      _currentOffset = 0;
      hasMoreData = true;
      isLoading = true;
    } else {
      isLoadingMore = true;
    }

    error = null;
    notifyListeners();

    try {
      final fetchedTeams = await getInitialTeams(
        limit: _pageSize,
        offset: _currentOffset,
      );

      if (fetchedTeams != null) {
        if (isRefresh) {
          teams = fetchedTeams;
        } else {
          teams.addAll(fetchedTeams);
        }

        // Si recibimos menos equipos que el límite, no hay más datos
        if (fetchedTeams.length < _pageSize) {
          hasMoreData = false;
        } else {
          _currentOffset += fetchedTeams.length;
        }

        error = null;
      } else {
        error = 'No se pudieron cargar los equipos';
        if (!isRefresh) {
          hasMoreData = false;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching teams: $e');
      }
      error = 'Error al cargar equipos: ${e.toString()}';
      if (!isRefresh) {
        hasMoreData = false;
      }
    } finally {
      isLoading = false;
      isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreTeams() async {
    if (!hasMoreData || isLoadingMore || isLoading) return;
    await fetchData(isRefresh: false);
  }
}
