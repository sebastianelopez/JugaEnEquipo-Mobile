import 'package:flutter/material.dart';
import 'package:jugaenequipo/models/models.dart';

class ChatProvider extends ChangeNotifier {
  List<ChatMessage> messages = [
    ChatMessage(
        messageContent: "cuando nos vemos de nuevo?", messageType: "receiver"),
    ChatMessage(messageContent: "te extraño", messageType: "receiver"),
    ChatMessage(
        messageContent: "esta semana ando a mil", messageType: "sender"),
    ChatMessage(messageContent: "dale man, por favor", messageType: "receiver"),
    ChatMessage(
        messageContent: "tengo que trabajar, chabon", messageType: "sender"),
    ChatMessage(messageContent: "es que no entendes", messageType: "receiver"),
    ChatMessage(
        messageContent: "lo que pasa es que...", messageType: "receiver"),
    ChatMessage(messageContent: "??", messageType: "sender"),
    ChatMessage(messageContent: "extraño....", messageType: "receiver"),
    ChatMessage(messageContent: "...", messageType: "sender"),
    ChatMessage(messageContent: "extraño tu pene", messageType: "receiver"),
  ];
}
