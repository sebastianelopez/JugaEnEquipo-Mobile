import 'package:flutter/foundation.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:jugaenequipo/datasources/teams_use_cases/get_team_by_id_use_case.dart';
import 'package:jugaenequipo/datasources/teams_use_cases/get_team_members_use_case.dart';
import 'package:jugaenequipo/datasources/teams_use_cases/update_team_use_case.dart'
    as update_team;
import 'package:jugaenequipo/datasources/teams_use_cases/delete_team_use_case.dart'
    as delete_team;
import 'package:jugaenequipo/datasources/teams_use_cases/add_game_to_team_use_case.dart';
import 'package:jugaenequipo/datasources/teams_use_cases/remove_game_from_team_use_case.dart';
import 'package:jugaenequipo/datasources/teams_use_cases/update_team_leader_use_case.dart';
import 'package:jugaenequipo/datasources/teams_use_cases/request_team_access_use_case.dart';
import 'package:jugaenequipo/datasources/teams_use_cases/accept_team_request_use_case.dart';
import 'package:jugaenequipo/datasources/teams_use_cases/decline_team_request_use_case.dart';
import 'package:jugaenequipo/datasources/teams_use_cases/get_team_requests_use_case.dart';
import 'package:jugaenequipo/datasources/teams_use_cases/remove_user_from_team_use_case.dart';
import 'package:jugaenequipo/datasources/teams_use_cases/leave_team_use_case.dart'
    as leave_team;
import 'package:jugaenequipo/datasources/teams_use_cases/update_team_background_image_use_case.dart';
import 'package:jugaenequipo/datasources/teams_use_cases/get_team_background_image_use_case.dart';
import 'package:jugaenequipo/datasources/api_service.dart';
import 'dart:io';
import 'dart:convert';

enum TeamUserRole { creator, leader, member, none }

class TeamProfileProvider extends ChangeNotifier {
  final String teamId;
  final TeamModel? team; // Optional team data if already available
  final String? currentUserId; // Current logged in user ID

  TeamProfileModel? teamProfile;
  bool isLoading = true;
  String? error;
  List<TeamRequestModel> teamRequests = [];
  String? backgroundImageUrl;
  bool isLoadingRequests = false;
  bool isPerformingAction = false;
  bool _mounted = true;

