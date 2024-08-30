import 'package:flutter/material.dart';

class BackAppBar extends StatelessWidget {
  final String? label;
  final Color? backgroundColor;

  const BackAppBar({super.key, this.label, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      bottomOpacity: 0.0,
      scrolledUnderElevation: 0,
      backgroundColor: backgroundColor ?? Colors.transparent,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          // Navigate back to the previous screen by popping the current route
          Navigator.of(context).pop();
        },
      ),
      title: Text(
        label ?? '',
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
