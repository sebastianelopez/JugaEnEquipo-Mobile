import 'package:flutter/material.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TournamentDescription extends StatelessWidget {
  final TournamentModel tournament;

  const TournamentDescription({
    super.key,
    required this.tournament,
  });

  @override
  Widget build(BuildContext context) {
    if (tournament.description == null || tournament.description!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        tournament.description!,
        style: TextStyle(
          fontSize: 15.sp,
          color: Theme.of(context).colorScheme.onSurface,
          height: 1.5,
        ),
      ),
    );
  }
}
