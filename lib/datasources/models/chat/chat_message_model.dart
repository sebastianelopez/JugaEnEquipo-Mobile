class ChatMessageModel {
  String messageContent;
  String messageType; // 'sender' | 'receiver'

  // Optional extended fields for real-time integration
  String? id;
  String? username;
  bool? mine;
  String? createdAt;

  ChatMessageModel({
    required this.messageContent,
    required this.messageType,
    this.id,
    this.username,
    this.mine,
    this.createdAt,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    // Support both legacy shape {messageContent, messageType}
    // and backend message shape {id, content, username, mine, createdAt}
    final hasBackendShape =
        json.containsKey('content') || json.containsKey('mine');
    if (hasBackendShape) {
      final mineValue = json['mine'] as bool?;
      return ChatMessageModel(
        id: json['id'] as String?,
        messageContent: (json['content'] ?? '').toString(),
        messageType: (mineValue ?? false) ? 'sender' : 'receiver',
        username: json['username'] as String?,
        mine: mineValue,
        createdAt: json['createdAt'] as String?,
      );
    }

    return ChatMessageModel(
      messageContent: (json['messageContent'] ?? '').toString(),
      messageType: (json['messageType'] ?? 'receiver').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'messageContent': messageContent,
      'messageType': messageType,
      'username': username,
      'mine': mine,
      'createdAt': createdAt,
    };
  }
}
