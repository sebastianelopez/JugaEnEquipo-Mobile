import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:jugaenequipo/datasources/user_use_cases/get_user_use_case.dart';
import 'package:jugaenequipo/utils/utils.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;
  var storage = const FlutterSecureStorage();

  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }

  Future<void> updateUser() async {
    var token = await storage.read(key: 'access_token');
    if (token != null) {
      final decodedId = decodeUserIdByToken(token);
      var updatedUser = await getUserById(decodedId);
      if (updatedUser == null) {
        print('User not found');
      }
      setUser(updatedUser!);
      notifyListeners();
    }
  }
}
