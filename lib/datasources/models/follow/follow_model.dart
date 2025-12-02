import 'package:jugaenequipo/datasources/models/follow/follow_user_model.dart';

class FollowModel {
  final List<FollowUserModel> users;
  final int quantity; // Total count from metadata.total

  FollowModel({
    required this.users,
    required this.quantity,
  });

  factory FollowModel.fromJson(Map<String, dynamic> json) {
    // Validate and parse users list
    if (json['data'] == null || json['data'] is! List) {
      throw FormatException(
          'FollowModel: "data" field is missing or not a list');
    }

    final usersJson = json['data'] as List;
    final usersList = usersJson
        .map((userJson) =>
            FollowUserModel.fromJson(userJson as Map<String, dynamic>))
        .toList();

    // Validate and parse metadata
    if (json['metadata'] == null || json['metadata'] is! Map<String, dynamic>) {
      throw FormatException(
          'FollowModel: "metadata" field is missing or invalid');
    }

    final metadata = json['metadata'] as Map<String, dynamic>;

    // Use 'total' for the total count, fallback to 'count' if 'total' is not available
    final totalCount = metadata['total'] ?? metadata['count'];
    if (totalCount == null) {
      throw FormatException(
          'FollowModel: "metadata.total" or "metadata.count" field is missing');
    }

    return FollowModel(
      users: usersList,
      quantity: totalCount as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': users.map((user) => user.toJson()).toList(),
      'metadata': {
        'total': quantity,
        'count': users.length,
      },
    };
  }
}
