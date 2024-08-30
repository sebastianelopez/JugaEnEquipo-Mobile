import 'package:flutter/material.dart';
import 'package:jugaenequipo/providers/providers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:country_flags/country_flags.dart';
import 'package:provider/provider.dart';

class LanguageDropdown extends StatelessWidget {
  final bool showLabel;
  final Alignment alignment;

  const LanguageDropdown({
    super.key,
    this.showLabel = true,
    this.alignment = Alignment.centerLeft,
  });

  @override
  Widget build(BuildContext context) {
    final internalization = Provider.of<InternalizationProvider>(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      alignment: alignment,
      child: DropdownMenu(
        width: 85.0,
        initialSelection: AppLocalizations.supportedLocales[1],
        textStyle: const TextStyle(
          color: Colors.red,
        ),
        dropdownMenuEntries:
            AppLocalizations.supportedLocales.asMap().entries.map((entry) {
          final locale = entry.value;
          final index = entry.key;
          return DropdownMenuEntry(
            value: locale,
            label: showLabel ? locale.languageCode.toUpperCase() : '',
            labelWidget: CountryFlag.fromCountryCode(
              internalization.languages[index].countryCode?.toLowerCase() ?? '',
              height: 38,
              width: 62,
              borderRadius: 8,
            ),
            style: const ButtonStyle(
              foregroundColor: MaterialStatePropertyAll(Colors.red),
              textStyle: MaterialStatePropertyAll(
                TextStyle(
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          );
        }).toList(),
        onSelected: (Locale? locale) {
          final internalization =
              Provider.of<InternalizationProvider>(context, listen: false);
          internalization.setLanguage(locale!);
        },
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red, width: 1.0),
            borderRadius: BorderRadius.circular(8.0),
          ),
          contentPadding: const EdgeInsets.only(left: 9.0),
        ),
      ),
    );
  }
}
