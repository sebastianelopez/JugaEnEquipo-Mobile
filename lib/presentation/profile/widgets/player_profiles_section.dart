import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:jugaenequipo/datasources/api_service.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:jugaenequipo/utils/game_image_helper.dart';
import 'package:jugaenequipo/utils/rank_image_helper.dart';
import 'package:jugaenequipo/presentation/profile/widgets/add_edit_player_profile_dialog.dart';
import 'package:jugaenequipo/datasources/player_use_cases/delete_player_use_case.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';

class PlayerProfilesSection extends StatelessWidget {
  final List<PlayerModel> playerProfiles;
  final bool isOwnProfile;
  final VoidCallback? onProfileChanged;

  const PlayerProfilesSection({
    super.key,
    required this.playerProfiles,
    this.isOwnProfile = false,
    this.onProfileChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Perfiles de Juegos',
                style: TextStyle(
                  fontSize: 16.h,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isOwnProfile)
                IconButton(
                  icon: Icon(Icons.add_circle_outline, color: AppTheme.primary),
                  onPressed: () => _showAddPlayerDialog(context),
                  tooltip: 'Agregar perfil de juego',
                ),
            ],
          ),
          SizedBox(height: 12.h),
          if (playerProfiles.isEmpty)
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: AppTheme.primary.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  'No hay perfiles de juegos',
                  style: TextStyle(
                    fontSize: 14.h,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6),
                  ),
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: playerProfiles.length,
              itemBuilder: (context, index) {
                final player = playerProfiles[index];
                return _buildPlayerCard(context, player);
              },
            ),
        ],
      ),
    );
  }

  void _showAddPlayerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddEditPlayerProfileDialog(
        onSaved: () {
          if (onProfileChanged != null) {
            onProfileChanged!();
          }
        },
      ),
    );
  }

  void _showEditPlayerDialog(BuildContext context, PlayerModel player) {
    showDialog(
      context: context,
      builder: (context) => AddEditPlayerProfileDialog(
        player: player,
        onSaved: () {
          if (onProfileChanged != null) {
            onProfileChanged!();
          }
        },
      ),
    );
  }

  Future<void> _deletePlayer(BuildContext context, PlayerModel player) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deletePlayerProfile),
        content: Text(
          l10n.deletePlayerProfileConfirmation(player.gameName),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.error,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final result = await deletePlayer(player.id);
      if (result == Result.success) {
        if (onProfileChanged != null) {
          onProfileChanged!();
        }
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.playerProfileDeletedSuccessfully),
              backgroundColor: AppTheme.success,
            ),
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.errorDeletingPlayerProfile),
              backgroundColor: AppTheme.error,
            ),
          );
        }
      }
    }
  }

  Widget _buildPlayerCard(BuildContext context, PlayerModel player) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppTheme.primary.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Unverified warning banner
          if (!player.isOwnershipVerified) ...[
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppTheme.warning.withOpacity(0.1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  topRight: Radius.circular(16.r),
                ),
                border: Border(
                  bottom: BorderSide(
                    color: AppTheme.warning.withOpacity(0.3),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppTheme.warning,
                    size: 16.h,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      'Perfil no verificado',
                      style: TextStyle(
                        fontSize: 12.h,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.warning,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          Padding(
            padding: EdgeInsets.all(player.isOwnershipVerified ? 16.w : 12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Game image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: GameImageHelper.buildGameImage(
                        gameName: player.gameName,
                        width: 50.w,
                        height: 50.h,
                        defaultIcon: Icons.sports_esports,
                        defaultIconColor: AppTheme.primary,
                        defaultIconSize: 28.h,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  player.gameName,
                                  style: TextStyle(
                                    fontSize: 16.h,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primary,
                                  ),
                                ),
                              ),
                              // Verification indicator (only show if verified)
                              if (player.verified &&
                                  player.isOwnershipVerified) ...[
                                SizedBox(width: 4.w),
                                Tooltip(
                                  message: 'Perfil verificado',
                                  child: Icon(
                                    Icons.verified_rounded,
                                    color: AppTheme.success,
                                    size: 18.h,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            player.username,
                            style: TextStyle(
                              fontSize: 14.h,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (player.gameRank != null) ...[
                  SizedBox(height: 12.h),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: AppTheme.accent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Rank image
                        Builder(
                          builder: (context) {
                            if (kDebugMode) {
                              debugPrint(
                                  'PlayerProfilesSection: Building rank image for game: ${player.gameName}, rank: ${player.gameRank!.name}');
                            }

                            final rankImageAsset =
                                RankImageHelper.getRankImageAsset(
                              player.gameName,
                              player.gameRank!.name,
                            );

                            if (rankImageAsset != null) {
                              if (kDebugMode) {
                                debugPrint(
                                    'PlayerProfilesSection: Found rank image asset: $rankImageAsset');
                              }
                              return Container(
                                margin: EdgeInsets.only(right: 8.w),
                                width: 24.w,
                                height: 24.h,
                                child: Image.asset(
                                  rankImageAsset,
                                  width: 24.w,
                                  height: 24.h,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    if (kDebugMode) {
                                      debugPrint(
                                          'PlayerProfilesSection: Error loading rank image: $rankImageAsset');
                                      debugPrint(
                                          'PlayerProfilesSection: Error details: $error');
                                      debugPrint(
                                          'PlayerProfilesSection: StackTrace: $stackTrace');
                                    }
                                    return Icon(
                                      Icons.emoji_events,
                                      color: AppTheme.accent,
                                      size: 16.h,
                                    );
                                  },
                                ),
                              );
                            }

                            if (kDebugMode) {
                              debugPrint(
                                  'PlayerProfilesSection: No asset path found for rank: ${player.gameRank!.name} in game: ${player.gameName}');
                            }
                            return Icon(
                              Icons.emoji_events,
                              color: AppTheme.accent,
                              size: 16.h,
                            );
                          },
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          '${player.gameRank!.name} (Nivel ${player.gameRank!.level})',
                          style: TextStyle(
                            fontSize: 13.h,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.accent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (player.accountData.steamId != null ||
                    player.accountData.username != null) ...[
                  SizedBox(height: 12.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: [
                      if (player.accountData.steamId != null)
                        _buildAccountInfoChip(
                          context,
                          'Steam ID',
                          player.accountData.steamId!,
                          Icons.computer,
                        ),
                      if (player.accountData.username != null)
                        _buildAccountInfoChip(
                          context,
                          'RIOT',
                          '${player.accountData.username}${player.accountData.tag != null ? "#${player.accountData.tag}" : ""}',
                          Icons.person,
                        ),
                      if (player.accountData.region != null)
                        _buildAccountInfoChip(
                          context,
                          'Región',
                          player.accountData.region!,
                          Icons.public,
                        ),
                    ],
                  ),
                ],
                // Action buttons (only for own profile)
                if (isOwnProfile) ...[
                  SizedBox(height: 12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit,
                            size: 18.h, color: AppTheme.primary),
                        onPressed: () => _showEditPlayerDialog(context, player),
                        tooltip: 'Editar',
                      ),
                      IconButton(
                        icon: Icon(Icons.delete,
                            size: 18.h, color: AppTheme.error),
                        onPressed: () => _deletePlayer(context, player),
                        tooltip: 'Eliminar',
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountInfoChip(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14.h,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
          SizedBox(width: 6.w),
          Text(
            '$label: $value',
            style: TextStyle(
              fontSize: 12.h,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
