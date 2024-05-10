import 'package:flutter/material.dart';
import 'package:jugaenequipo/theme/app_theme.dart';

class NumberAndLabel extends StatelessWidget {
  final int number;
  final String label;
  final void Function()? onTap;
  final bool? hasRightBorder;

  const NumberAndLabel(
      {super.key,
      required this.number,
      required this.label,
      this.onTap,
      this.hasRightBorder = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                right: hasRightBorder != null && hasRightBorder!
                    ? BorderSide(color: Colors.grey[300]!)
                    : BorderSide.none)),
        child: Column(
          children: [
            Text(number.toString(),
                style: const TextStyle(
                    fontWeight: FontWeight.w900, color: AppTheme.primary)),
            Text(
              label,
              style: const TextStyle(
                  fontWeight: FontWeight.w400, color: AppTheme.primary),
            )
          ],
        ),
      ),
    );
  }
}
