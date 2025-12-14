import 'package:flutter/material.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HashtagItem extends StatelessWidget {
  final String hashtag;

  const HashtagItem({
    super.key,
    required this.hashtag,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4.h),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: ListTile(
        leading: Icon(
          Icons.tag,
          color: AppTheme.primary,
          size: 24.sp,
        ),
        title: Text(
          '#$hashtag',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.primary,
          ),
        ),
        onTap: () {
          Navigator.pushNamed(
            context,
            'hashtag-posts',
            arguments: {'hashtag': hashtag},
          );
        },
      ),
    );
  }
}

