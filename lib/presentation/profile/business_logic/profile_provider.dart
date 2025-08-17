import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jugaenequipo/datasources/models/follow/follow_model.dart';
import 'package:jugaenequipo/datasources/models/follow/follow_user_model.dart';
import 'package:jugaenequipo/datasources/models/user_model.dart';
import 'package:jugaenequipo/datasources/user_use_cases/get_followers_use_case.dart';
import 'package:jugaenequipo/datasources/user_use_cases/get_followings_use_case.dart';
import 'package:jugaenequipo/datasources/user_use_cases/get_user_use_case.dart';

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

  // Method to refresh data
  Future<void> refreshData() async {
    isLoading = true;
    notifyListeners();
    await _loadData();
  }
}
