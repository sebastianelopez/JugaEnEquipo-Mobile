import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jugaenequipo/theme/app_theme.dart';

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
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primary,
            AppTheme.primary.withOpacity( 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16.h),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withOpacity( 0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.white.withOpacity( 0.1),
            blurRadius: 1,
            offset: const Offset(0, 1),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16.h),
          child: Container(
            constraints: BoxConstraints(
              minWidth: 130.h,
            ),
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            height: 44.h,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.h),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: onPressed == null
                        ? Colors.white.withOpacity(0.6)
                        : Colors.white,
                    fontSize: 14.h,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    height: 1.2,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
