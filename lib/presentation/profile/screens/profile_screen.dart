import 'package:flutter/material.dart';
import 'package:jugaenequipo/presentation/profile/widgets/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:jugaenequipo/global_widgets/widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.primary,
        appBar: PreferredSize(
            preferredSize: const Size(double.infinity, 40),
            child: BackAppBar(
              label: AppLocalizations.of(context)!.profilePageLabel,
            )),
        body: SingleChildScrollView(
          child: Expanded(
            child: Container(
              width: double.infinity,
              color: AppTheme.primary,
              padding: const EdgeInsets.only(top: 30),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 80),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30))),
                    child: Column(children: [
                      const Text(
                        "Sebastian Lopez",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w900),
                      ),
                      const Text(
                        "@sel.tsx",
                        style: TextStyle(color: Colors.grey),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 15),
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
                        margin: const EdgeInsets.only(top: 15, bottom: 15),
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
                      Container(child: const StatsTable())
                    ]),
                  ),
                  const Positioned(
                    top: -40,
                    child: ProfileAvatar(),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}


