import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:jugaenequipo/datasources/teams_use_cases/search_teams_use_case.dart';

class TeamSearchProvider with ChangeNotifier {
  final Duration debounceDuration;

  TeamSearchProvider(
      {this.debounceDuration = const Duration(milliseconds: 400)});

  final List<TeamModel> _suggestions = <TeamModel>[];
  bool _isLoading = false;
  String? _error;
  Timer? _debounce;

  List<TeamModel> get suggestions => List.unmodifiable(_suggestions);
  bool get isLoading => _isLoading;
  String? get error => _error;

  void onQueryChanged(String rawQuery) {
    final String query = rawQuery.trim();
    _debounce?.cancel();

    if (query.isEmpty) {
      _clearInternal();
      notifyListeners();
      return;
    }

    _debounce = Timer(debounceDuration, () async {
      try {
        _isLoading = true;
        _error = null;
        notifyListeners();

        // Call the API to search teams
        final teams = await searchTeams(name: query, limit: 3);

        if (teams != null) {
          // Filter teams by query (name or description)
          final filteredTeams = teams.where((team) {
            final nameMatch =
                team.name.toLowerCase().contains(query.toLowerCase());
            final descriptionMatch =
                team.description?.toLowerCase().contains(query.toLowerCase()) ??
                    false;
            final gameMatch = team.games.any((game) =>
                game.name.toLowerCase().contains(query.toLowerCase()));
            return nameMatch || descriptionMatch || gameMatch;
          }).toList();

          _suggestions
            ..clear()
            ..addAll(filteredTeams);
        } else {
          _suggestions.clear();
          _error = 'No se pudieron cargar los equipos';
        }
      } catch (e) {
        if (kDebugMode) {
          debugPrint('TeamSearchProvider - error fetching teams: $e');
        }
        _error = 'Error al buscar equipos: ${e.toString()}';
        _suggestions.clear();
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    });
  }

  void clearResults() {
    _clearInternal();
    notifyListeners();
  }

  void _clearInternal() {
    _isLoading = false;
    _error = null;
    _suggestions.clear();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
