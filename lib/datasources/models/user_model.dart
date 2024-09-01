class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final String userName;
  final String? teamId;
  final String email;
  final String? profileImage;

  UserModel(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.userName,
      this.teamId,
      required this.email,
      this.profileImage});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json['id'] as String,
        firstName: json['firstName'] as String,
        lastName: json['lastName'] as String,
        userName: json['userName'] as String,
        email: json['email'] as String,
        teamId: json['teamId'] as String,
        profileImage: (json['profileImage'] ?? '') as String);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'userName': userName,
      'email': email,
      'teamId': teamId,
      'profileImage': profileImage
    };
  }
}
