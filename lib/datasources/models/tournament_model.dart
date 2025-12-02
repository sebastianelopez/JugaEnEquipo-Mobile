import 'package:jugaenequipo/datasources/models/models.dart';

class TournamentModel {
  final String id;
  final String gameId;
  final String gameName;
  final String tournamentStatusId;
  final String? minGameRankId;
  final String? maxGameRankId;
  final String responsibleId;
  final String name;
  final String? description;
  final String? rules;
  final int registeredTeams;
  final int maxTeams;
  final bool isOfficial;
  final String? image;
  final String? prize;
  final String region;
  final DateTime startAt;
  final DateTime endAt;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final bool isUserRegistered;

  // Computed properties for backward compatibility
  String get title => name;
  GameModel get game => GameModel(id: gameId, name: gameName, image: image);
  DateTime? get startDate => startAt;
  DateTime? get endDate => endAt;
  int? get maxParticipants => maxTeams;
  List<String>? get registeredPlayersIds =>
      List.generate(registeredTeams, (index) => 'player_$index');
  double? get prizePool {
    if (prize == null) return null;
    // Try to extract numeric value from prize string (e.g., "$1000" -> 1000.0)
    final numericString = prize!.replaceAll(RegExp(r'[^\d.]'), '');
    return double.tryParse(numericString);
  }

  // These fields may not be in the API response but are used in forms
  bool? get isPrivate => null; // Not available in search response
  String? get tournamentType => null; // Not available in search response
  String? get registrationDeadline => null; // Not available in search response
  String? get createdBy => responsibleId;
  String? get status =>
      tournamentStatusId; // Using tournamentStatusId as status

  TournamentModel({
    required this.id,
    required this.gameId,
    required this.gameName,
    required this.tournamentStatusId,
    this.minGameRankId,
    this.maxGameRankId,
    required this.responsibleId,
    required this.name,
    this.description,
    this.rules,
    required this.registeredTeams,
    required this.maxTeams,
    required this.isOfficial,
    this.image,
    this.prize,
    required this.region,
    required this.startAt,
    required this.endAt,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
    required this.isUserRegistered,
  });

  factory TournamentModel.fromJson(Map<String, dynamic> json) {
    return TournamentModel(
      id: json['id'] as String,
      gameId: json['gameId'] as String,
      gameName: json['gameName'] as String,
      tournamentStatusId: json['tournamentStatusId'] as String,
      minGameRankId: json['minGameRankId'] as String?,
      maxGameRankId: json['maxGameRankId'] as String?,
      responsibleId: json['responsibleId'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      rules: json['rules'] as String?,
      registeredTeams: json['registeredTeams'] as int? ?? 0,
      maxTeams: json['maxTeams'] as int,
      isOfficial: json['isOfficial'] as bool,
      image: json['image'] as String?,
      prize: json['prize'] as String?,
      region: json['region'] as String,
      startAt: DateTime.parse(json['startAt'] as String),
      endAt: DateTime.parse(json['endAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      deletedAt: json['deletedAt'] != null
          ? DateTime.parse(json['deletedAt'] as String)
          : null,
      isUserRegistered: json['isUserRegistered'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gameId': gameId,
      'gameName': gameName,
      'tournamentStatusId': tournamentStatusId,
      'minGameRankId': minGameRankId,
      'maxGameRankId': maxGameRankId,
      'responsibleId': responsibleId,
      'name': name,
      'description': description,
      'rules': rules,
      'registeredTeams': registeredTeams,
      'maxTeams': maxTeams,
      'isOfficial': isOfficial,
      'image': image,
      'prize': prize,
      'region': region,
      'startAt': startAt.toIso8601String(),
      'endAt': endAt.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
      'isUserRegistered': isUserRegistered,
    };
  }
}
