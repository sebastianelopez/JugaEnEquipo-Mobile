import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jugaenequipo/datasources/models/follow/follow_model.dart';
import 'package:jugaenequipo/datasources/models/follow/follow_user_model.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:jugaenequipo/datasources/models/post/post_model.dart';
import 'package:jugaenequipo/datasources/post_use_cases/get_posts_by_user_use_case.dart';
import 'package:jugaenequipo/datasources/teams_use_cases/search_teams_use_case.dart';
import 'package:jugaenequipo/datasources/user_use_cases/get_followers_use_case.dart';
import 'package:jugaenequipo/datasources/user_use_cases/get_followings_use_case.dart';
import 'package:jugaenequipo/datasources/user_use_cases/get_user_use_case.dart';
import 'package:jugaenequipo/datasources/user_use_cases/follow_user_use_case.dart';
import 'package:jugaenequipo/datasources/user_use_cases/unfollow_user_use_case.dart';
import 'package:jugaenequipo/datasources/user_use_cases/get_user_social_networks_use_case.dart';
import 'package:jugaenequipo/datasources/user_use_cases/get_user_background_image_use_case.dart';
import 'package:jugaenequipo/datasources/user_use_cases/update_user_description_use_case.dart';
import 'package:jugaenequipo/datasources/user_use_cases/add_social_network_use_case.dart';
import 'package:jugaenequipo/datasources/user_use_cases/remove_social_network_use_case.dart';
import 'package:jugaenequipo/presentation/profile/widgets/stats_cards.dart';

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

  // New fields
  List<PostModel> posts = [];
  List<TeamModel> teams = [];
  String? description;
  String? backgroundImage;
  int tournamentWins = 0;
  DateTime? memberSince;
  Map<String, String> socialMedia = {};
  List<SocialNetworkModel> socialNetworks = [];
  List<Map<String, dynamic>> achievements = [];
  List<GameStat> stats = [];

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
        _loadPosts(),
        _loadTeams(),
        _loadSocialNetworks(),
        _loadBackgroundImage(),
      ]);

      // Load description and memberSince from user model
      _loadUserData();
      
      // Load mock data for fields not yet in API
      _loadMockAdditionalData();
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

  Future<void> _loadPosts() async {
    if (profileUser == null) return;

    try {
      final postsResponse = await getPostsByUserId(profileUser!.id);
      if (postsResponse != null) {
        posts = postsResponse;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading posts: $e');
    }
  }

  Future<void> _loadTeams() async {
    if (profileUser == null) return;

    try {
      // Use searchTeams with userId to get teams for this user
      final teamsResponse = await searchTeams(userId: profileUser!.id);
      if (teamsResponse != null) {
        teams = teamsResponse;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading teams: $e');
    }
  }

  Future<void> _loadSocialNetworks() async {
    if (profileUser == null) return;

    try {
      final socialNetworksResponse = await getUserSocialNetworks(profileUser!.id);
      if (socialNetworksResponse != null) {
        socialNetworks = socialNetworksResponse;
        // Convert social networks to Map for compatibility with existing UI
        socialMedia = {
          for (var network in socialNetworksResponse)
            if (network.fullUrl != null) network.name: network.fullUrl!
        };
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading social networks: $e');
    }
  }

  Future<void> _loadBackgroundImage() async {
    if (profileUser == null) return;

    try {
      // First check if backgroundImage is already in user model
      if (profileUser!.backgroundImage != null && profileUser!.backgroundImage!.isNotEmpty) {
        backgroundImage = profileUser!.backgroundImage;
        debugPrint('Background image loaded from user model: $backgroundImage');
        notifyListeners();
        return;
      }
      
      // If not in user model, try to fetch from API
      final bgImage = await getUserBackgroundImage(profileUser!.id);
      if (bgImage != null && bgImage.isNotEmpty) {
        backgroundImage = bgImage;
        debugPrint('Background image loaded from API: $backgroundImage');
        notifyListeners();
      } else {
        debugPrint('No background image found for user ${profileUser!.id}');
      }
    } catch (e) {
      debugPrint('Error loading background image: $e');
    }
  }

  void _loadUserData() {
    if (profileUser == null) return;

    // Load description from user model
    if (profileUser!.description != null) {
      description = profileUser!.description;
    }

    // Load memberSince from user model
    if (profileUser!.createdAt != null) {
      memberSince = profileUser!.createdAt;
    }

    notifyListeners();
  }

  void _loadMockAdditionalData() {
    if (profileUser == null) return;

    // Mock data - these should come from API eventually
    if (description == null) {
      description =
          'Passionate gamer and esports enthusiast. Always looking for new challenges and opportunities to improve.';
    }
    tournamentWins = 12;
    if (memberSince == null) {
      memberSince = DateTime.now().subtract(const Duration(days: 365));
    }

    // Mock achievements
    achievements = [
      {
        'title': 'Tournament Champion',
        'subtitle': 'Valorant Championship 2024',
        'iconCode': 0xe86c, // emoji_events icon code
      },
      {
        'title': 'Elite Player',
        'subtitle': 'Top 100 Players',
        'iconCode': 0xe838, // star icon code
      },
      {
        'title': 'Team Leader',
        'subtitle': 'Led 5 successful teams',
        'iconCode': 0xe7ef, // people icon code
      },
      {
        'title': 'Streamer',
        'subtitle': '1000+ followers',
        'iconCode': 0xe04b, // videocam icon code
      },
    ];

    // Mock stats
    stats = [
      GameStat(
        gameName: 'Overwatch',
        gameImage: 'assets/overwatchLogo.png',
        username: profileUser!.userName,
        rankImage: 'assets/overwatchDiamond.png',
        roles: ['DPS', 'Tank', 'Support'],
      ),
      GameStat(
        gameName: 'CS:GO',
        gameImage: 'assets/cSLogo.png',
        username: '${profileUser!.userName}CS',
        rankImage: 'assets/cSRank.png',
        roles: null,
      ),
    ];

    notifyListeners();
  }

  // Method to refresh data
  Future<void> refreshData() async {
    isLoading = true;
    notifyListeners();
    await _loadData();
  }

  // Update description
  Future<bool> updateDescription(String newDescription) async {
    try {
      final success = await updateUserDescription(newDescription);
      if (success) {
        description = newDescription;
        notifyListeners();
      }
      return success;
    } catch (e) {
      debugPrint('Error updating description: $e');
      return false;
    }
  }

  // Add social network
  Future<bool> addSocialNetworkToUser(String socialNetworkId, String username) async {
    try {
      final success = await addSocialNetwork(socialNetworkId, username);
      if (success) {
        // Reload social networks
        await _loadSocialNetworks();
      }
      return success;
    } catch (e) {
      debugPrint('Error adding social network: $e');
      return false;
    }
  }

  // Remove social network
  Future<bool> removeSocialNetworkFromUser(String socialNetworkId) async {
    try {
      final success = await removeSocialNetwork(socialNetworkId);
      if (success) {
        // Reload social networks
        await _loadSocialNetworks();
      }
      return success;
    } catch (e) {
      debugPrint('Error removing social network: $e');
      return false;
    }
  }
}
