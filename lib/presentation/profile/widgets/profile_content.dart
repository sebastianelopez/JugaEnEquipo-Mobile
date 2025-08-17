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

class ProfileContent extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    UserModel? user = Provider.of<UserProvider>(context).user;
    final profileUser = profileProvider.profileUser;
    final isLoggedUser = user?.id == profileUser?.id;

    if (profileProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (user == null) {
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
                    '${user.firstName} ${user.lastName}',
                    style:
                        TextStyle(fontSize: 18.h, fontWeight: FontWeight.w900),
                  ),
                  Text(
                    '@${user.userName}',
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
                        ProfileElevatedButton(
                          label: AppLocalizations.of(context)!
                              .profileMessagesButtonLabel,
                          onPressed: () {},
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
                            onTap: onFollowingsPressed,
                          ),
                        ),
                        Expanded(
                          child: NumberAndLabel(
                            label: AppLocalizations.of(context)!
                                .profileFollowersButtonLabel,
                            number: profileProvider.numberOfFollowers,
                            hasRightBorder: true,
                            onTap: onFollowersPressed,
                          ),
                        ),
                        Expanded(
                          child: NumberAndLabel(
                              label: AppLocalizations.of(context)!
                                  .profilePrizesButtonLabel,
                              number: 124,
                              onTap: onPrizesPressed),
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
                  profileUser: user,
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
