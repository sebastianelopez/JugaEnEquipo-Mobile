class TournamentRequestModel {
  final String id;
  final String tournamentId;
  final String teamId;
  final String status; // e.g., "pending", "accepted", "declined"
  final DateTime createdAt;
  final DateTime? updatedAt;

  TournamentRequestModel({
    required this.id,
    required this.tournamentId,
    required this.teamId,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });

  factory TournamentRequestModel.fromJson(Map<String, dynamic> json) {
    return TournamentRequestModel(
      id: json['id'] as String,
      tournamentId: json['tournamentId'] as String,
      teamId: json['teamId'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tournamentId': tournamentId,
      'teamId': teamId,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
