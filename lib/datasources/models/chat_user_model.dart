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
}
