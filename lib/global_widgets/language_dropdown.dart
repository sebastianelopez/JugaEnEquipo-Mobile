import 'package:flutter/material.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:jugaenequipo/providers/providers.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';
import 'package:country_flags/country_flags.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      padding: EdgeInsets.symmetric(vertical: 10.0.h),
      alignment: alignment,
      child: DropdownMenu(
        width: 80.0.h,
        initialSelection: AppLocalizations.supportedLocales[1],
        textStyle: const TextStyle(
          color: AppTheme.primary,
        ),
        dropdownMenuEntries:
            AppLocalizations.supportedLocales.asMap().entries.map((entry) {
          final locale = entry.value;
          final index = entry.key;
          return DropdownMenuEntry(
            value: locale,
            label: showLabel ? locale.languageCode.toUpperCase() : '',
            labelWidget: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CountryFlag.fromCountryCode(
                internalization.languages[index].countryCode?.toLowerCase() ??
                    '',
                height: 38,
                width: 62,
              ),
            ),
            style: const ButtonStyle(
              foregroundColor: WidgetStatePropertyAll(AppTheme.primary),
              textStyle: WidgetStatePropertyAll(
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
            borderSide: BorderSide(color: AppTheme.primary, width: 1.0.w),
            borderRadius: BorderRadius.circular(8.0),
          ),
          contentPadding:
              EdgeInsets.only(left: 9.0.w, top: 8.0.w, bottom: 8.0.w),
        ),
      ),
    );
  }
}
