import 'package:jugaenequipo/datasources/models/chat/conversation_model.dart';

class ConversationsResponseModel {
  final List<ConversationModel> conversations;
  final ConversationsMetadata metadata;

  ConversationsResponseModel({
    required this.conversations,
    required this.metadata,
  });
}

class ConversationsMetadata {
  final int total;
  final int totalUnreadMessages;

  ConversationsMetadata({
    required this.total,
    required this.totalUnreadMessages,
  });

  factory ConversationsMetadata.fromJson(Map<String, dynamic> json) {
    return ConversationsMetadata(
      total: (json['total'] as int?) ?? 0,
      totalUnreadMessages: (json['totalUnreadMessages'] as int?) ?? 0,
    );
  }
}
