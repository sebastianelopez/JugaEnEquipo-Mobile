import 'package:flutter/foundation.dart';
import 'package:jugaenequipo/datasources/models/models.dart';

class TeamProfileProvider extends ChangeNotifier {
  final String teamId;

  TeamProfileModel? teamProfile;
  bool isLoading = true;
  String? error;

  TeamProfileProvider({
    required this.teamId,
  }) {
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      // TODO: Implementar llamada a API para obtener perfil del team
      // Por ahora usamos datos mock
      await _loadMockData();
    } catch (e) {
      error = 'Error: ${e.toString()}';
      debugPrint('Error loading team profile: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadMockData() async {
    // Simular delay de API
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Crear datos mock para el team
    teamProfile = TeamProfileModel(
      id: teamId,
      name: 'Team Mock',
      membersIds: ['1', '2', '3'],
      game: GameModel(
        id: '1',
        name: 'Valorant',
        image: 'assets/game_image.jpg',
      ),
      verified: true,
      members: [
        UserModel(
          id: '1',
          firstName: 'John',
          lastName: 'Doe',
          userName: 'johndoe',
          email: 'john@example.com',
          profileImage: 'assets/user_image.jpg',
        ),
        UserModel(
          id: '2',
          firstName: 'Jane',
          lastName: 'Smith',
          userName: 'janesmith',
          email: 'jane@example.com',
          profileImage: 'assets/user_image.jpg',
        ),
        UserModel(
          id: '3',
          firstName: 'Bob',
          lastName: 'Johnson',
          userName: 'bobjohnson',
          email: 'bob@example.com',
          profileImage: 'assets/user_image.jpg',
        ),
      ],
      totalTournaments: 15,
      totalWins: 8,
      description: 'Un equipo competitivo de Valorant con experiencia en torneos regionales.',
      createdAt: DateTime.now().subtract(const Duration(days: 180)),
    );
  }

  // Method to refresh data
  Future<void> refreshData() async {
    isLoading = true;
    notifyListeners();
    await _loadData();
  }
}
