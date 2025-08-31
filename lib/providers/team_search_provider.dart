import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:jugaenequipo/datasources/models/models.dart';

class TeamSearchProvider with ChangeNotifier {
  final Duration debounceDuration;

  TeamSearchProvider(
      {this.debounceDuration = const Duration(milliseconds: 400)});

  final List<TeamModel> _suggestions = <TeamModel>[];
  bool _isLoading = false;
  Timer? _debounce;

  List<TeamModel> get suggestions => List.unmodifiable(_suggestions);
  bool get isLoading => _isLoading;

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
        notifyListeners();

        // Mock data for teams - replace with actual API call later
        await Future.delayed(
            const Duration(milliseconds: 300)); // Simulate API delay

        final List<TeamModel> mockTeams = _getMockTeams(query);
        _suggestions
          ..clear()
          ..addAll(mockTeams);
      } catch (e) {
        if (kDebugMode) {
          debugPrint('TeamSearchProvider - error fetching teams: $e');
        }
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    });
  }

  List<TeamModel> _getMockTeams(String query) {
    // Mock teams data - replace with actual API call
    final List<TeamModel> allTeams = [
      TeamModel(
        id: '1',
        name: 'Team Alpha',
        membersIds: ['user1', 'user2', 'user3'],
        teamImage: null,
        games: [
          GameModel(id: '1', name: 'League of Legends', image: 'lol.png'),
          GameModel(id: '2', name: 'Valorant', image: 'valorant.png'),
        ],
        verified: true,
      ),
      TeamModel(
        id: '2',
        name: 'Beta Squad',
        membersIds: ['user4', 'user5'],
        teamImage: null,
        games: [
          GameModel(id: '3', name: 'CS:GO', image: 'csgo.png'),
        ],
        verified: false,
      ),
      TeamModel(
        id: '3',
        name: 'Gamma Gaming',
        membersIds: ['user6', 'user7', 'user8', 'user9'],
        teamImage: null,
        games: [
          GameModel(id: '4', name: 'Dota 2', image: 'dota2.png'),
          GameModel(id: '5', name: 'Overwatch', image: 'overwatch.png'),
        ],
        verified: true,
      ),
      TeamModel(
        id: '4',
        name: 'Delta Force',
        membersIds: ['user10', 'user11'],
        teamImage: null,
        games: [
          GameModel(id: '1', name: 'League of Legends', image: 'lol.png'),
        ],
        verified: false,
      ),
    ];

    // Filter teams based on query
    return allTeams
        .where((team) =>
            team.name.toLowerCase().contains(query.toLowerCase()) ||
            team.games.any((game) =>
                game.name.toLowerCase().contains(query.toLowerCase())))
        .toList();
  }

  void clearResults() {
    _clearInternal();
    notifyListeners();
  }

  void _clearInternal() {
    _isLoading = false;
    _suggestions.clear();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
