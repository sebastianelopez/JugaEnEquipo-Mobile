import 'package:flutter/material.dart';
import 'package:jugaenequipo/providers/providers.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class DrawerNav extends StatelessWidget {
  const DrawerNav({super.key});

  @override
  Widget build(BuildContext context) {
    final internalization = Provider.of<InternalizationProvider>(context);

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
          ListTile(
            title: const Text('Perfil'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          DropdownButton(
            value: internalization.currentlanguage.languageCode,
            icon: const Icon(Icons.arrow_downward),
            elevation: 16,
            style: const TextStyle(color: Colors.deepPurple),
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
            onChanged: (_) {},
            items: AppLocalizations.supportedLocales.map((Locale locale) {
              return DropdownMenuItem(
                value: locale.languageCode,
                onTap: () {
                  final internalization = Provider.of<InternalizationProvider>(
                      context,
                      listen: false);
                  internalization.setLanguage(locale);
                },
                child: Center(child: Text(locale.languageCode)),
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}
