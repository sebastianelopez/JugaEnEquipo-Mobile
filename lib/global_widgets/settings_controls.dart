import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jugaenequipo/global_widgets/widgets.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';
import 'package:jugaenequipo/providers/theme_provider.dart';
import 'package:jugaenequipo/share_preferences/preferences.dart';
import 'package:provider/provider.dart';

class SettingsControls extends StatelessWidget {
  const SettingsControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Theme Toggle
        Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return IconButton(
              icon: Icon(
                Preferences.isDarkmode ? Icons.dark_mode : Icons.light_mode,
                size: 20.sp,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withOpacity(0.6),
              ),
              tooltip: AppLocalizations.of(context)!.darkmodeLabel,
              onPressed: () {
                final newValue = !Preferences.isDarkmode;
                Preferences.isDarkmode = newValue;
                newValue
                    ? themeProvider.setDarkmode()
                    : themeProvider.setLightMode();
              },
            );
          },
        ),
        SizedBox(width: 8.w),
        // Language Selector
        Tooltip(
          message: AppLocalizations.of(context)!.drawerlanguageLabel,
          child: LanguageDropdown(
            showLabel: false,
            alignment: Alignment.center,
          ),
        ),
      ],
    );
  }
}