  TeamProfileProvider({
    required this.teamId,
    this.team,
    this.currentUserId,
  }) {
    _loadData();
  }

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (_mounted) {
      super.notifyListeners();
    }
  }

  // Determine user role in the team
  TeamUserRole getUserRole() {
    if (teamProfile == null || currentUserId == null) {
      return TeamUserRole.none;
    }

    if (teamProfile!.creatorId == currentUserId) {
      return TeamUserRole.creator;
    } else if (teamProfile!.leaderId == currentUserId) {
      return TeamUserRole.leader;
    } else if (teamProfile!.members
        .any((member) => member.id == currentUserId)) {
      return TeamUserRole.member;
    }

    return TeamUserRole.none;
  }

  // Check if user can edit team
  bool canEditTeam() {
    final role = getUserRole();
    return role == TeamUserRole.creator || role == TeamUserRole.leader;
  }

  // Check if user can manage members
  bool canManageMembers() {
    final role = getUserRole();
    return role == TeamUserRole.creator || role == TeamUserRole.leader;
  }

  // Check if user can manage requests
  bool canManageRequests() {
    final role = getUserRole();
    return role == TeamUserRole.creator || role == TeamUserRole.leader;
  }

  // Check if user can delete team
  bool canDeleteTeam() {
    return getUserRole() == TeamUserRole.creator;
  }

  // Check if user is a member
  bool isMember() {
    return getUserRole() == TeamUserRole.member ||
        getUserRole() == TeamUserRole.leader ||
        getUserRole() == TeamUserRole.creator;
  }

  // Check if current user has a pending request
  bool hasPendingRequest() {
    if (currentUserId == null) {
      if (kDebugMode) {
        debugPrint('hasPendingRequest: currentUserId is null');
      }
      return false;
    }

    if (kDebugMode) {
      debugPrint(
          'hasPendingRequest: Checking requests for userId: $currentUserId');
      debugPrint('hasPendingRequest: Total requests: ${teamRequests.length}');
      for (var request in teamRequests) {
        debugPrint(
            'hasPendingRequest: Request userId: ${request.userId}, status: ${request.status}');
      }
    }

    // Compare IDs as strings, trimming whitespace just in case
    final hasPending = teamRequests.any((request) {
      final requestUserId = request.userId.trim();
      final currentId = currentUserId!.trim();
      final statusMatches = request.status.toLowerCase() == 'pending';
      final idMatches = requestUserId == currentId;
      final matches = idMatches && statusMatches;

      if (kDebugMode) {
        debugPrint(
            'hasPendingRequest: Comparing - requestUserId: "$requestUserId" vs currentId: "$currentId" (match: $idMatches)');
        debugPrint(
            'hasPendingRequest: Status: "${request.status}" (matches pending: $statusMatches)');
        if (idMatches) {
          debugPrint('hasPendingRequest: Found matching request ID!');
        }
      }

      return matches;
    });

    if (kDebugMode) {
      debugPrint('hasPendingRequest: Final Result: $hasPending');
    }

    return hasPending;
  }

  Future<void> _loadData() async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      // If we already have team data, use it; otherwise fetch from API
      TeamModel? teamData = team;

      teamData ??= await getTeamById(teamId);

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

      // Load background image always (same as user profile)
      _loadBackgroundImage();

      // Always load requests if user is not a member (to check if they already requested access)
      // Also load if user can manage requests (creator/leader)
      bool userIsMember = false;
      if (currentUserId != null) {
        userIsMember =
            teamProfile!.members.any((member) => member.id == currentUserId) ||
                teamProfile!.creatorId == currentUserId ||
                teamProfile!.leaderId == currentUserId;
      }

      if (kDebugMode) {
        debugPrint('_loadData: currentUserId = $currentUserId');
        debugPrint('_loadData: userIsMember = $userIsMember');
        debugPrint('_loadData: canManageRequests = ${canManageRequests()}');
      }

      // Load requests if user is not a member OR if user can manage requests
      if (!userIsMember || canManageRequests()) {
        if (kDebugMode) {
          debugPrint('_loadData: Loading team requests...');
        }
        _loadTeamRequests();
      } else {
        if (kDebugMode) {
          debugPrint(
              '_loadData: Skipping team requests load (user is member and cannot manage)');
        }
      }

      if (kDebugMode) {
        debugPrint(
            'TeamProfileProvider: TeamProfile created with ${teamProfile!.members.length} members');
        debugPrint(
            'TeamProfileProvider: TeamProfile members IDs: ${teamProfile!.members.map((m) => m.id).toList()}');
        debugPrint('TeamProfileProvider: User role: ${getUserRole()}');
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

  Future<void> _loadBackgroundImage() async {
    try {
      final url = await getTeamBackgroundImage(teamId);
      backgroundImageUrl = url;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error loading background image: $e');
      }
    }
  }

  Future<void> _loadTeamRequests() async {
    try {
      isLoadingRequests = true;
      notifyListeners();

      if (kDebugMode) {
        debugPrint('_loadTeamRequests: Loading requests for teamId: $teamId');
        debugPrint('_loadTeamRequests: currentUserId: $currentUserId');
      }

      final requests = await getTeamRequests(teamId);
      if (requests != null) {
        teamRequests = requests;
        if (kDebugMode) {
          debugPrint('_loadTeamRequests: Loaded ${requests.length} requests');
          for (var request in requests) {
            debugPrint(
                '_loadTeamRequests: Request - userId: ${request.userId}, status: ${request.status}');
          }
        }
      } else {
        if (kDebugMode) {
          debugPrint('_loadTeamRequests: No requests returned (null)');
        }
        teamRequests = [];
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error loading team requests: $e');
      }
      teamRequests = [];
    } finally {
      isLoadingRequests = false;
      notifyListeners();
    }
  }

  // Public method to reload requests (used after requesting access)
  Future<void> reloadRequests() async {
    await _loadTeamRequests();
  }

  // Method to refresh data
  Future<void> refreshData() async {
    isLoading = true;
    notifyListeners();
    await _loadData();
  }

  // Update team information
  Future<bool> updateTeam({
    String? name,
    String? description,
    String? image,
  }) async {
    if (!canEditTeam()) return false;

    try {
      isPerformingAction = true;
      notifyListeners();

      final updatedTeam = await update_team.updateTeam(
        teamId: teamId,
        name: name,
        description: description,
        image: image,
      );

      if (updatedTeam != null) {
        // Reload data to get updated team
        await refreshData();
        return true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error updating team: $e');
      }
      return false;
    } finally {
      isPerformingAction = false;
      notifyListeners();
    }
  }

  // Delete team
  Future<bool> deleteTeam() async {
    if (!canDeleteTeam()) return false;

    try {
      isPerformingAction = true;
      notifyListeners();

      final result = await delete_team.deleteTeam(teamId);
      return result == Result.success;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error deleting team: $e');
      }
      return false;
    } finally {
      isPerformingAction = false;
      notifyListeners();
    }
  }

  // Add game to team
  Future<bool> addGame(String gameId) async {
    if (!canEditTeam()) return false;

    try {
      isPerformingAction = true;
      notifyListeners();

      final result = await addGameToTeam(teamId, gameId);
      if (result == Result.success) {
        await refreshData();
        return true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error adding game: $e');
      }
      return false;
    } finally {
      isPerformingAction = false;
      notifyListeners();
    }
  }

  // Remove game from team
  Future<bool> removeGame(String gameId) async {
    if (!canEditTeam()) return false;

    try {
      isPerformingAction = true;
      notifyListeners();

      final result = await removeGameFromTeam(teamId, gameId);
      if (result == Result.success) {
        await refreshData();
        return true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error removing game: $e');
      }
      return false;
    } finally {
      isPerformingAction = false;
      notifyListeners();
    }
  }

  // Update team leader
  Future<bool> updateLeader(String userId) async {
    if (!canDeleteTeam()) return false; // Only creator can change leader

    try {
      isPerformingAction = true;
      notifyListeners();

      final result = await updateTeamLeader(teamId, userId);
      if (result == Result.success) {
        await refreshData();
        return true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error updating leader: $e');
      }
      return false;
    } finally {
      isPerformingAction = false;
      notifyListeners();
    }
  }

  // Request access to team
  Future<bool> requestAccess() async {
    if (isMember()) return false; // Already a member

    try {
      isPerformingAction = true;
      notifyListeners();

      final result = await requestTeamAccess(teamId);

      if (result == Result.success) {
        // Reload requests to update the UI
        await _loadTeamRequests();
        if (kDebugMode) {
          debugPrint(
              'requestAccess: Request sent successfully, reloaded requests');
        }
      }

      return result == Result.success;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error requesting access: $e');
      }
      return false;
    } finally {
      isPerformingAction = false;
      notifyListeners();
    }
  }

  // Accept team request
  Future<bool> acceptRequest(String requestId) async {
    if (!canManageRequests()) return false;

    try {
      isPerformingAction = true;
      notifyListeners();

      final result = await acceptTeamRequest(requestId);
      if (result == Result.success) {
        await _loadTeamRequests();
        await refreshData();
        return true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error accepting request: $e');
      }
      return false;
    } finally {
      isPerformingAction = false;
      notifyListeners();
    }
  }

  // Decline team request
  Future<bool> declineRequest(String requestId) async {
    if (!canManageRequests()) return false;

    try {
      isPerformingAction = true;
      notifyListeners();

      final result = await declineTeamRequest(requestId);
      if (result == Result.success) {
        await _loadTeamRequests();
        await refreshData(); // Refresh team data after declining request
        return true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error declining request: $e');
      }
      return false;
    } finally {
      isPerformingAction = false;
      notifyListeners();
    }
  }

  // Remove user from team
  Future<bool> removeUser(String userId) async {
    if (!canManageMembers()) return false;

    try {
      isPerformingAction = true;
      notifyListeners();

      final result = await removeUserFromTeam(teamId, userId);
      if (result == Result.success) {
        await refreshData();
        return true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error removing user: $e');
      }
      return false;
    } finally {
      isPerformingAction = false;
      notifyListeners();
    }
  }

  // Leave team
  Future<bool> leaveTeam() async {
    if (!isMember() || getUserRole() == TeamUserRole.creator) {
      return false; // Can't leave if not a member or if creator
    }

    try {
      isPerformingAction = true;
      notifyListeners();

      final result = await leave_team.leaveTeam(teamId);
      return result == Result.success;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error leaving team: $e');
      }
      return false;
    } finally {
      isPerformingAction = false;
      notifyListeners();
    }
  }

  // Update background image
  Future<bool> updateBackgroundImage(File imageFile) async {
    if (!canEditTeam()) return false;

    try {
      isPerformingAction = true;
      notifyListeners();

      final result = await updateTeamBackgroundImage(teamId, imageFile);
      if (result == Result.success) {
        await _loadBackgroundImage();
        await refreshData(); // Refresh all data
        return true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error updating background image: $e');
      }
      return false;
    } finally {
      isPerformingAction = false;
      notifyListeners();
    }
  }

  // Update background image from base64 string
  Future<bool> updateBackgroundImageFromBase64(String base64Image) async {
    if (!canEditTeam()) return false;

    try {
      isPerformingAction = true;
      notifyListeners();

      // Convert base64 to File temporarily
      final bytes = base64Decode(base64Image.split(',')[1]);
      final tempFile = File(
          '${Directory.systemTemp.path}/temp_bg_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await tempFile.writeAsBytes(bytes);

      final result = await updateTeamBackgroundImage(teamId, tempFile);

      // Clean up temp file
      try {
        await tempFile.delete();
      } catch (_) {}

      if (result == Result.success) {
        await _loadBackgroundImage();
        await refreshData(); // Refresh all data
        return true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error updating background image: $e');
      }
      return false;
    } finally {
      isPerformingAction = false;
      notifyListeners();
    }
  }
}
