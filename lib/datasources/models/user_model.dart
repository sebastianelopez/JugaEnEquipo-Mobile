class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final String userName;
  final String? teamId;
  final String? email;
  final String? profileImage;
  final String? backgroundImage;
  final String? description;
  final DateTime? createdAt;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.userName,
    this.teamId,
    this.email,
    this.profileImage,
    this.backgroundImage,
    this.description,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      firstName: json['firstname'] as String,
      lastName: json['lastname'] as String,
      userName: json['username'] as String,
      email: json['email'] as String?,
      teamId: json['teamId'] as String?,
      profileImage: json['profileImage'] as String?,
      backgroundImage: json['backgroundImage'] as String?,
      description: json['description'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'userName': userName,
      'email': email,
      'teamId': teamId,
      'profileImage': profileImage,
      'backgroundImage': backgroundImage,
      'description': description,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
