import 'package:flutter/foundation.dart';
import 'package:jugaenequipo/datasources/models/follow/follow_model.dart';
import 'package:jugaenequipo/datasources/models/follow/follow_user_model.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
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
import 'package:jugaenequipo/datasources/player_use_cases/get_players_by_user_id_use_case.dart';
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
  List<PlayerModel> playerProfiles = [];

  // Loading states for secondary data
  bool isLoadingPosts = false;
  bool isLoadingTeams = false;
  bool isLoadingSocialNetworks = false;
  bool isLoadingBackgroundImage = false;
  bool isLoadingPlayerProfiles = false;

  ProfileProvider({
    this.userId,
    this.initialUser,
  }) {
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      // Step 1: Load critical user data first
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

      // Load description and memberSince from user model immediately
      _loadUserData();

      // Load mock data for fields not yet in API
      _loadMockAdditionalData();

      // Step 2: Load essential counts first (for UI display)
      await Future.wait([
        _loadFollowings(),
        _loadFollowers(),
      ]);

      // Step 3: Mark as loaded so UI can render
      isLoading = false;
      notifyListeners();

      // Step 4: Load secondary data asynchronously (non-blocking)
      _loadSecondaryData();
    } catch (e) {
      error = 'Error: ${e.toString()}';
      debugPrint('Error loading profile: $e');
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadSecondaryData() async {
    // Load these in background without blocking UI
    // Don't wait for all, let them load independently
    _loadPosts();
    _loadTeams();
    _loadSocialNetworks();
    _loadBackgroundImage();
    _loadPlayerProfiles();
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

    // Don't block UI, check in background
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

    isLoadingPosts = true;
    notifyListeners();

    try {
      if (kDebugMode) {
        debugPrint(
            'ProfileProvider: Loading posts for user ${profileUser!.id}');
      }
      final postsResponse = await getPostsByUserId(profileUser!.id);
      if (kDebugMode) {
        debugPrint(
            'ProfileProvider: Posts response: ${postsResponse?.length ?? 0} posts');
      }
      if (postsResponse != null) {
        posts = postsResponse;
        if (kDebugMode) {
          debugPrint(
              'ProfileProvider: Posts loaded successfully: ${posts.length}');
        }
      } else {
        if (kDebugMode) {
          debugPrint('ProfileProvider: Posts response was null');
        }
      }
    } catch (e) {
      debugPrint('Error loading posts: $e');
    } finally {
      isLoadingPosts = false;
      notifyListeners();
    }
  }

  Future<void> _loadTeams() async {
    if (profileUser == null) return;

    isLoadingTeams = true;
    notifyListeners();

    try {
      // Use searchTeams with userId to get teams for this user
      final teamsResponse = await searchTeams(userId: profileUser!.id);
      if (teamsResponse != null) {
        teams = teamsResponse;
      }
    } catch (e) {
      debugPrint('Error loading teams: $e');
    } finally {
      isLoadingTeams = false;
      notifyListeners();
    }
  }

  Future<void> _loadSocialNetworks() async {
    if (profileUser == null) return;

    isLoadingSocialNetworks = true;
    notifyListeners();

    try {
      final socialNetworksResponse =
          await getUserSocialNetworks(profileUser!.id);
      if (socialNetworksResponse != null) {
        socialNetworks = socialNetworksResponse;
        // Convert social networks to Map for compatibility with existing UI
        socialMedia = {
          for (var network in socialNetworksResponse)
            if (network.fullUrl != null) network.name: network.fullUrl!
        };
      }
    } catch (e) {
      debugPrint('Error loading social networks: $e');
    } finally {
      isLoadingSocialNetworks = false;
      notifyListeners();
    }
  }

  Future<void> _loadBackgroundImage() async {
    if (profileUser == null) return;

    isLoadingBackgroundImage = true;
    notifyListeners();

    try {
      // First check if backgroundImage is already in user model
      if (profileUser!.backgroundImage != null &&
          profileUser!.backgroundImage!.isNotEmpty) {
        backgroundImage = profileUser!.backgroundImage;
        debugPrint('Background image loaded from user model: $backgroundImage');
        isLoadingBackgroundImage = false;
        notifyListeners();
        return;
      }

      // If not in user model, try to fetch from API
      final bgImage = await getUserBackgroundImage(profileUser!.id);
      if (bgImage != null && bgImage.isNotEmpty) {
        backgroundImage = bgImage;
        debugPrint('Background image loaded from API: $backgroundImage');
      } else {
        debugPrint('No background image found for user ${profileUser!.id}');
      }
    } catch (e) {
      debugPrint('Error loading background image: $e');
    } finally {
      isLoadingBackgroundImage = false;
      notifyListeners();
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
    description ??=
        'Passionate gamer and esports enthusiast. Always looking for new challenges and opportunities to improve.';
    tournamentWins = 12;
    memberSince ??= DateTime.now().subtract(const Duration(days: 365));

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
    stats = [];

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
  Future<bool> addSocialNetworkToUser(
      String socialNetworkId, String username) async {
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

  Future<void> _loadPlayerProfiles() async {
    if (profileUser == null) return;

    isLoadingPlayerProfiles = true;
    notifyListeners();

    try {
      final playersResponse = await getPlayersByUserId(profileUser!.id);
      if (playersResponse != null) {
        playerProfiles = playersResponse;
      }
    } catch (e) {
      debugPrint('Error loading player profiles: $e');
    } finally {
      isLoadingPlayerProfiles = false;
      notifyListeners();
    }
  }

  // Refresh player profiles only
  Future<void> refreshPlayerProfiles() async {
    await _loadPlayerProfiles();
  }
}
