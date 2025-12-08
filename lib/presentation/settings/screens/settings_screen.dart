import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jugaenequipo/datasources/user_use_cases/delete_user_account_use_case.dart';
import 'package:jugaenequipo/global_widgets/widgets.dart';
import 'package:jugaenequipo/presentation/settings/screens/change_password_screen.dart';
import 'package:jugaenequipo/providers/providers.dart';
import 'package:jugaenequipo/providers/theme_provider.dart';
import 'package:jugaenequipo/share_preferences/preferences.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
        appBar: BackAppBar(
          backgroundColor: AppTheme.primary,
          label: l10n.settingsLabel,
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
                        trackColor: WidgetStateProperty.all(AppTheme.primary),
                        value: Preferences.isDarkmode,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 10),
                        title: Text(l10n.darkmodeLabel,
                            style: const TextStyle(fontSize: 16)),
                        onChanged: (value) {
                          Preferences.isDarkmode = value;

                          value
                              ? themeProvider.setDarkmode()
                              : themeProvider.setLightMode();
                        });
                  },
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l10n.languageLabel,
                          style: const TextStyle(fontSize: 16)),
                      const LanguageDropdown(showLabel: true),
                    ],
                  ),
                ),
                const Divider(),
                // Account Section
                ListTile(
                  leading: const Icon(Icons.lock),
                  title: Text(l10n.changePasswordTitle),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChangePasswordScreen(),
                      ),
                    );
                  },
                ),
                const Divider(),
                // Danger Zone
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    l10n.dangerZone,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.delete_forever, color: Colors.red),
                  title: Text(l10n.deleteAccount,
                      style: const TextStyle(color: Colors.red)),
                  onTap: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(l10n.deleteAccount),
                        content: Text(
                          l10n.deleteAccountConfirmation,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: Text(l10n.cancel),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            style: TextButton.styleFrom(
                                foregroundColor: Colors.red),
                            child: Text(l10n.delete),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      if (!context.mounted) return;
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );

                      try {
                        final success = await deleteUserAccount();
                        if (context.mounted) {
                          Navigator.pop(context); // Close loading dialog
                          if (success) {
                            // Clear user data and navigate to login
                            final userProvider = Provider.of<UserProvider>(
                                context,
                                listen: false);
                            userProvider.clearUser();
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              'login',
                              (route) => false,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text(l10n.accountDeletedSuccessfully)),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(l10n.failedToDeleteAccount)),
                            );
                          }
                        }
                      } catch (e) {
                        if (context.mounted) {
                          Navigator.pop(context); // Close loading dialog
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${l10n.errorMessage}: $e')),
                          );
                        }
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
