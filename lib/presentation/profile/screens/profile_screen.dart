import 'package:flutter/material.dart';
import 'package:jugaenequipo/datasources/models/follow/follow_user_model.dart';
import 'package:jugaenequipo/presentation/profile/business_logic/profile_provider.dart';
import 'package:jugaenequipo/presentation/profile/widgets/profile_content.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';
import 'package:jugaenequipo/presentation/profile/widgets/widgets.dart';
import 'package:jugaenequipo/providers/user_provider.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:jugaenequipo/global_widgets/widgets.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  final String? userId;

  const ProfileScreen({
    Key? key,
    this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: AppTheme.primary,
      appBar: BackAppBar(
        label: AppLocalizations.of(context)!.profilePageLabel,
      ),
      body: ChangeNotifierProvider(
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
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              );
            }

            return ProfileContent(
              onFollowersPressed: () =>
                  _openModal(context, ModalType.followers, provider),
              onFollowingsPressed: () =>
                  _openModal(context, ModalType.followings, provider),
              onPrizesPressed: () =>
                  _openModal(context, ModalType.prizes, provider),
            );
          },
        ),
      ),
    );
  }

  void _openModal(
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
            content = [const Text('Prizes content goes here')];
            break;
        }

        return ProfileModal(
          title: title,
          content: content,
        );
      },
    );
  }

  Widget _buildUserListTile(BuildContext context, FollowUserModel user) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileScreen(userId: user.id),
          ),
        );
      },
      leading: const CircleAvatar(
        backgroundImage: AssetImage('assets/login.png'),
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
