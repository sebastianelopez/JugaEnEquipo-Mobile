import 'package:jugaenequipo/datasources/models/models.dart';

class TeamProfileModel extends TeamModel {
  final List<UserModel> members;
  final int totalTournaments;
  final int totalWins;

  TeamProfileModel({
    required super.id,
    required super.name,
    super.description,
    super.image,
    required super.creatorId,
    required super.leaderId,
    required super.createdAt,
    required super.updatedAt,
    super.deletedAt,
    required super.games,
    super.membersIds,
    super.verified,
    required this.members,
    this.totalTournaments = 0,
    this.totalWins = 0,
  });

  factory TeamProfileModel.fromJson(Map<String, dynamic> json) {
    // Parse base TeamModel fields
    final baseTeam = TeamModel.fromJson(json);

    return TeamProfileModel(
      id: baseTeam.id,
      name: baseTeam.name,
      description: baseTeam.description,
      image: baseTeam.image,
      creatorId: baseTeam.creatorId,
      leaderId: baseTeam.leaderId,
      createdAt: baseTeam.createdAt,
      updatedAt: baseTeam.updatedAt,
      deletedAt: baseTeam.deletedAt,
      games: baseTeam.games,
      membersIds: baseTeam.membersIds,
      verified: baseTeam.verified,
      members: (json['members'] as List<dynamic>?)
              ?.map((member) =>
                  UserModel.fromJson(member as Map<String, dynamic>))
              .toList() ??
          [],
      totalTournaments: json['totalTournaments'] as int? ?? 0,
      totalWins: json['totalWins'] as int? ?? 0,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'members': members.map((member) => member.toJson()).toList(),
      'totalTournaments': totalTournaments,
      'totalWins': totalWins,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
