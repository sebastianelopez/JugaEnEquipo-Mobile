import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CardContainer extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final BoxShadow? boxShadow;

  const CardContainer(
      {super.key, required this.child, this.backgroundColor, this.boxShadow});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.w),
        decoration: _createCardShape(backgroundColor),
        child: child,
      ),
    );
  }

  BoxDecoration _createCardShape(Color? backgroundColor) => BoxDecoration(
      color: backgroundColor ?? const Color(0xFFFFFFFF),
      borderRadius: BorderRadius.circular(25),
      boxShadow: boxShadow != null ? [boxShadow!] : null);
}
