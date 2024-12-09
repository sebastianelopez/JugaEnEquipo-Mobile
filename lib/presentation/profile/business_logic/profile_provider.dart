import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jugaenequipo/datasources/models/follow/follow_model.dart';
import 'package:jugaenequipo/datasources/models/follow/follow_user_model.dart';
import 'package:jugaenequipo/datasources/models/user_model.dart';
import 'package:jugaenequipo/datasources/user_use_cases/get_followers_use_case.dart';
import 'package:jugaenequipo/datasources/user_use_cases/get_followings_use_case.dart';
import 'package:jugaenequipo/datasources/user_use_cases/get_user_use_case.dart';
import 'package:jugaenequipo/presentation/profile/screens/profile_screen.dart';
import 'package:jugaenequipo/presentation/profile/widgets/widgets.dart';
import 'package:jugaenequipo/providers/providers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

enum ModalType { followers, followings, prizes }

class ProfileProvider extends ChangeNotifier {
  BuildContext context;
  final String? userId;

  UserModel? profileUser;
  int numberOfFollowings = 0;
  int numberOfFollowers = 0;
  List<FollowUserModel> followings = [];
  List<FollowUserModel> followers = [];

  ProfileProvider({
    required this.context,
    this.userId,
  }) {
    initData();
  }

  bool isLoading = false;

  Future<void> initData() async {
    fetchData();

    notifyListeners();
  }

  Future fetchData() async {
    if (isLoading) return;

    isLoading = true;
    notifyListeners();
    try {
      if (userId == null) {
        // Show logged user profile
        profileUser = Provider.of<UserProvider>(context, listen: false).user;
      } else {
        // Fetch other user's profile
        profileUser = await getUserById(userId!);
      }
      debugPrint(profileUser.toString());

      if (profileUser == null) {
        debugPrint('User is null');
        return;
      }
      var followingsResponse = await getFollowings(profileUser!.id);
      if (followingsResponse != null) {
        FollowModel followingsModel = followingsResponse;
        numberOfFollowings = followingsModel.quantity;
        followings = followingsModel.users;
      }

      var followersResponse = await getFollowers(profileUser!.id);
      if (followersResponse != null) {
        FollowModel followersModel = followersResponse;
        numberOfFollowers = followersModel.quantity;
        followers = followersModel.users;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error profile stats: $e');
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }

    isLoading = false;
  }

  void openModal(ModalType type) {
    showDialog(
      useSafeArea: true,
      context: context,
      builder: (BuildContext context) {
        String title;
        List<Widget> content;

        switch (type) {
          case ModalType.followers:
            title = AppLocalizations.of(context)!.profileFollowersButtonLabel;
            content =
                followers.map((user) => _buildUserListTile(user)).toList();
            break;
          case ModalType.followings:
            title = AppLocalizations.of(context)!.profileFollowingButtonLabel;
            content =
                followings.map((user) => _buildUserListTile(user)).toList();
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

  Widget _buildUserListTile(FollowUserModel user) {
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
