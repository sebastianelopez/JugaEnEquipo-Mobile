import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:jugaenequipo/datasources/tournaments_use_cases/search_tournaments_use_case.dart';

class TournamentsProvider extends ChangeNotifier {
  final ScrollController scrollController = ScrollController();
  bool _mounted = true;

  TournamentsProvider() {
    initData();
  }

  bool isLoading = false;
  String? error;
  List<TournamentModel> tournaments = [];

  Future<void> initData() async {
    scrollController.addListener(_scrollListener);

    await fetchData();
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
      if (kDebugMode) {
        debugPrint('TournamentsProvider: Starting to fetch tournaments...');
      }

      final tournamentsResult = await searchTournaments();

      if (kDebugMode) {
        debugPrint(
            'TournamentsProvider: searchTournaments returned: ${tournamentsResult != null ? "${tournamentsResult.length} tournaments" : "null"}');
      }

      if (tournamentsResult != null) {
        tournaments = tournamentsResult;
        error = null;

        if (kDebugMode) {
          debugPrint(
              'TournamentsProvider: Successfully loaded ${tournaments.length} tournaments');
        }
      } else {
        // Si retorna null, hubo un error en la llamada
        tournaments = [];
        error = 'No se pudieron cargar los torneos';
        if (kDebugMode) {
          debugPrint(
              'TournamentsProvider: searchTournaments returned null - error occurred');
        }
      }
    } catch (e, stackTrace) {
      error = 'Error al cargar torneos: ${e.toString()}';
      tournaments = [];
      if (kDebugMode) {
        debugPrint('TournamentsProvider: Error loading tournaments: $e');
        debugPrint('Stack trace: $stackTrace');
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
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

  void _scrollListener() {
    if (!_mounted || !scrollController.hasClients) return;

    if ((scrollController.position.pixels + 500) >=
        scrollController.position.maxScrollExtent) {
      fetchData();
    }
  }
}
