import 'package:flutter/material.dart';
import 'package:jugaenequipo/datasources/models/models.dart';

class ChatProvider extends ChangeNotifier {
  List<ChatMessageModel> messages = [
    ChatMessageModel(
        messageContent: "Hola, ¿cómo estás?", messageType: "receiver"),
    ChatMessageModel(
        messageContent: "Hola, estoy bien, ¿y tú?", messageType: "sender"),
    ChatMessageModel(
        messageContent: "También estoy bien, gracias.", messageType: "receiver"),
    ChatMessageModel(
        messageContent: "¿Qué has estado haciendo últimamente?", messageType: "sender"),
    ChatMessageModel(
        messageContent: "He estado trabajando en un nuevo proyecto.", messageType: "receiver"),
    ChatMessageModel(
        messageContent: "¡Qué interesante! Cuéntame más.", messageType: "sender"),
    ChatMessageModel(
        messageContent: "Es un proyecto de desarrollo de software.", messageType: "receiver"),
    ChatMessageModel(
        messageContent: "Suena genial. ¿Necesitas ayuda?", messageType: "sender"),
    ChatMessageModel(
        messageContent: "Sí, cualquier ayuda sería apreciada.", messageType: "receiver"),
    ChatMessageModel(
        messageContent: "Perfecto, ¿cuándo podemos empezar?", messageType: "sender"),
    ChatMessageModel(
        messageContent: "Podemos empezar mañana mismo.", messageType: "receiver"),
  ];
}
