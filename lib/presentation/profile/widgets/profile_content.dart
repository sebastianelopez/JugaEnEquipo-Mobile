import 'package:flutter/material.dart';
import 'package:jugaenequipo/presentation/profile/business_logic/profile_provider.dart';
import 'package:jugaenequipo/presentation/profile/widgets/widgets.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:jugaenequipo/share_preferences/preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ProfileContent extends StatelessWidget {
  const ProfileContent({super.key});

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final user = profileProvider.profileUser; // Get user from provider

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
                        ? Colors.grey[900]
                        : Colors.white,
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
                    style: TextStyle(color: Colors.grey, fontSize: 14.h),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
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
                            onTap: () =>
                                profileProvider.openModal(ModalType.followings),
                          ),
                        ),
                        Expanded(
                          child: NumberAndLabel(
                              label: AppLocalizations.of(context)!
                                  .profileFollowersButtonLabel,
                              number: profileProvider.numberOfFollowers,
                              hasRightBorder: true,
                              onTap: () => profileProvider
                                  .openModal(ModalType.followers)),
                        ),
                        Expanded(
                          child: NumberAndLabel(
                              label: AppLocalizations.of(context)!
                                  .profilePrizesButtonLabel,
                              number: 124,
                              onTap: () =>
                                  profileProvider.openModal(ModalType.prizes)),
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
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
