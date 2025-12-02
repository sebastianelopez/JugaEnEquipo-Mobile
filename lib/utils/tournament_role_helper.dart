import 'package:jugaenequipo/datasources/models/models.dart';

enum TournamentUserRole {
  creator, // responsibleId matches user id
  member, // user's team is registered in tournament
  none, // no special role
}

class TournamentRoleHelper {
  /// Determine the user's role in a tournament
  /// 
  /// Returns:
  /// - TournamentUserRole.creator if user is the responsible (creator)
  /// - TournamentUserRole.member if user's team is registered
  /// - TournamentUserRole.none otherwise
  static TournamentUserRole getUserRole(
    TournamentModel tournament,
    UserModel? currentUser,
  ) {
    if (currentUser == null) return TournamentUserRole.none;

    // Check if user is the creator/responsible
    if (tournament.responsibleId == currentUser.id) {
      return TournamentUserRole.creator;
    }

    // Check if user is registered (via isUserRegistered flag)
    // Note: This might need to be enhanced based on actual API response
    if (tournament.isUserRegistered) {
      return TournamentUserRole.member;
    }

    return TournamentUserRole.none;
  }

  /// Check if user can edit the tournament
  static bool canEdit(TournamentModel tournament, UserModel? currentUser) {
    return getUserRole(tournament, currentUser) == TournamentUserRole.creator;
  }

  /// Check if user can delete the tournament
  static bool canDelete(TournamentModel tournament, UserModel? currentUser) {
    return getUserRole(tournament, currentUser) == TournamentUserRole.creator;
  }

  /// Check if user can assign responsible
  static bool canAssignResponsible(
      TournamentModel tournament, UserModel? currentUser) {
    return getUserRole(tournament, currentUser) == TournamentUserRole.creator;
  }

  /// Check if user can manage requests
  static bool canManageRequests(
      TournamentModel tournament, UserModel? currentUser) {
    return getUserRole(tournament, currentUser) == TournamentUserRole.creator;
  }

  /// Check if user can request access
  static bool canRequestAccess(
      TournamentModel tournament, UserModel? currentUser) {
    if (currentUser == null) return false;
    // User can request access if they're not already registered
    return !tournament.isUserRegistered &&
        getUserRole(tournament, currentUser) == TournamentUserRole.none;
  }

  /// Check if user can leave tournament
  static bool canLeave(TournamentModel tournament, UserModel? currentUser) {
    return getUserRole(tournament, currentUser) == TournamentUserRole.member;
  }
}

