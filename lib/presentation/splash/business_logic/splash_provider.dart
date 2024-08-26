import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/models/models.dart';
import 'package:jugaenequipo/presentation/screens.dart';

class SplashProvider extends ChangeNotifier {
  final BuildContext context;

  SplashProvider(this.context) {
    initData(context);
  }

  Future<void> initData(BuildContext context) async {
    const storage = FlutterSecureStorage();
    var token = storage.read(key: 'access_token');
    notifyListeners();

    if (token != null) {
      Navigator.pushReplacementNamed(context, 'home');
    } else {
      Navigator.pushReplacementNamed(context, 'login');
    }
  }
}
