import 'package:flutter/material.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: AppTheme.primary,
                    fontSize: 14.h)),
            Text(
              label,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: AppTheme.primary,
                  fontSize: 13.h),
            )
          ],
        ),
      ),
    );
  }
}
