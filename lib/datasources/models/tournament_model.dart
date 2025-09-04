import 'package:jugaenequipo/datasources/models/models.dart';

class TournamentModel {
  final String id;
  final String title;
  final String? description;
  final bool isOfficial;
  final bool? isPrivate;
  final GameModel game;
  final List<String>? registeredPlayersIds;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? maxParticipants;
  final double? prizePool;
  final String? tournamentType;
  final String? registrationDeadline;
  final String? createdBy;
  final DateTime? createdAt;
  final String? status; // draft, published, ongoing, completed, cancelled

  TournamentModel({
    required this.id,
    required this.title,
    this.description,
    required this.isOfficial,
    this.isPrivate,
    required this.game,
    this.registeredPlayersIds,
    this.startDate,
    this.endDate,
    this.maxParticipants,
    this.prizePool,
    this.tournamentType,
    this.registrationDeadline,
    this.createdBy,
    this.createdAt,
    this.status,
  });

  factory TournamentModel.fromJson(Map<String, dynamic> json) {
    return TournamentModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      isOfficial: json['isOfficial'] as bool,
      isPrivate: json['isPrivate'] as bool?,
      game: json['game'] as GameModel,
      registeredPlayersIds: json['registeredPlayersIds'] as List<String>?,
      startDate: json['startDate'] != null ? DateTime.parse(json['startDate'] as String) : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate'] as String) : null,
      maxParticipants: json['maxParticipants'] as int?,
      prizePool: json['prizePool'] != null ? (json['prizePool'] as num).toDouble() : null,
      tournamentType: json['tournamentType'] as String?,
      registrationDeadline: json['registrationDeadline'] as String?,
      createdBy: json['createdBy'] as String?,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null,
      status: json['status'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isOfficial': isOfficial,
      'isPrivate': isPrivate,
      'game': game,
      'registeredPlayersIds': registeredPlayersIds,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'maxParticipants': maxParticipants,
      'prizePool': prizePool,
      'tournamentType': tournamentType,
      'registrationDeadline': registrationDeadline,
      'createdBy': createdBy,
      'createdAt': createdAt?.toIso8601String(),
      'status': status,
    };
  }
}
