import 'package:flutter/material.dart';
import 'package:jugaenequipo/global_widgets/widgets.dart';
import 'package:jugaenequipo/providers/theme_provider.dart';
import 'package:jugaenequipo/share_preferences/preferences.dart';
import 'package:jugaenequipo/theme/app_theme.dart';

import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const BackAppBar(
          backgroundColor: AppTheme.primary,
          label: 'Settings',
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Consumer<ThemeProvider>(
                  builder: (context, themeProvider, child) {
                    return SwitchListTile.adaptive(
                        activeColor: AppTheme.primary,
                        value: Preferences.isDarkmode,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 10),
                        title: const Text('Darkmode',
                            style: TextStyle(fontSize: 16)),
                        onChanged: (value) {
                          Preferences.isDarkmode = value;

                          value
                              ? themeProvider.setDarkmode()
                              : themeProvider.setLightMode();
                        });
                  },
                ),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Language', style: TextStyle(fontSize: 16)),
                      LanguageDropdown(showLabel: true),
                    ],
                  ),
                ),
                const Divider(),
              ],
            ),
          ),
        ));
  }
}
