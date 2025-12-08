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
  bool isLoadingMore = false;
  bool hasMoreData = true;
  String? error;
  List<TournamentModel> tournaments = [];

  static const int _pageSize = 10;
  int _currentOffset = 0;

  Future<void> initData() async {
    scrollController.addListener(_scrollListener);
    await fetchData(isRefresh: true);
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
      if (kDebugMode) {
        debugPrint(
            'TournamentsProvider: Starting to fetch tournaments... (offset: $_currentOffset, limit: $_pageSize)');
      }

      final tournamentsResult = await searchTournaments(
        limit: _pageSize,
        offset: _currentOffset,
      );

      if (kDebugMode) {
        debugPrint(
            'TournamentsProvider: searchTournaments returned: ${tournamentsResult != null ? "${tournamentsResult.length} tournaments" : "null"}');
      }

      if (tournamentsResult != null) {
        if (isRefresh) {
          tournaments = tournamentsResult;
        } else {
          tournaments.addAll(tournamentsResult);
        }

        // Si recibimos menos torneos que el límite, no hay más datos
        if (tournamentsResult.length < _pageSize) {
          hasMoreData = false;
        } else {
          _currentOffset += tournamentsResult.length;
        }

        error = null;

        if (kDebugMode) {
          debugPrint(
              'TournamentsProvider: Successfully loaded ${tournaments.length} total tournaments');
        }
      } else {
        // Si retorna null, hubo un error en la llamada
        if (isRefresh) {
          tournaments = [];
        }
        error = 'No se pudieron cargar los torneos';
        if (!isRefresh) {
          hasMoreData = false;
        }
        if (kDebugMode) {
          debugPrint(
              'TournamentsProvider: searchTournaments returned null - error occurred');
        }
      }
    } catch (e, stackTrace) {
      error = 'Error al cargar torneos: ${e.toString()}';
      if (isRefresh) {
        tournaments = [];
      }
      if (!isRefresh) {
        hasMoreData = false;
      }
      if (kDebugMode) {
        debugPrint('TournamentsProvider: Error loading tournaments: $e');
        debugPrint('Stack trace: $stackTrace');
      }
    } finally {
      isLoading = false;
      isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreTournaments() async {
    if (!hasMoreData || isLoadingMore || isLoading) return;
    await fetchData(isRefresh: false);
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
      loadMoreTournaments();
    }
  }
}
