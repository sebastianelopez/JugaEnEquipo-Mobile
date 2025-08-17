import 'package:flutter/material.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';

const int secondsPerMinute = 60;
const int minutesPerHour = 60;
const int hoursPerDay = 24;
const int daysPerWeek = 7;
const int daysPerMonth = 30;
const int daysPerYear = 365;

String formatTimeElapsed(DateTime date, BuildContext context) {
  final now = DateTime.now();
  final difference = now.difference(date);

  if (difference.inDays >= daysPerYear) {
    final years = (difference.inDays / daysPerYear).floor();
    return '${AppLocalizations.of(context)!.timePrefixText}$years ${years > 1 ? AppLocalizations.of(context)!.timeYearsSuffixText : AppLocalizations.of(context)!.timeYearSuffixText}';
  } else if (difference.inDays >= daysPerMonth) {
    final months = (difference.inDays / daysPerMonth).floor();
    return '${AppLocalizations.of(context)!.timePrefixText}$months ${months > 1 ? AppLocalizations.of(context)!.timeMonthsSuffixText : AppLocalizations.of(context)!.timeMonthSuffixText}';
  } else if (difference.inDays >= daysPerWeek) {
    final weeks = (difference.inDays / daysPerWeek).floor();
    return '${AppLocalizations.of(context)!.timePrefixText}$weeks ${weeks > 1 ? AppLocalizations.of(context)!.timeWeeksSuffixText : AppLocalizations.of(context)!.timeWeekSuffixText}';
  } else if (difference.inDays >= 1) {
    return '${AppLocalizations.of(context)!.timePrefixText}${difference.inDays} ${difference.inDays > 1 ? AppLocalizations.of(context)!.timeDaysSuffixText : AppLocalizations.of(context)!.timeDaySuffixText}';
  } else if (difference.inHours >= 1) {
    return '${AppLocalizations.of(context)!.timePrefixText}${difference.inHours} ${difference.inHours > 1 ? AppLocalizations.of(context)!.timeHoursSuffixText : AppLocalizations.of(context)!.timeHourSuffixText}';
  } else if (difference.inMinutes >= 1) {
    return '${AppLocalizations.of(context)!.timePrefixText}${difference.inMinutes} ${difference.inMinutes > 1 ? AppLocalizations.of(context)!.timeMinutesSuffixText : AppLocalizations.of(context)!.timeMinuteSuffixText}';
  } else {
    return '${AppLocalizations.of(context)!.timePrefixText}${difference.inSeconds} ${difference.inSeconds > 1 ? AppLocalizations.of(context)!.timeSecondsSuffixText : AppLocalizations.of(context)!.timeSecondSuffixText}';
  }
}
