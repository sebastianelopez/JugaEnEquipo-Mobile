import 'package:flutter/material.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:jugaenequipo/presentation/profile/widgets/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:jugaenequipo/providers/user_provider.dart';
import 'package:jugaenequipo/share_preferences/preferences.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:jugaenequipo/global_widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserModel? user = Provider.of<UserProvider>(context).user;

    return Scaffold(
        backgroundColor: AppTheme.primary,
        appBar: BackAppBar(
          label: AppLocalizations.of(context)!.profilePageLabel,
        ),
        body: SingleChildScrollView(
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
                        '${user!.firstName} ${user.lastName}',
                        style: TextStyle(
                            fontSize: 18.h, fontWeight: FontWeight.w900),
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
                                number: 1234,
                                hasRightBorder: true,
                              ),
                            ),
                            Expanded(
                              child: NumberAndLabel(
                                  label: AppLocalizations.of(context)!
                                      .profileFollowersButtonLabel,
                                  number: 234,
                                  hasRightBorder: true),
                            ),
                            Expanded(
                              child: NumberAndLabel(
                                  label: AppLocalizations.of(context)!
                                      .profilePrizesButtonLabel,
                                  number: 124),
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
                      profileImage: user.profileImage!,
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
