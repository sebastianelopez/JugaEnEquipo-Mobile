import 'package:flutter/material.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:jugaenequipo/global_widgets/card_container.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TournamentDetailScreen extends StatelessWidget {
  final TournamentModel tournament;

  const TournamentDetailScreen({
    super.key,
    required this.tournament,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tournamentDetailsTitle),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTournamentHeader(context),
            SizedBox(height: 24.h),

            _buildGameInfo(context),
            SizedBox(height: 24.h),

            _buildOfficialStatus(context),
            SizedBox(height: 24.h),

            _buildParticipantsSection(context),
            SizedBox(height: 24.h),

            _buildRegistrationButton(context),
            SizedBox(height: 24.h),

            _buildAdditionalInfo(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTournamentHeader(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return CardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  tournament.title,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              if (tournament.isOfficial)
                Icon(
                  Icons.verified,
                  color: AppTheme.primary,
                  size: 28.sp,
                ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            '${l10n.tournamentParticipantsLabel}: ${tournament.registeredPlayersIds?.length ?? 0}',
            style: TextStyle(
              fontSize: 16.sp,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameInfo(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return CardContainer(
      child: Column(
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
              if (tournament.game.image.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.asset(
                    tournament.game.image,
                    width: 60.w,
                    height: 60.h,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 60.w,
                        height: 60.h,
                        decoration: BoxDecoration(
                          color: AppTheme.accent.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(
                          Icons.sports_esports,
                          size: 30.sp,
                          color: AppTheme.accent,
                        ),
                      );
                    },
                  ),
                )
              else
                Container(
                  width: 60.w,
                  height: 60.h,
                  decoration: BoxDecoration(
                    color: AppTheme.accent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.sports_esports,
                    size: 30.sp,
                    color: AppTheme.accent,
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
                            .withValues(alpha: 0.6),
                      ),
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

  Widget _buildOfficialStatus(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return CardContainer(
      child: Row(
        children: [
          Icon(
            tournament.isOfficial ? Icons.verified : Icons.info_outline,
            color: tournament.isOfficial ? AppTheme.primary : AppTheme.warning,
            size: 24.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tournament.isOfficial
                      ? l10n.tournamentOfficialLabel
                      : l10n.tournamentCommunityLabel,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Text(
                  tournament.isOfficial
                      ? l10n.tournamentOfficialDescription
                      : l10n.tournamentCommunityDescription,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParticipantsSection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final participantsCount = tournament.registeredPlayersIds?.length ?? 0;

    return CardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.tournamentParticipantsLabel,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              Text(
                '$participantsCount',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          if (participantsCount > 0) ...[
            // Aquí podrías mostrar la lista de participantes
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: Theme.of(context)
                      .colorScheme
                      .outline
                      .withValues(alpha: 0.2),
                ),
              ),
                              child: Text(
                  l10n.tournamentParticipantsListLabel,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.7),
                  ),
                ),
            ),
          ] else ...[
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppTheme.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.people_outline,
                    color: AppTheme.warning,
                    size: 20.sp,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      l10n.tournamentNoParticipantsLabel,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppTheme.warning,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRegistrationButton(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isRegistered =
        tournament.registeredPlayersIds?.contains('currentUserId') ?? false;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isRegistered
            ? null
            : () {
                // TODO: Implementar lógica de inscripción
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                                       content: Text(l10n.tournamentRegistrationSuccess),
                    backgroundColor: AppTheme.success,
                  ),
                );
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: isRegistered ? AppTheme.success : AppTheme.primary,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: Text(
          isRegistered ? l10n.tournamentAlreadyRegisteredLabel : l10n.tournamentRegisterButtonLabel,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildAdditionalInfo(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return CardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.tournamentAdditionalInfoLabel,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 16.h),
          _buildInfoRow(
            context,
            Icons.calendar_today,
            l10n.tournamentStartDateLabel,
            l10n.tournamentStartDatePlaceholder,
          ),
          SizedBox(height: 8.h),
          _buildInfoRow(
            context,
            Icons.location_on,
            l10n.tournamentLocationLabel,
            l10n.tournamentLocationPlaceholder,
          ),
          SizedBox(height: 8.h),
          _buildInfoRow(
            context,
            Icons.emoji_events,
            l10n.tournamentPrizePoolLabel,
            l10n.tournamentPrizePoolPlaceholder,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
      BuildContext context, IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20.sp,
          color: AppTheme.accent,
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.6),
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
