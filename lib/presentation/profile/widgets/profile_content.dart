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
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    UserModel? loggedUser = Provider.of<UserProvider>(context).user;
    final profileUser = profileProvider.profileUser;
    final isLoggedUser = loggedUser?.id == profileUser?.id;

    if (profileProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (profileUser == null) {
      return const Center(child: Text('User not found'));
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
                            .withValues(alpha: 0.6),
                        fontSize: 14.h),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        if (isLoggedUser)
                          ProfileElevatedButton(
                            label: 'Editar perfil',
                            onPressed: () {},
                          )
                        else
                          ProfileElevatedButton(
                            label: AppLocalizations.of(context)!
                                .profileFollowButtonLabel,
                            onPressed: () {},
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
                                });
                              } else {
                                navigator.pushNamed('chat');
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
                              number: 124,
                              onTap: widget.onPrizesPressed),
                        ),
                      ],
                    ),
                  ),
                  const StatsTable(),
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
}
