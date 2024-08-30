import 'package:flutter/material.dart';
import 'package:jugaenequipo/datasources/models/models.dart';

class ChatProvider extends ChangeNotifier {
  List<ChatMessageModel> messages = [
    ChatMessageModel(
        messageContent: "cuando nos vemos de nuevo?", messageType: "receiver"),
    ChatMessageModel(messageContent: "te extraño", messageType: "receiver"),
    ChatMessageModel(
        messageContent: "esta semana ando a mil", messageType: "sender"),
    ChatMessageModel(messageContent: "dale man, por favor", messageType: "receiver"),
    ChatMessageModel(
        messageContent: "tengo que trabajar, chabon", messageType: "sender"),
    ChatMessageModel(messageContent: "es que no entendes", messageType: "receiver"),
    ChatMessageModel(
        messageContent: "lo que pasa es que...", messageType: "receiver"),
    ChatMessageModel(messageContent: "??", messageType: "sender"),
    ChatMessageModel(messageContent: "extraño....", messageType: "receiver"),
    ChatMessageModel(messageContent: "...", messageType: "sender"),
    ChatMessageModel(messageContent: "extraño tu pene", messageType: "receiver"),
  ];
}
