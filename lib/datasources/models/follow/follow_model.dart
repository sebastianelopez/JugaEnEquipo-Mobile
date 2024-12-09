import 'package:jugaenequipo/datasources/models/follow/follow_user_model.dart';

class FollowModel {
  final List<FollowUserModel> users;
  final int quantity;

  FollowModel({
    required this.users,
    required this.quantity,
  });

  factory FollowModel.fromJson(Map<String, dynamic> json) {
    var usersJson = json['data'] as List;
    List<FollowUserModel> usersList = usersJson.map((userJson) => FollowUserModel.fromJson(userJson)).toList();

    return FollowModel(
      users: usersList,
      quantity: json['metadata']['quantity'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': users.map((user) => user.toJson()).toList(),
      'metadata': {'quantity': quantity},
    };
  }
}
