import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 2.h,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2.h,
            blurRadius: 5.h,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: CircleAvatar(
        maxRadius: 46.h,
        backgroundImage: NetworkImage(
            'https://media.licdn.com/dms/image/C4D03AQGcZkggqz819A/profile-displayphoto-shrink_800_800/0/1644242637439?e=1720051200&v=beta&t=2Ii4NCmuDrsPSXvO7IJJ_zk7qaHK-jOoOr5y9BtYb5g'),
      ),
    );
  }
}