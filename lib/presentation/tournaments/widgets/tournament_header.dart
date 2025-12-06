import 'package:flutter/material.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TournamentHeader extends StatelessWidget {
  final TournamentModel tournament;

  const TournamentHeader({
    super.key,
    required this.tournament,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 100.h,
      left: 20.w,
      right: 20.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tournament.title,
                      style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        height: 1.2,
                        shadows: [
                          Shadow(
                            offset: const Offset(0, 2),
                            blurRadius: 8,
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        if (tournament.isOfficial) ...[
                          _buildOfficialBadge(),
                          SizedBox(width: 8.w),
                        ],
                        _buildTeamsCountBadge(),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOfficialBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.25),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.verified,
            color: Colors.white,
            size: 16.w,
          ),
          SizedBox(width: 4.w),
          Text(
            'Oficial',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamsCountBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.people,
            color: Colors.white,
            size: 14.w,
          ),
          SizedBox(width: 4.w),
          Text(
            '${tournament.registeredTeams}/${tournament.maxTeams}',
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

