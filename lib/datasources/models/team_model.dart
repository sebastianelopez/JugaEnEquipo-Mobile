class TeamModel {
  final String id;
  final String name;
  final List<String> membersIds;

  TeamModel({
    required this.id,
    required this.name,
    required this.membersIds,
  });

  factory TeamModel.fromJson(Map<String, dynamic> json) {
    return TeamModel(
        id: json['id'] as String,
        name: json['name'] as String,
        membersIds: json['membersIds'] as List<String>);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'membersIds': membersIds
    };
  }
}
