class FollowUserModel {
  final String id;
  final String username;
  final String firstname;
  final String lastname;

  FollowUserModel({
    required this.id,
    required this.username,
    required this.firstname,
    required this.lastname,
  });

  factory FollowUserModel.fromJson(Map<String, dynamic> json) {
    return FollowUserModel(
      id: json['id'] as String,
      username: json['username'] as String,
      firstname: json['firstname'] as String,
      lastname: json['lastname'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'firstname': firstname,
      'lastname': lastname,
    };
  }
}
