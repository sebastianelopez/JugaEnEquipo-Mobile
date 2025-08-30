import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jugaenequipo/datasources/models/follow/follow_model.dart';
import 'package:jugaenequipo/datasources/models/follow/follow_user_model.dart';
import 'package:jugaenequipo/datasources/models/user_model.dart';
import 'package:jugaenequipo/datasources/user_use_cases/get_followers_use_case.dart';
import 'package:jugaenequipo/datasources/user_use_cases/get_followings_use_case.dart';
import 'package:jugaenequipo/datasources/user_use_cases/get_user_use_case.dart';
import 'package:jugaenequipo/datasources/user_use_cases/follow_user_use_case.dart';
import 'package:jugaenequipo/datasources/user_use_cases/unfollow_user_use_case.dart';

enum ModalType { followers, followings, prizes }

class ProfileProvider extends ChangeNotifier {
  final String? userId;
  final UserModel? initialUser;

  UserModel? profileUser;
  int numberOfFollowings = 0;
  int numberOfFollowers = 0;
  List<FollowUserModel> followings = [];
  List<FollowUserModel> followers = [];
  bool isLoading = true;
  String? error;
  bool isFollowing = false;
  bool isFollowLoading = false;

  ProfileProvider({
    this.userId,
    this.initialUser,
  }) {
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      if (userId == null && initialUser != null) {
        profileUser = initialUser;
      } else if (userId != null) {
        profileUser = await getUserById(userId!);
      }

      if (profileUser == null) {
        error = 'Failed to load user profile';
        isLoading = false;
        notifyListeners();
        return;
      }

      await Future.wait([
        _loadFollowings(),
        _loadFollowers(),
      ]);
    } catch (e) {
      error = 'Error: ${e.toString()}';
      debugPrint('Error loading profile: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadFollowings() async {
    if (profileUser == null) return;

    try {
      final followingsResponse = await getFollowings(profileUser!.id);
      if (followingsResponse != null) {
        FollowModel followingsModel = followingsResponse;
        numberOfFollowings = followingsModel.quantity;
        followings = followingsModel.users;
      }
    } catch (e) {
      debugPrint('Error loading followings: $e');
    }
  }

  Future<void> _loadFollowers() async {
    if (profileUser == null) return;

    try {
      final followersResponse = await getFollowers(profileUser!.id);
      if (followersResponse != null) {
        FollowModel followersModel = followersResponse;
        numberOfFollowers = followersModel.quantity;
        followers = followersModel.users;
      }
    } catch (e) {
      debugPrint('Error loading followers: $e');
    }
  }

  Future<void> checkIfFollowing(UserModel currentUser) async {
    if (profileUser == null) return;

    try {
      // Get current user's followings to check if they're following the profile user
      final currentUserFollowings = await getFollowings(currentUser.id);
      if (currentUserFollowings != null) {
        isFollowing = currentUserFollowings.users
            .any((user) => user.id == profileUser!.id);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error checking if following: $e');
    }
  }

  Future<bool> toggleFollow() async {
    if (profileUser == null) return false;

    isFollowLoading = true;
    notifyListeners();

    try {
      bool success;
      if (isFollowing) {
        success = await unfollowUser(profileUser!.id);
        if (success) {
          isFollowing = false;
          numberOfFollowers =
              (numberOfFollowers - 1).clamp(0, double.infinity).toInt();
        }
      } else {
        if (kDebugMode) {
          debugPrint('followUser: ${profileUser!.userName}');
        }
        success = await followUser(profileUser!.id);
        if (success) {
          isFollowing = true;
          numberOfFollowers = numberOfFollowers + 1;
        }
      }

      notifyListeners();
      return success;
    } catch (e) {
      debugPrint('Error toggling follow: $e');
      notifyListeners();
      return false;
    } finally {
      isFollowLoading = false;
      notifyListeners();
    }
  }

  // Method to refresh data
  Future<void> refreshData() async {
    isLoading = true;
    notifyListeners();
    await _loadData();
  }
}
