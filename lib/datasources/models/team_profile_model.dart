import 'package:jugaenequipo/datasources/models/models.dart';

class TeamProfileModel extends TeamModel {
  final List<UserModel> members;
  final int totalTournaments;
  final int totalWins;
  final String? description;
  final DateTime createdAt;

  TeamProfileModel({
    required super.id,
    required super.name,
    required super.membersIds,
    super.teamImage,
    required super.game,
    required super.verified,
    required this.members,
    this.totalTournaments = 0,
    this.totalWins = 0,
    this.description,
    required this.createdAt,
  });

  factory TeamProfileModel.fromJson(Map<String, dynamic> json) {
    return TeamProfileModel(
      id: json['id'] as String,
      name: json['name'] as String,
      membersIds: json['membersIds'] as List<String>,
      teamImage: json['teamImage'] != null ? json['teamImage'] as String : null,
      game: GameModel.fromJson(json['game']),
      verified: json['verified'] as bool,
      members: (json['members'] as List<dynamic>?)
          ?.map((member) => UserModel.fromJson(member))
          .toList() ?? [],
      totalTournaments: json['totalTournaments'] as int? ?? 0,
      totalWins: json['totalWins'] as int? ?? 0,
      description: json['description'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
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
