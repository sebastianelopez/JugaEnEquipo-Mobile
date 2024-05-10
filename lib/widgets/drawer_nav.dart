import 'package:flutter/material.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:jugaenequipo/widgets/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:jugaenequipo/router/app_routes.dart';

class DrawerNav extends StatelessWidget {
  const DrawerNav({super.key});

  @override
  Widget build(BuildContext context) {
    final drawerOptions = AppRoutes.getDrawerOptions(context).toList();

    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: AppTheme.primary,
              image: DecorationImage(
                image: NetworkImage(
                  "https://static.wikia.nocookie.net/onepiece/images/a/af/Monkey_D._Luffy_Anime_Dos_A%C3%B1os_Despu%C3%A9s_Infobox.png/revision/latest?cb=20200616015904&path-prefix=es",
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  bottom: 8.0,
                  left: 4.0,
                  child: Text(
                    "Usuario",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900),
                  ),
                )
              ],
            ),
          ),
          ...drawerOptions.map((option) {
            return ListTile(
              title: Text(option.name,
                  style: const TextStyle(fontWeight: FontWeight.w900)),
              onTap: () {
                //hide keyboard
                FocusScope.of(context).unfocus();
                Navigator.pushNamed(context, option.route);
              },
            );
          }),
          Row(
            children: [
              Container(
                  margin: const EdgeInsets.only(right: 30.0, left: 15.0),
                  child: Text(AppLocalizations.of(context)!.drawerlanguageLabel,
                      style: const TextStyle(fontWeight: FontWeight.w900))),
              const LanguageDropdown(showLabel: true),
            ],
          ),
        ],
      ),
    );
  }
}
