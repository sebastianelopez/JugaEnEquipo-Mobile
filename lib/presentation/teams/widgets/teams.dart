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
                name: 'aaaaaaaaaaaaaaaaa',
                membersIds: ["1", "2", "3"],
                games: [
                  GameModel(
                    id: '',
                    name: 'aaaaaaaaaaaaaaaaa',
                    image: 'aaaaaaaaaaaaaaaaa',
                  ),
                ],
                verified: false))
        : teamProvider.teams;

    return Stack(
      children: [
        RefreshIndicator(
          color: AppTheme.primary,
          onRefresh: teamProvider.onRefresh,
          child: Skeletonizer(
            enabled: teamProvider.isLoading,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              controller: teamProvider.scrollController,
              itemCount: teams.length,
              itemBuilder: (BuildContext context, int index) {
                return TeamCard(
                  team: teams[index],
                );
              },
            ),
          ),
        ),
        if (teamProvider.isLoading)
          Positioned(
              bottom: 40,
              left: size.width * 0.5 - 30,
              child: const LoadingIcon())
      ],
    );
  }
}
