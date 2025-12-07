class ConversationModel {
  final String id;
  final String otherUserId;
  final String otherUsername;
  final String otherFirstname;
  final String otherLastname;
  final String? otherProfileImage;
  final String? lastMessageText;
  final String? lastMessageDate;
  final int unreadCount;

  ConversationModel({
    required this.id,
    required this.otherUserId,
    required this.otherUsername,
    required this.otherFirstname,
    required this.otherLastname,
    this.otherProfileImage,
    this.lastMessageText,
    this.lastMessageDate,
    this.unreadCount = 0,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    try {
      return ConversationModel(
        id: (json['id'] ?? '').toString(),
        otherUserId: (json['otherUserId'] ?? '').toString(),
        otherUsername: (json['otherUsername'] ?? '').toString(),
        otherFirstname: (json['otherFirstname'] ?? '').toString(),
        otherLastname: (json['otherLastname'] ?? '').toString(),
        otherProfileImage: json['otherProfileImage']?.toString(),
        lastMessageText: json['lastMessageText']?.toString(),
        lastMessageDate: json['lastMessageDate']?.toString(),
        unreadCount: json['unreadCount'] is int
            ? json['unreadCount'] as int
            : (json['unreadCount'] is num
                ? (json['unreadCount'] as num).toInt()
                : 0),
      );
    } catch (e) {
      throw Exception('Error parsing ConversationModel: $e. JSON: $json');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'otherUserId': otherUserId,
      'otherUsername': otherUsername,
      'otherFirstname': otherFirstname,
      'otherLastname': otherLastname,
      'otherProfileImage': otherProfileImage,
      'lastMessageText': lastMessageText,
      'lastMessageDate': lastMessageDate,
      'unreadCount': unreadCount,
    };
  }
}
