import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class PostProvider with ChangeNotifier {
  String? _postId;

  String? get postId => _postId;

  void generatePostId() {
    _postId = const Uuid().v4();
    notifyListeners();
  }

  void clearPostId() {
    _postId = null;
    notifyListeners();
  }
}