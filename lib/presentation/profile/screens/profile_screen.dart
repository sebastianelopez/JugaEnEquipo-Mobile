import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jugaenequipo/datasources/models/follow/follow_user_model.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:jugaenequipo/presentation/profile/business_logic/profile_provider.dart';
import 'package:jugaenequipo/presentation/profile/business_logic/team_profile_provider.dart';
import 'package:jugaenequipo/presentation/profile/widgets/profile_content.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';
import 'package:jugaenequipo/presentation/profile/widgets/widgets.dart';
import 'package:jugaenequipo/providers/user_provider.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:jugaenequipo/global_widgets/widgets.dart';
import 'package:provider/provider.dart';

enum ProfileType { user, team }

class ProfileScreen extends StatelessWidget {
  final String? userId;
  final String? teamId;
  final TeamModel? team; // Add team parameter
  final ProfileType profileType;

  const ProfileScreen({
    super.key,
    this.userId,
    this.teamId,
    this.team, // Add team parameter
    this.profileType = ProfileType.user,
  });

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: AppTheme.primary,
      appBar: BackAppBar(
        label: _getAppBarLabel(context),
      ),
      body: _buildBody(context, userProvider),
    );
  }

  String _getAppBarLabel(BuildContext context) {
    switch (profileType) {
      case ProfileType.user:
        return AppLocalizations.of(context)!.profilePageLabel;
      case ProfileType.team:
        return 'Perfil del Equipo';
    }
  }

  Widget _buildBody(BuildContext context, UserProvider userProvider) {
    switch (profileType) {
      case ProfileType.user:
        return _buildUserProfile(context, userProvider);
      case ProfileType.team:
        return _buildTeamProfile(context);
    }
  }

  Widget _buildUserProfile(BuildContext context, UserProvider userProvider) {
    return ChangeNotifierProvider(
      create: (context) => ProfileProvider(
        userId: userId,
        initialUser: userId == null ? userProvider.user : null,
      ),
      child: Consumer<ProfileProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(provider.error!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.refreshData(),
                    child: Text(AppLocalizations.of(context)!.tryAgain),
                  ),
                ],
              ),
            );
          }

          return ProfileContent(
            onFollowersPressed: () =>
                _openUserModal(context, ModalType.followers, provider),
            onFollowingsPressed: () =>
                _openUserModal(context, ModalType.followings, provider),
            onPrizesPressed: () =>
                _openUserModal(context, ModalType.prizes, provider),
          );
        },
      ),
    );
  }

  Widget _buildTeamProfile(BuildContext context) {
    if (teamId == null) {
      return Center(child: Text(AppLocalizations.of(context)!.teamIdRequired));
    }

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return ChangeNotifierProvider(
      create: (context) {
        if (kDebugMode) {
          debugPrint(
              'ProfileScreen._buildTeamProfile: Creating TeamProfileProvider');
          debugPrint('ProfileScreen._buildTeamProfile: team = ${team != null}');
          if (team != null) {
            debugPrint(
                'ProfileScreen._buildTeamProfile: team.id = ${team!.id}');
            debugPrint(
                'ProfileScreen._buildTeamProfile: team.name = ${team!.name}');
            debugPrint(
                'ProfileScreen._buildTeamProfile: team.image = ${team!.image}');
          }
        }
        return TeamProfileProvider(
          teamId: teamId!,
          team: team, // Pass the team data
          currentUserId: userProvider.user?.id,
        );
      },
      child: Consumer<TeamProfileProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(provider.error!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.refreshData(),
                    child: Text(AppLocalizations.of(context)!.tryAgain),
                  ),
                ],
              ),
            );
          }

          return TeamProfileContent(
            onMembersPressed: () =>
                _openTeamModal(context, 'Miembros', provider),
            onTournamentsPressed: () =>
                _openTeamModal(context, 'Torneos', provider),
            onWinsPressed: () => _openTeamModal(context, 'Victorias', provider),
          );
        },
      ),
    );
  }

  void _openUserModal(
      BuildContext context, ModalType type, ProfileProvider provider) {
    showDialog(
      useSafeArea: true,
      context: context,
      builder: (BuildContext context) {
        String title;
        List<Widget> content;

        switch (type) {
          case ModalType.followers:
            title = AppLocalizations.of(context)!.profileFollowersButtonLabel;
            content = provider.followers
                .map((user) => _buildUserListTile(context, user))
                .toList();
            break;
          case ModalType.followings:
            title = AppLocalizations.of(context)!.profileFollowingButtonLabel;
            content = provider.followings
                .map((user) => _buildUserListTile(context, user))
                .toList();
            break;
          case ModalType.prizes:
            title = AppLocalizations.of(context)!.profilePrizesButtonLabel;
            content = [Text(AppLocalizations.of(context)!.prizesContent)];
            break;
        }

        return ProfileModal(
          title: title,
          content: content,
        );
      },
    );
  }

  void _openTeamModal(
      BuildContext context, String type, TeamProfileProvider provider) {
    switch (type) {
      case 'Miembros':
        showDialog(
          useSafeArea: true,
          context: context,
          builder: (BuildContext context) {
            return TeamMemberModal(
              title: AppLocalizations.of(context)!.teamMembersTitle,
              members: provider.teamProfile?.members ?? [],
              canManageMembers: provider.canManageMembers(),
              provider: provider,
            );
          },
        );
        break;
      case 'Torneos':
        showDialog(
          useSafeArea: true,
          context: context,
          builder: (BuildContext context) {
            return ProfileModal(
              title: AppLocalizations.of(context)!.teamTournamentsTitle,
              content: [
                Text(AppLocalizations.of(context)!.teamTournamentsList)
              ],
            );
          },
        );
        break;
      case 'Victorias':
        showDialog(
          useSafeArea: true,
          context: context,
          builder: (BuildContext context) {
            return ProfileModal(
              title: AppLocalizations.of(context)!.teamWinsTitle,
              content: [Text(AppLocalizations.of(context)!.teamWinsHistory)],
            );
          },
        );
        break;
    }
  }

  Widget _buildUserListTile(BuildContext context, FollowUserModel user) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileScreen(
              userId: user.id,
              profileType: ProfileType.user,
            ),
          ),
        );
      },
      leading: CircleAvatar(
        backgroundImage: user.profileImage != null &&
                user.profileImage!.isNotEmpty &&
                (user.profileImage!.startsWith('http://') ||
                    user.profileImage!.startsWith('https://'))
            ? NetworkImage(user.profileImage!)
            : const AssetImage('assets/user_image.jpg') as ImageProvider,
        radius: 16,
        backgroundColor: Colors.white,
      ),
      title: Text(
        "${user.firstname} ${user.lastname}",
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        '@${user.username}',
        style: const TextStyle(fontSize: 11),
      ),
    );
  }
}
