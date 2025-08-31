import 'package:flutter/material.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';
import 'package:jugaenequipo/presentation/tournaments/business_logic/tournaments_provider.dart';
import 'package:jugaenequipo/presentation/tournaments/screen/tournament_detail_screen.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TournamentsTable extends StatelessWidget {
  const TournamentsTable({super.key});

  @override
  Widget build(BuildContext context) {
    final tournamentsScreen = Provider.of<TournamentsProvider>(context);
    final l10n = AppLocalizations.of(context)!;

    return _buildTournamentsList(context, tournamentsScreen, l10n);
  }

  Widget _buildTournamentsList(
    BuildContext context,
    TournamentsProvider tournamentsScreen,
    AppLocalizations l10n,
  ) {
    if (tournamentsScreen.isLoading) {
      return _buildLoadingState(context);
    }

    if (tournamentsScreen.tournamentsMocks.isEmpty) {
      return _buildEmptyState(context, l10n);
    }

    return _buildTournamentsGrid(context, tournamentsScreen, l10n);
  }

  Widget _buildLoadingState(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      child: Column(
        children: [
          SizedBox(height: 48.h),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
          ),
          SizedBox(height: 16.h),
          Text(
            'Loading tournaments...',
            style: TextStyle(
              fontSize: 16.sp,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: EdgeInsets.all(32.w),
      child: Column(
        children: [
          SizedBox(height: 48.h),
          Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.emoji_events_outlined,
              size: 48.w,
              color: AppTheme.primary,
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'No tournaments available',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Text(
            'Check back later for new tournaments',
            style: TextStyle(
              fontSize: 16.sp,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTournamentsGrid(
    BuildContext context,
    TournamentsProvider tournamentsScreen,
    AppLocalizations l10n,
  ) {
    return ListView.separated(
      padding: EdgeInsets.all(16.w),
      itemCount: tournamentsScreen.tournamentsMocks.length,
      separatorBuilder: (context, index) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final tournament = tournamentsScreen.tournamentsMocks[index];
        return _buildTournamentCard(context, tournament, l10n);
      },
    );
  }

  Widget _buildTournamentCard(
    BuildContext context,
    dynamic tournament,
    AppLocalizations l10n,
  ) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  TournamentDetailScreen(tournament: tournament),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      tournament.title,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  if (tournament.isOfficial)
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: AppTheme.primary.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.verified,
                            color: AppTheme.primary,
                            size: 16.w,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            'Official',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),

              SizedBox(height: 16.h),

              Row(
                children: [
                  Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: AppTheme.accent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: tournament.game.image.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8.r),
                            child: Image.asset(
                              tournament.game.image,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.sports_esports,
                                  color: AppTheme.accent,
                                  size: 20.w,
                                );
                              },
                            ),
                          )
                        : Icon(
                            Icons.sports_esports,
                            color: AppTheme.accent,
                            size: 20.w,
                          ),
                  ),

                  SizedBox(width: 12.w),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Game',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.6),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          tournament.game.name,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(width: 16.w),

                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: AppTheme.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: AppTheme.success.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          tournament.registeredPlayersIds?.length.toString() ??
                              '0',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.success,
                          ),
                        ),
                        Text(
                          'Players',
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.success,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 44.h,
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: AppTheme.primary.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'View Details',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primary,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 12.w),

                  Container(
                    width: 44.w,
                    height: 44.h,
                    decoration: BoxDecoration(
                      color: AppTheme.accent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: AppTheme.accent.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: AppTheme.accent,
                      size: 20.w,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
