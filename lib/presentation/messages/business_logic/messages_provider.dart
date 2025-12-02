import 'package:flutter/material.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:jugaenequipo/datasources/chat_use_cases/get_all_conversations_use_case.dart';

class MessagesProvider extends ChangeNotifier {
  List<ConversationModel> conversations = [];
  bool isLoading = false;
  String? errorMessage;

  MessagesProvider() {
    loadConversations();
  }

  Future<void> loadConversations() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      conversations = await getAllConversations();
      if (conversations.isEmpty && errorMessage == null) {
        // No error occurred, just empty list
        errorMessage = null;
      }
    } catch (e) {
      errorMessage = 'Error al cargar las conversaciones';
      conversations = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshConversations() async {
    await loadConversations();
  }
}
