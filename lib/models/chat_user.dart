import 'package:jugaenequipo/models/models.dart';

class ChatUser {
  User user;
  String messageText;
  String time;
  bool isMessageRead;

  ChatUser(
      {required this.user,
      required this.messageText,
      required this.time,
      required this.isMessageRead});
}
