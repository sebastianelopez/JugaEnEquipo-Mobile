import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

double _toolbarHeight = 50.0.h;

class BackAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? label;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const BackAppBar({
    super.key,
    this.label,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final defaultForegroundColor =
        foregroundColor ?? Theme.of(context).colorScheme.onPrimary;

    return AppBar(
      toolbarHeight: _toolbarHeight,
      elevation: 0.0,
      bottomOpacity: 0.0,
      scrolledUnderElevation: 0,
      backgroundColor: backgroundColor ?? Colors.transparent,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: defaultForegroundColor),
        onPressed: () {
          // Navigate back to the previous screen by popping the current route
          Navigator.of(context).pop();
        },
      ),
      title: Text(
        label ?? '',
        style: TextStyle(color: defaultForegroundColor),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(_toolbarHeight);
}
