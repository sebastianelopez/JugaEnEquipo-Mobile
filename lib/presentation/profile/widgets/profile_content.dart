import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jugaenequipo/datasources/models/user_model.dart';
import 'package:jugaenequipo/presentation/profile/business_logic/profile_provider.dart';
import 'package:jugaenequipo/presentation/home/business_logic/home_screen_provider.dart';
import 'package:jugaenequipo/presentation/profile/widgets/widgets.dart';
import 'package:jugaenequipo/providers/user_provider.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:jugaenequipo/share_preferences/preferences.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:jugaenequipo/datasources/chat_use_cases/get_conversation_by_other_user_use_case.dart';
import 'package:jugaenequipo/presentation/profile/screens/edit_profile_screen.dart';
import 'package:jugaenequipo/utils/utils.dart';

class ProfileContent extends StatefulWidget {
  final VoidCallback? onFollowersPressed;
  final VoidCallback? onFollowingsPressed;
  final VoidCallback? onPrizesPressed;

  const ProfileContent({
    super.key,
    this.onFollowersPressed,
    this.onFollowingsPressed,
    this.onPrizesPressed,
  });

  @override
  State<ProfileContent> createState() => _ProfileContentState();
}

class _ProfileContentState extends State<ProfileContent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  HomeScreenProvider? _homeScreenProvider;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkIfFollowing();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _homeScreenProvider?.dispose();
    super.dispose();
  }

  HomeScreenProvider _getHomeScreenProvider() {
    _homeScreenProvider ??= HomeScreenProvider(context: context);
    return _homeScreenProvider!;
  }

  void _checkIfFollowing() {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    final loggedUser = Provider.of<UserProvider>(context, listen: false).user;

    if (loggedUser != null && profileProvider.profileUser != null) {
      profileProvider.checkIfFollowing(loggedUser);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context, listen: true);
    UserModel? loggedUser =
        Provider.of<UserProvider>(context, listen: false).user;
    final profileUser = profileProvider.profileUser;
    final isLoggedUser = loggedUser?.id == profileUser?.id;

    // Debug: Print background image status
    if (kDebugMode) {
      debugPrint(
          'ProfileContent build - backgroundImage: ${profileProvider.backgroundImage}');
      debugPrint(
          'ProfileContent build - profileUser.backgroundImage: ${profileUser?.backgroundImage}');
    }

    if (profileProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (profileUser == null) {
      return Center(child: Text(AppLocalizations.of(context)!.userNotFound));
    }
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          // Background Image - Check both provider and user model
          Builder(
            builder: (context) {
              final bgImage = profileProvider.backgroundImage ??
                  profileUser.backgroundImage;

              if (bgImage != null && bgImage.isNotEmpty) {
                if (kDebugMode) {
                  debugPrint('Rendering background image: $bgImage');
                }
                return Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 250.h,
                  child: _buildBackgroundImage(bgImage),
                );
              } else {
                // Default background if no image
                return Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 250.h,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppTheme.primary,
                          AppTheme.primary.withOpacity(0.8),
                        ],
                      ),
                    ),
                  ),
                );
              }
            },
          ),
          SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Container(
              margin: EdgeInsets.only(top: 150.h),
              padding: EdgeInsets.only(top: 0.h),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Preferences.isDarkmode
                      ? Theme.of(context).colorScheme.surface
                      : Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: Column(children: [
                // Avatar positioned at the top of scrollable content, partially overlapping background
                Transform.translate(
                  offset: Offset(0, -50.h),
                  child: ProfileAvatar(
                    profileUser: profileUser,
                    isLoggedUser: isLoggedUser,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  '${profileUser.firstName} ${profileUser.lastName}',
                  style: TextStyle(fontSize: 18.h, fontWeight: FontWeight.w900),
                ),
                Text(
                  '@${profileUser.userName}',
                  style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.6),
                      fontSize: 14.h),
                ),
                // Member since
                if (profileProvider.memberSince != null) ...[
                  SizedBox(height: 4.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 12.h,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.5),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '${AppLocalizations.of(context)!.memberSinceLabel} ${formatTimeElapsed(profileProvider.memberSince!, context)}',
                        style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.5),
                          fontSize: 11.h,
                        ),
                      ),
                    ],
                  ),
                ],
                // Description (About me)
                if (profileProvider.description != null &&
                    profileProvider.description!.isNotEmpty) ...[
                  SizedBox(height: 12.h),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.w),
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .surface
                          .withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      profileProvider.description!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13.h,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.8),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
                // Tournament wins
                if (profileProvider.tournamentWins > 0) ...[
                  SizedBox(height: 12.h),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.w),
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      color: AppTheme.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: AppTheme.success.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.emoji_events,
                          color: AppTheme.success,
                          size: 20.h,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          '${profileProvider.tournamentWins} ${AppLocalizations.of(context)!.tournamentWinsLabel}',
                          style: TextStyle(
                            fontSize: 14.h,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.success,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                Container(
                  margin: EdgeInsets.only(top: 15.h),
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(right: 8.w),
                          child: isLoggedUser
                              ? ProfileElevatedButton(
                                  label: AppLocalizations.of(context)!
                                      .editProfileButtonLabel,
                                  onPressed: () {
                                    final userId = profileUser.id;
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EditProfileScreen(userId: userId),
                                      ),
                                    ).then((_) {
                                      // Refresh profile data when returning from edit screen
                                      profileProvider.refreshData();
                                    });
                                  },
                                )
                              : ProfileElevatedButton(
                                  label: profileProvider.isFollowLoading
                                      ? '...'
                                      : (profileProvider.isFollowing
                                          ? AppLocalizations.of(context)!
                                              .profileUnfollowButtonLabel
                                          : AppLocalizations.of(context)!
                                              .profileFollowButtonLabel),
                                  onPressed: profileProvider.isFollowLoading
                                      ? null
                                      : () async {
                                          final currentContext = context;
                                          final success = await profileProvider
                                              .toggleFollow();
                                          if (!success && context.mounted) {
                                            _showErrorDialog(currentContext);
                                          }
                                        },
                                ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 8.w),
                          child: isLoggedUser
                              ? ProfileElevatedButton(
                                  label: AppLocalizations.of(context)!
                                      .profileMessagesButtonLabel,
                                  onPressed: () {},
                                )
                              : ProfileElevatedButton(
                                  label: AppLocalizations.of(context)!
                                      .profileSendMessageButtonLabel,
                                  onPressed: () async {
                                    final userId = profileUser.id;
                                    final navigator = Navigator.of(context);
                                    final conversationId =
                                        await getConversationIdByOtherUser(
                                            userId);
                                    if (!mounted) return;
                                    if (conversationId != null &&
                                        conversationId.isNotEmpty) {
                                      navigator.pushNamed('chat', arguments: {
                                        'conversationId': conversationId,
                                        'otherUserName': profileUser.userName,
                                        'otherUserAvatar':
                                            profileUser.profileImage,
                                      });
                                    } else {
                                      navigator.pushNamed('chat', arguments: {
                                        'otherUserName': profileUser.userName,
                                        'otherUserAvatar':
                                            profileUser.profileImage,
                                      });
                                    }
                                  },
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 15.h, bottom: 15.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: NumberAndLabel(
                          label: AppLocalizations.of(context)!
                              .profileFollowingButtonLabel,
                          number: profileProvider.numberOfFollowings,
                          hasRightBorder: true,
                          onTap: widget.onFollowingsPressed,
                        ),
                      ),
                      Expanded(
                        child: NumberAndLabel(
                          label: AppLocalizations.of(context)!
                              .profileFollowersButtonLabel,
                          number: profileProvider.numberOfFollowers,
                          hasRightBorder: true,
                          onTap: widget.onFollowersPressed,
                        ),
                      ),
                      Expanded(
                        child: NumberAndLabel(
                            label: AppLocalizations.of(context)!
                                .profilePrizesButtonLabel,
                            number: profileProvider.tournamentWins,
                            onTap: widget.onPrizesPressed),
                      ),
                    ],
                  ),
                ),
                // Tabs
                SizedBox(height: 16.h),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.w),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .outline
                          .withOpacity(0.1),
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: TabBar(
                    controller: _tabController,
                    labelColor: AppTheme.primary,
                    unselectedLabelColor: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6),
                    indicatorWeight: 4,
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    indicator: UnderlineTabIndicator(
                      borderSide: BorderSide(
                        color: AppTheme.primary,
                        width: 4,
                      ),
                      insets: EdgeInsets.zero,
                    ),
                    tabs: [
                      Tab(
                        icon: Icon(Icons.article_outlined, size: 20.w),
                        text: AppLocalizations.of(context)!.profileTabPosts,
                      ),
                      Tab(
                        icon: Icon(Icons.info_outline, size: 20.w),
                        text: AppLocalizations.of(context)!.profileTabInfo,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                // Tab Content - conditional based on selected tab
                _tabController.index == 0
                    ? _buildPostsTab(profileProvider)
                    : _buildInfoTab(profileProvider),
                SizedBox(height: 20.h),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostsTab(ProfileProvider provider) {
    return ChangeNotifierProvider.value(
      value: _getHomeScreenProvider(),
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            UserPostsSection(
              posts: provider.posts,
              isLoading: provider.isLoading,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTab(ProfileProvider provider) {
    final loggedUser = Provider.of<UserProvider>(context, listen: false).user;
    final profileUser = provider.profileUser;
    final isOwnProfile = loggedUser?.id == profileUser?.id;

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        children: [
          // Player Profiles Section
          PlayerProfilesSection(
            playerProfiles: provider.playerProfiles,
            isOwnProfile: isOwnProfile,
            onProfileChanged: () {
              provider.refreshPlayerProfiles();
            },
          ),
          // Stats Cards
          if (provider.stats.isNotEmpty) StatsCards(stats: provider.stats),
          // Teams Section
          UserTeamsSection(teams: provider.teams),
          // Social Media Section
          if (provider.socialMedia.isNotEmpty)
            SocialMediaSection(socialLinks: provider.socialMedia),
          // Achievements Section
          if (provider.achievements.isNotEmpty)
            AchievementsSection(
              achievements: provider.achievements
                  .map((a) => Achievement.fromMap(a))
                  .toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildBackgroundImage(String imageUrl) {
    final isNetworkImage =
        imageUrl.startsWith('http://') || imageUrl.startsWith('https://');

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: isNetworkImage
              ? NetworkImage(imageUrl)
              : const AssetImage('assets/login.png') as ImageProvider,
          fit: BoxFit.cover,
          onError: (exception, stackTrace) {
            if (kDebugMode) {
              debugPrint('Error loading background image: $exception');
            }
          },
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.3),
            ],
          ),
        ),
      ),
    );
  }

  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.errorTitle),
          content: Text(AppLocalizations.of(context)!.errorMessage),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context)!.okButton),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
