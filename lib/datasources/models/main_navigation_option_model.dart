import 'package:flutter/material.dart' show IconData, Widget;

class MainNavigationOptionModel {
  final String route;
  final IconData icon;
  final String? name;
  final Widget? screen;

  MainNavigationOptionModel(
      {required this.route, required this.icon, this.name, this.screen});
}
