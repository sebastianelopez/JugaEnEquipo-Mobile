import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:jugaenequipo/utils/game_image_helper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TournamentGameInfo extends StatelessWidget {
  final TournamentModel tournament;

  const TournamentGameInfo({
    super.key,
    required this.tournament,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (kDebugMode) {
      debugPrint(
          'TournamentGameInfo: Game name from tournament: "${tournament.game.name}"');
      debugPrint('TournamentGameInfo: Game ID: "${tournament.game.id}"');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.tournamentGameInfoLabel,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Container(
              width: 60.w,
              height: 60.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: Colors.transparent,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Builder(
                  builder: (context) {
                    // Test: Try to load valorant image directly
                    if (tournament.game.name
                        .toLowerCase()
                        .contains('valorant')) {
                      if (kDebugMode) {
                        debugPrint(
                            'TournamentGameInfo: FORCING valorant.png load');
                      }
                      return Image.asset(
                        'assets/games/valorant.png',
                        width: 60.w,
                        height: 60.h,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          if (kDebugMode) {
                            debugPrint(
                                'TournamentGameInfo: DIRECT LOAD ERROR: $error');
                          }
                          return Container(
                            width: 60.w,
                            height: 60.h,
                            color: Colors.red.withOpacity(0.3),
                            child: Icon(Icons.error, color: Colors.red),
                          );
                        },
                      );
                    }

                    // Use helper for other games
                    return GameImageHelper.buildGameImage(
                      gameName: tournament.game.name,
                      width: 60.w,
                      height: 60.h,
                      defaultIcon: Icons.sports_esports,
                      defaultIconColor: AppTheme.accent,
                      defaultIconSize: 30.sp,
                    );
                  },
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tournament.game.name,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    l10n.tournamentGameTypeLabel,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
