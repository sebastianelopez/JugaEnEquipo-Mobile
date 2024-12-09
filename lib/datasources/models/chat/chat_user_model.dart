import 'package:jugaenequipo/datasources/models/models.dart';

class ChatUserModel {
  UserModel user;
  String messageText;
  String time;
  bool isMessageRead;

  ChatUserModel(
      {required this.user,
      required this.messageText,
      required this.time,
      required this.isMessageRead});

  factory ChatUserModel.fromJson(Map<String, dynamic> json) {
    return ChatUserModel(
        user: json['user'] as UserModel,
        messageText: json['messageText'] as String,
        time: json['time'] as String,
        isMessageRead: json['isMessageRead'] as bool);
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user,
      'messageText': messageText,
      'time': time,
      'isMessageRead': isMessageRead
    };
  }
}
