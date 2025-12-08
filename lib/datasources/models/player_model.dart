class PlayerModel {
  final String id;
  final String username;
  final String gameId;
  final String gameName;
  final bool verified;
  final String? verifiedAt;
  final bool isOwnershipVerified;
  final String? ownershipVerifiedAt;
  final AccountData accountData;
  final GameRank? gameRank;
  final List<String>? gameRoleIds;

  PlayerModel({
    required this.id,
    required this.username,
    required this.gameId,
    required this.gameName,
    required this.verified,
    this.verifiedAt,
    required this.isOwnershipVerified,
    this.ownershipVerifiedAt,
    required this.accountData,
    this.gameRank,
    this.gameRoleIds,
  });

  factory PlayerModel.fromJson(Map<String, dynamic> json) {
    return PlayerModel(
      id: json['id'] as String,
      username: json['username'] as String,
      gameId: json['gameId'] as String,
      gameName: json['gameName'] as String,
      verified: json['verified'] as bool? ?? false,
      verifiedAt: json['verifiedAt'] as String?,
      isOwnershipVerified: json['isOwnershipVerified'] as bool? ?? false,
      ownershipVerifiedAt: json['ownershipVerifiedAt'] as String?,
      accountData:
          AccountData.fromJson(json['accountData'] as Map<String, dynamic>),
      gameRank: json['gameRank'] != null
          ? GameRank.fromJson(json['gameRank'] as Map<String, dynamic>)
          : null,
      gameRoleIds: json['gameRoleIds'] != null
          ? (json['gameRoleIds'] as List).map((e) => e.toString()).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'gameId': gameId,
      'gameName': gameName,
      'verified': verified,
      if (verifiedAt != null) 'verifiedAt': verifiedAt,
      'isOwnershipVerified': isOwnershipVerified,
      if (ownershipVerifiedAt != null)
        'ownershipVerifiedAt': ownershipVerifiedAt,
      'accountData': accountData.toJson(),
      if (gameRank != null) 'gameRank': gameRank!.toJson(),
      if (gameRoleIds != null) 'gameRoleIds': gameRoleIds,
    };
  }
}

class AccountData {
  final String? steamId;
  final String? region; // For RIOT games
  final String? username; // For RIOT games
  final String? tag; // For RIOT games

  AccountData({
    this.steamId,
    this.region,
    this.username,
    this.tag,
  });

  factory AccountData.fromJson(Map<String, dynamic> json) {
    return AccountData(
      steamId: json['steamId'] as String?,
      region: json['region'] as String?,
      username: json['username'] as String?,
      tag: json['tag'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (steamId != null) map['steamId'] = steamId;
    if (region != null) map['region'] = region;
    if (username != null) map['username'] = username;
    if (tag != null) map['tag'] = tag;
    return map;
  }
}

class GameRank {
  final String id;
  final String name;
  final int level;

  GameRank({
    required this.id,
    required this.name,
    required this.level,
  });

  factory GameRank.fromJson(Map<String, dynamic> json) {
    return GameRank(
      id: json['id'] as String,
      name: json['name'] as String,
      level: json['level'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'level': level,
    };
  }
}
