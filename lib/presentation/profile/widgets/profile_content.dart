import 'package:flutter/material.dart';
import 'package:jugaenequipo/datasources/models/user_model.dart';
import 'package:jugaenequipo/presentation/profile/business_logic/profile_provider.dart';
import 'package:jugaenequipo/presentation/profile/widgets/widgets.dart';
import 'package:jugaenequipo/providers/user_provider.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:jugaenequipo/share_preferences/preferences.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:jugaenequipo/datasources/chat_use_cases/get_conversation_by_other_user_use_case.dart';
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

class _ProfileContentState extends State<ProfileContent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkIfFollowing();
    });
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
    final profileProvider = Provider.of<ProfileProvider>(context);
    UserModel? loggedUser = Provider.of<UserProvider>(context).user;
    final profileUser = profileProvider.profileUser;
    final isLoggedUser = loggedUser?.id == profileUser?.id;

    if (profileProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (profileUser == null) {
      return Center(child: Text(AppLocalizations.of(context)!.userNotFound));
    }
    return SingleChildScrollView(
      child: Expanded(
        child: Container(
          width: double.infinity,
          color: AppTheme.primary,
          padding: EdgeInsets.only(top: 50.h),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Container(
                padding: EdgeInsets.only(top: 80.h),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Preferences.isDarkmode
                        ? Theme.of(context).colorScheme.surface
                        : Theme.of(context).colorScheme.surface,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                child: Column(children: [
                  Text(
                    '${profileUser.firstName} ${profileUser.lastName}',
                    style:
                        TextStyle(fontSize: 18.h, fontWeight: FontWeight.w900),
                  ),
                  Text(
                    '@${profileUser.userName}',
                    style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity( 0.6),
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
                              .withOpacity( 0.5),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '${AppLocalizations.of(context)!.memberSinceLabel} ${formatTimeElapsed(profileProvider.memberSince!, context)}',
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity( 0.5),
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
                            .withOpacity( 0.5),
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
                              .withOpacity( 0.8),
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
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 12.h),
                      decoration: BoxDecoration(
                        color: AppTheme.success.withOpacity( 0.1),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: AppTheme.success.withOpacity( 0.3),
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        if (isLoggedUser)
                          ProfileElevatedButton(
                            label: AppLocalizations.of(context)!
                                .editProfileButtonLabel,
                            onPressed: () {},
                          )
                        else
                          ProfileElevatedButton(
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
                                    final success =
                                        await profileProvider.toggleFollow();
                                    if (!success && mounted) {
                                      _showErrorDialog(currentContext);
                                    }
                                  },
                          ),
                        if (isLoggedUser)
                          ProfileElevatedButton(
                            label: AppLocalizations.of(context)!
                                .profileMessagesButtonLabel,
                            onPressed: () {},
                          )
                        else
                          ProfileElevatedButton(
                            label: AppLocalizations.of(context)!
                                .profileSendMessageButtonLabel,
                            onPressed: () async {
                              final userId = profileUser.id;
                              final navigator = Navigator.of(context);
                              final conversationId =
                                  await getConversationIdByOtherUser(userId);
                              if (!mounted) return;
                              if (conversationId != null &&
                                  conversationId.isNotEmpty) {
                                navigator.pushNamed('chat', arguments: {
                                  'conversationId': conversationId,
                                  'otherUserName': profileUser.userName,
                                  'otherUserAvatar': profileUser.profileImage,
                                });
                              } else {
                                navigator.pushNamed('chat', arguments: {
                                  'otherUserName': profileUser.userName,
                                  'otherUserAvatar': profileUser.profileImage,
                                });
                              }
                            },
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
                  // Stats Cards (replacing StatsTable)
                  if (profileProvider.stats.isNotEmpty)
                    StatsCards(stats: profileProvider.stats),
                  // Teams Section
                  UserTeamsSection(teams: profileProvider.teams),
                  // Social Media Section
                  if (profileProvider.socialMedia.isNotEmpty)
                    SocialMediaSection(
                        socialLinks: profileProvider.socialMedia),
                  // Achievements Section
                  if (profileProvider.achievements.isNotEmpty)
                    AchievementsSection(
                      achievements: profileProvider.achievements
                          .map((a) => Achievement.fromMap(a))
                          .toList(),
                    ),
                  // Posts Section
                  UserPostsSection(
                    posts: profileProvider.posts,
                    isLoading: profileProvider.isLoading,
                  ),
                  SizedBox(height: 20.h),
                ]),
              ),
              Positioned(
                top: -40.h,
                child: ProfileAvatar(
                  profileUser: profileUser,
                  isLoggedUser: isLoggedUser,
                ),
              )
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
