import 'package:flutter/material.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:jugaenequipo/presentation/teams/business_logic/teams_screen_provider.dart';
import 'package:jugaenequipo/presentation/teams/widgets/team_card.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:jugaenequipo/global_widgets/widgets.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:provider/provider.dart';

class Teams extends StatelessWidget {
  const Teams({super.key});

  @override
  Widget build(BuildContext context) {
    final teamProvider = Provider.of<TeamsScreenProvider>(context);
    final size = MediaQuery.of(context).size;

    final teams = teamProvider.isLoading
        ? List.filled(
            7,
            TeamModel(
                id: '',
                name: 'Loading...',
                creatorId: '',
                leaderId: '',
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
                games: [
                  GameModel(
                    id: '',
                    name: 'Loading...',
                  ),
                ]))
        : teamProvider.teams;

    // Add 1 to itemCount if loading more data to show loading indicator
    final itemCount = teams.length + (teamProvider.isLoadingMore ? 1 : 0);

    return RefreshIndicator(
      color: AppTheme.primary,
      onRefresh: teamProvider.onRefresh,
      child: Skeletonizer(
        enabled: teamProvider.isLoading && teams.isEmpty,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          controller: teamProvider.scrollController,
          itemCount: itemCount,
          itemBuilder: (BuildContext context, int index) {
            // Show loading indicator at the end
            if (index >= teams.length) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
                    ),
                  ),
                ),
              );
            }
            
            return TeamCard(
              team: teams[index],
            );
          },
        ),
      ),
    );
  }
}
