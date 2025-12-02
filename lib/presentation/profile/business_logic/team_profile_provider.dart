import 'package:flutter/foundation.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:jugaenequipo/datasources/teams_use_cases/get_team_by_id_use_case.dart';
import 'package:jugaenequipo/datasources/teams_use_cases/get_team_members_use_case.dart';

class TeamProfileProvider extends ChangeNotifier {
  final String teamId;
  final TeamModel? team; // Optional team data if already available

  TeamProfileModel? teamProfile;
  bool isLoading = true;
  String? error;

  TeamProfileProvider({
    required this.teamId,
    this.team,
  }) {
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      // If we already have team data, use it; otherwise fetch from API
      TeamModel? teamData = team;

      if (teamData == null) {
        teamData = await getTeamById(teamId);
      }

      if (teamData == null) {
        error = 'No se pudo cargar el equipo';
        isLoading = false;
        notifyListeners();
        return;
      }

      // Load team members from API
      if (kDebugMode) {
        debugPrint('TeamProfileProvider: Loading members for teamId: $teamId');
      }

      List<UserModel> members = [];
      try {
        final membersResult = await getTeamMembers(teamId);

        if (kDebugMode) {
          debugPrint(
              'TeamProfileProvider: getTeamMembers returned: ${membersResult != null ? membersResult.length : "null"} members');
          if (membersResult != null) {
            debugPrint(
                'TeamProfileProvider: Members list: ${membersResult.map((m) => m.userName).toList()}');
            if (membersResult.isNotEmpty) {
              debugPrint(
                  'TeamProfileProvider: First member: ${membersResult.first.userName}, id: ${membersResult.first.id}');
            } else {
              debugPrint('TeamProfileProvider: Members list is empty!');
            }
          } else {
            debugPrint(
                'TeamProfileProvider: Members is null - API call may have failed');
          }
        }

        members = membersResult ?? [];
      } catch (e) {
        if (kDebugMode) {
          debugPrint('TeamProfileProvider: Exception loading members: $e');
        }
        // Continue with empty members list if loading fails
        members = [];
      }

      // Convert TeamModel to TeamProfileModel
      teamProfile = TeamProfileModel(
        id: teamData.id,
        name: teamData.name,
        description: teamData.description,
        image: teamData.image,
        creatorId: teamData.creatorId,
        leaderId: teamData.leaderId,
        createdAt: teamData.createdAt,
        updatedAt: teamData.updatedAt,
        deletedAt: teamData.deletedAt,
        games: teamData.games,
        membersIds: teamData.membersIds,
        verified: teamData.verified,
        members: members,
        totalTournaments: 0, // TODO: Load from API when endpoint is available
        totalWins: 0, // TODO: Load from API when endpoint is available
      );

      if (kDebugMode) {
        debugPrint(
            'TeamProfileProvider: TeamProfile created with ${teamProfile!.members.length} members');
        debugPrint(
            'TeamProfileProvider: TeamProfile members IDs: ${teamProfile!.members.map((m) => m.id).toList()}');
      }

      error = null;
    } catch (e) {
      error = 'Error: ${e.toString()}';
      debugPrint('Error loading team profile: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Method to refresh data
  Future<void> refreshData() async {
    isLoading = true;
    notifyListeners();
    await _loadData();
  }
}
