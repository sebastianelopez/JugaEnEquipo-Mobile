class ConversationModel {
  final String id;
  final String otherUserId;
  final String otherUsername;
  final String otherFirstname;
  final String otherLastname;
  final String? otherProfileImage;
  final String? lastMessageText;
  final String? lastMessageDate;

  ConversationModel({
    required this.id,
    required this.otherUserId,
    required this.otherUsername,
    required this.otherFirstname,
    required this.otherLastname,
    this.otherProfileImage,
    this.lastMessageText,
    this.lastMessageDate,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id'] as String,
      otherUserId: json['otherUserId'] as String,
      otherUsername: json['otherUsername'] as String,
      otherFirstname: json['otherFirstname'] as String,
      otherLastname: json['otherLastname'] as String,
      otherProfileImage: json['otherProfileImage'] as String?,
      lastMessageText: json['lastMessageText'] as String?,
      lastMessageDate: json['lastMessageDate'] as String?,
    );
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
    };
  }
}

