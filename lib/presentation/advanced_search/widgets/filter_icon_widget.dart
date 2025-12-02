import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jugaenequipo/theme/app_theme.dart';

class FilterIconWidget extends StatelessWidget {
  final int activeFiltersCount;
  final VoidCallback onTap;

  const FilterIconWidget({
    super.key,
    required this.activeFiltersCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.w),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(
              Icons.tune,
              color: activeFiltersCount > 0 ? AppTheme.primary : Colors.grey[600],
              size: 24.h,
            ),
            if (activeFiltersCount > 0)
              Positioned(
                right: -2,
                top: -2,
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: const BoxDecoration(
                    color: AppTheme.error,
                    shape: BoxShape.circle,
                  ),
                  constraints: BoxConstraints(
                    minWidth: 16.w,
                    minHeight: 16.h,
                  ),
                  child: Center(
                    child: Text(
                      activeFiltersCount > 9 ? '9+' : activeFiltersCount.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

