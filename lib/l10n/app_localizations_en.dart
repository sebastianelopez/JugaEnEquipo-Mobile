// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get loginButton => 'Log in';

  @override
  String get loginCreateAccountButton => 'Create a new account';

  @override
  String get loginUserHintText => 'User';

  @override
  String get loginPasswordHintText => 'Password';

  @override
  String get loginPasswordValidation =>
      'The password must be at least six characters';

  @override
  String get loginUserValidation =>
      'The entered value doesn\'t look like an email';

  @override
  String get loginUserRequiredValidation => 'Email is required';

  @override
  String get navSearchInputLabel => 'Search';

  @override
  String get timePrefixText => '';

  @override
  String get timeYearSuffixText => 'year ago';

  @override
  String get timeYearsSuffixText => 'years ago';

  @override
  String get timeMonthSuffixText => 'month ago';

  @override
  String get timeMonthsSuffixText => 'months ago';

  @override
  String get timeWeekSuffixText => 'week ago';

  @override
  String get timeWeeksSuffixText => 'weeks ago';

  @override
  String get timeDaySuffixText => 'day ago';

  @override
  String get timeDaysSuffixText => 'days ago';

  @override
  String get timeHourSuffixText => 'hour ago';

  @override
  String get timeHoursSuffixText => 'hours ago';

  @override
  String get timeMinuteSuffixText => 'minute ago';

  @override
  String get timeMinutesSuffixText => 'minutes ago';

  @override
  String get timeSecondSuffixText => 'second ago';

  @override
  String get timeSecondsSuffixText => 'seconds ago';

  @override
  String get drawerlanguageLabel => 'Language';

  @override
  String get drawerProfileLabel => 'Profile';

  @override
  String get drawerSettingsLabel => 'Settings';

  @override
  String get drawerLogoutLabel => 'Sign out';

  @override
  String get profilePageLabel => 'Profile';

  @override
  String get profileFollowButtonLabel => 'Follow';

  @override
  String get profileMessagesButtonLabel => 'Messages';

  @override
  String get profileFollowingButtonLabel => 'Following';

  @override
  String get profileFollowersButtonLabel => 'Followers';

  @override
  String get profilePrizesButtonLabel => 'Prizes';

  @override
  String get messagesPageLabel => 'Messages';

  @override
  String get commentsModalLabel => 'Comments';

  @override
  String get notificationsPageLabel => 'Notifications';

  @override
  String notificationPostLiked(String name) {
    return '<b>$name</b> liked your post.';
  }

  @override
  String notificationInviteToTeam(String name, String team) {
    return '<b>$name</b> has invited you to to join <b>$team</b> team.';
  }

  @override
  String notificationApplicationAccepted(String role, String team) {
    return '<b>$team</b> has accepted your application for the $role position in Overwatch. You are now a member of the professional team.';
  }
}
