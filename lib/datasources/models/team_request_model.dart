import 'package:jugaenequipo/datasources/models/models.dart';

class TeamRequestModel {
  final String id;
  final String teamId;
  final String userId;
  final UserModel? user; // Optional user data
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String status; // e.g., "pending", "accepted", "declined"

  TeamRequestModel({
    required this.id,
    required this.teamId,
    required this.userId,
    this.user,
    required this.createdAt,
    this.updatedAt,
    required this.status,
  });

  factory TeamRequestModel.fromJson(Map<String, dynamic> json) {
    return TeamRequestModel(
      id: json['id'] as String,
      teamId: json['teamId'] as String,
      userId: json['userId'] as String,
      user: json['user'] != null
          ? UserModel.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      status: json['status'] as String? ?? 'pending',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'teamId': teamId,
      'userId': userId,
      if (user != null) 'user': user!.toJson(),
      'createdAt': createdAt.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
      'status': status,
    };
  }
}

