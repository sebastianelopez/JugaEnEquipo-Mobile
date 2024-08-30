import 'package:flutter/material.dart' show IconData, Widget;

class MenuOptionModel {
  final String route;
  final IconData? icon;
  final String name;
  final Widget screen;

  MenuOptionModel({
      required this.route,
      this.icon,
      required this.name,
      required this.screen});
}
