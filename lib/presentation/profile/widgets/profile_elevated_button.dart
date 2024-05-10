import 'package:flutter/material.dart';

class ProfileElevatedButton extends StatelessWidget {
  final String label;
  final void Function()? onPressed;

  const ProfileElevatedButton({
    super.key,
    required this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: const ButtonStyle(
          maximumSize: MaterialStatePropertyAll(Size(130, 40)),
          minimumSize: MaterialStatePropertyAll(Size(130, 40)),
          shadowColor: MaterialStatePropertyAll(Colors.grey),
          elevation: MaterialStatePropertyAll(2.0),
          foregroundColor: MaterialStatePropertyAll(Colors.white),
          textStyle:
              MaterialStatePropertyAll(TextStyle(fontWeight: FontWeight.w500))),
      child: Text(label),
    );
  }
}
