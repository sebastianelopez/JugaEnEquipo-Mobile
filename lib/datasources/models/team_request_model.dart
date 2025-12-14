import 'package:jugaenequipo/datasources/models/models.dart';

DateTime _parseDateTimePreservingDate(String dateString) {
  try {
    final parsed = DateTime.parse(dateString);
    final localParsed = parsed.toLocal();
    return DateTime(
      localParsed.year,
      localParsed.month,
      localParsed.day,
      localParsed.hour,
      localParsed.minute,
      localParsed.second,
    );
  } catch (e) {
    final parts = dateString.split('T');
    if (parts.length == 2) {
      final datePart = parts[0].split('-');
      final timePart = parts[1].split(':');
      if (datePart.length == 3 && timePart.length >= 2) {
        return DateTime(
          int.parse(datePart[0]),
          int.parse(datePart[1]),
          int.parse(datePart[2]),
          int.parse(timePart[0]),
          int.parse(timePart[1]),
        );
      }
    }
    return DateTime.parse(dateString);
  }
}

class TeamRequestModel {
  final String id;
  final String teamId;
  final String? teamName;
  final String userId;
  final String? userNickname;
  final UserModel? user;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? acceptedAt;
  final String status;

  TeamRequestModel({
    required this.id,
    required this.teamId,
    this.teamName,
    required this.userId,
    this.userNickname,
    this.user,
    required this.createdAt,
    this.updatedAt,
    this.acceptedAt,
    required this.status,
  });

  factory TeamRequestModel.fromJson(Map<String, dynamic> json) {
    return TeamRequestModel(
      id: json['id'] as String,
      teamId: json['teamId'] as String,
      teamName: json['teamName'] as String?,
      userId: json['userId'] as String,
      userNickname: json['userNickname'] as String?,
      user: json['user'] != null
          ? UserModel.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      createdAt: _parseDateTimePreservingDate(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? _parseDateTimePreservingDate(json['updatedAt'] as String)
          : null,
      acceptedAt: json['acceptedAt'] != null
          ? _parseDateTimePreservingDate(json['acceptedAt'] as String)
          : null,
      status: json['status'] as String? ?? 'pending',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'teamId': teamId,
      if (teamName != null) 'teamName': teamName,
      'userId': userId,
      if (userNickname != null) 'userNickname': userNickname,
      if (user != null) 'user': user!.toJson(),
      'createdAt': createdAt.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
      if (acceptedAt != null) 'acceptedAt': acceptedAt!.toIso8601String(),
      'status': status,
    };
  }
}
