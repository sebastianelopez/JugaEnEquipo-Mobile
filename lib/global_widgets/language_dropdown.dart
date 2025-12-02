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
    final flagSize = showLabel ? 38.0 : 24.0;
    final flagWidth = showLabel ? 62.0 : 40.0;
    return Container(
      padding: EdgeInsets.symmetric(vertical: showLabel ? 10.0.h : 4.0.h),
      alignment: alignment,
      child: SizedBox(
        width: 80.0.h,
        child: DropdownMenu(
          initialSelection: AppLocalizations.supportedLocales[1],
          textStyle: TextStyle(
            color: AppTheme.primary,
            fontSize: showLabel ? null : 12.sp,
          ),
          leadingIcon: showLabel
              ? null
              : Icon(
                  Icons.language,
                  size: 18.sp,
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
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
                  height: flagSize,
                  width: flagWidth,
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
              borderSide: BorderSide(
                color: AppTheme.primary.withOpacity(showLabel ? 1.0 : 0.5),
                width: showLabel ? 1.0.w : 0.5.w,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            contentPadding: EdgeInsets.only(
              left: showLabel ? 9.0.w : 8.0.w,
              top: showLabel ? 8.0.w : 4.0.w,
              bottom: showLabel ? 8.0.w : 4.0.w,
            ),
          ),
        ),
      ),
    );
  }
}
