import 'package:flutter/material.dart' show IconData, Widget;

class MainNavigationOption {
  final String route;
  final IconData icon;
  final String? name;
  final Widget screen;

  MainNavigationOption(
      {required this.route,
      required this.icon,
      this.name,
      required this.screen});
}
