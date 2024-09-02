class ChatMessageModel {
  String messageContent;
  String messageType;

  ChatMessageModel({required this.messageContent, required this.messageType});

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
        messageContent: json['messageContent'] as String,
        messageType: json['messageType'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'messageContent': messageContent, 'messageType': messageType};
  }
}
