import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      style: ButtonStyle(
        maximumSize: WidgetStatePropertyAll(Size(130.h, 40.h)),
        minimumSize: WidgetStatePropertyAll(Size(130.h, 40.h)),
        shadowColor: const WidgetStatePropertyAll(Colors.grey),
        elevation: WidgetStatePropertyAll(2.0.h),
        foregroundColor: const WidgetStatePropertyAll(Colors.white),
        textStyle: WidgetStatePropertyAll(
            TextStyle(fontWeight: FontWeight.w500, fontSize: 13.5.h)),
      ),
      child: Text(label),
    );
  }
}
