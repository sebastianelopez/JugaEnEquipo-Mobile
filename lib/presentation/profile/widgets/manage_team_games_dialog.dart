import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:jugaenequipo/presentation/profile/business_logic/team_profile_provider.dart';
import 'package:jugaenequipo/theme/app_theme.dart';

class ManageTeamGamesDialog extends StatefulWidget {
  final TeamProfileModel team;
  final List<GameModel> availableGames;
  final TeamProfileProvider provider;

  const ManageTeamGamesDialog({
    super.key,
    required this.team,
    required this.availableGames,
    required this.provider,
  });

  @override
  State<ManageTeamGamesDialog> createState() => _ManageTeamGamesDialogState();
}

class _ManageTeamGamesDialogState extends State<ManageTeamGamesDialog> {
  @override
  Widget build(BuildContext context) {
    final teamGameIds = widget.team.games.map((g) => g.id).toSet();

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.sports_esports, color: Colors.white, size: 24.h),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      'Manage Games',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.h,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.all(16.w),
                itemCount: widget.availableGames.length,
                itemBuilder: (context, index) {
                  final game = widget.availableGames[index];
                  final isAdded = teamGameIds.contains(game.id);

                  return Card(
                    margin: EdgeInsets.only(bottom: 12.h),
                    child: ListTile(
                      leading: game.image != null && game.image!.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                game.image!,
                                width: 40.w,
                                height: 40.w,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(Icons.sports_esports,
                                        color: AppTheme.accent),
                              ),
                            )
                          : Icon(Icons.sports_esports, color: AppTheme.accent),
                      title: Text(
                        game.name,
                        style: TextStyle(
                          fontSize: 16.h,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: isAdded
                          ? IconButton(
                              icon: Icon(Icons.remove_circle,
                                  color: Colors.red, size: 24.h),
                              onPressed: widget.provider.isPerformingAction
                                  ? null
                                  : () async {
                                      final success =
                                          await widget.provider.removeGame(game.id);
                                      if (mounted) {
                                        if (success) {
                                          setState(() {});
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    '${game.name} removed')),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text('Error removing game')),
                                          );
                                        }
                                      }
                                    },
                            )
                          : IconButton(
                              icon: Icon(Icons.add_circle,
                                  color: AppTheme.primary, size: 24.h),
                              onPressed: widget.provider.isPerformingAction
                                  ? null
                                  : () async {
                                      final success =
                                          await widget.provider.addGame(game.id);
                                      if (mounted) {
                                        if (success) {
                                          setState(() {});
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    '${game.name} added')),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text('Error adding game')),
                                          );
                                        }
                                      }
                                    },
                            ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

