import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('pt')
  ];

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get loginButton;

  /// No description provided for @loginCreateAccountButton.
  ///
  /// In en, this message translates to:
  /// **'Create a new account'**
  String get loginCreateAccountButton;

  /// No description provided for @loginUserHintText.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get loginUserHintText;

  /// No description provided for @loginPasswordHintText.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPasswordHintText;

  /// No description provided for @loginPasswordValidation.
  ///
  /// In en, this message translates to:
  /// **'The password must be at least six characters'**
  String get loginPasswordValidation;

  /// No description provided for @loginUserValidation.
  ///
  /// In en, this message translates to:
  /// **'The entered value doesn\'t look like an email'**
  String get loginUserValidation;

  /// No description provided for @loginUserRequiredValidation.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get loginUserRequiredValidation;

  /// No description provided for @navSearchInputLabel.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get navSearchInputLabel;

  /// No description provided for @advancedSearchTitle.
  ///
  /// In en, this message translates to:
  /// **'Advanced search'**
  String get advancedSearchTitle;

  /// No description provided for @advancedSearchPlayersButton.
  ///
  /// In en, this message translates to:
  /// **'Search players'**
  String get advancedSearchPlayersButton;

  /// No description provided for @advancedSearchTeamsButton.
  ///
  /// In en, this message translates to:
  /// **'Search teams'**
  String get advancedSearchTeamsButton;

  /// No description provided for @advancedSearchTeams.
  ///
  /// In en, this message translates to:
  /// **'Teams'**
  String get advancedSearchTeams;

  /// No description provided for @advancedSearchPlayers.
  ///
  /// In en, this message translates to:
  /// **'Players'**
  String get advancedSearchPlayers;

  /// No description provided for @advancedSearchGame.
  ///
  /// In en, this message translates to:
  /// **'Game'**
  String get advancedSearchGame;

  /// No description provided for @advancedSearchRole.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get advancedSearchRole;

  /// No description provided for @advancedSearchRanking.
  ///
  /// In en, this message translates to:
  /// **'Ranking'**
  String get advancedSearchRanking;

  /// No description provided for @timePrefixText.
  ///
  /// In en, this message translates to:
  /// **''**
  String get timePrefixText;

  /// No description provided for @timeYearSuffixText.
  ///
  /// In en, this message translates to:
  /// **'year ago'**
  String get timeYearSuffixText;

  /// No description provided for @timeYearsSuffixText.
  ///
  /// In en, this message translates to:
  /// **'years ago'**
  String get timeYearsSuffixText;

  /// No description provided for @timeMonthSuffixText.
  ///
  /// In en, this message translates to:
  /// **'month ago'**
  String get timeMonthSuffixText;

  /// No description provided for @timeMonthsSuffixText.
  ///
  /// In en, this message translates to:
  /// **'months ago'**
  String get timeMonthsSuffixText;

  /// No description provided for @timeWeekSuffixText.
  ///
  /// In en, this message translates to:
  /// **'week ago'**
  String get timeWeekSuffixText;

  /// No description provided for @timeWeeksSuffixText.
  ///
  /// In en, this message translates to:
  /// **'weeks ago'**
  String get timeWeeksSuffixText;

  /// No description provided for @timeDaySuffixText.
  ///
  /// In en, this message translates to:
  /// **'day ago'**
  String get timeDaySuffixText;

  /// No description provided for @timeDaysSuffixText.
  ///
  /// In en, this message translates to:
  /// **'days ago'**
  String get timeDaysSuffixText;

  /// No description provided for @timeHourSuffixText.
  ///
  /// In en, this message translates to:
  /// **'hour ago'**
  String get timeHourSuffixText;

  /// No description provided for @timeHoursSuffixText.
  ///
  /// In en, this message translates to:
  /// **'hours ago'**
  String get timeHoursSuffixText;

  /// No description provided for @timeMinuteSuffixText.
  ///
  /// In en, this message translates to:
  /// **'minute ago'**
  String get timeMinuteSuffixText;

  /// No description provided for @timeMinutesSuffixText.
  ///
  /// In en, this message translates to:
  /// **'minutes ago'**
  String get timeMinutesSuffixText;

  /// No description provided for @timeSecondSuffixText.
  ///
  /// In en, this message translates to:
  /// **'second ago'**
  String get timeSecondSuffixText;

  /// No description provided for @timeSecondsSuffixText.
  ///
  /// In en, this message translates to:
  /// **'seconds ago'**
  String get timeSecondsSuffixText;

  /// No description provided for @drawerlanguageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get drawerlanguageLabel;

  /// No description provided for @drawerProfileLabel.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get drawerProfileLabel;

  /// No description provided for @drawerSettingsLabel.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get drawerSettingsLabel;

  /// No description provided for @drawerLogoutLabel.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get drawerLogoutLabel;

  /// No description provided for @profilePageLabel.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profilePageLabel;

  /// No description provided for @profileFollowButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Follow'**
  String get profileFollowButtonLabel;

  /// No description provided for @profileUnfollowButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Unfollow'**
  String get profileUnfollowButtonLabel;

  /// No description provided for @profileMessagesButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get profileMessagesButtonLabel;

  /// No description provided for @profileSendMessageButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Send message'**
  String get profileSendMessageButtonLabel;

  /// No description provided for @profileFollowingButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get profileFollowingButtonLabel;

  /// No description provided for @profileFollowersButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Followers'**
  String get profileFollowersButtonLabel;

  /// No description provided for @profilePrizesButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Prizes'**
  String get profilePrizesButtonLabel;

  /// No description provided for @messagesPageLabel.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messagesPageLabel;

  /// No description provided for @commentsModalLabel.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get commentsModalLabel;

  /// No description provided for @notificationsPageLabel.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsPageLabel;

  /// Notification about a user who liked a post
  ///
  /// In en, this message translates to:
  /// **'<b>{name}</b> liked your post.'**
  String notificationPostLiked(String name);

  /// Notification about a user who invited you to join his team
  ///
  /// In en, this message translates to:
  /// **'<b>{name}</b> has invited you to to join <b>{team}</b> team.'**
  String notificationInviteToTeam(String name, String team);

  /// No description provided for @notificationApplicationAccepted.
  ///
  /// In en, this message translates to:
  /// **'<b>{team}</b> has accepted your application for the {role} position in Overwatch. You are now a member of the professional team.'**
  String notificationApplicationAccepted(String role, String team);

  /// No description provided for @errorTitle.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get errorTitle;

  /// No description provided for @errorMessage.
  ///
  /// In en, this message translates to:
  /// **'An error has occurred. Please try again.'**
  String get errorMessage;

  /// No description provided for @okButton.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get okButton;

  /// No description provided for @editProfileButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get editProfileButtonLabel;

  /// No description provided for @userNotFound.
  ///
  /// In en, this message translates to:
  /// **'User not found'**
  String get userNotFound;

  /// No description provided for @teamNotFound.
  ///
  /// In en, this message translates to:
  /// **'Team not found'**
  String get teamNotFound;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @teamIdRequired.
  ///
  /// In en, this message translates to:
  /// **'Team ID is required'**
  String get teamIdRequired;

  /// No description provided for @prizesContent.
  ///
  /// In en, this message translates to:
  /// **'Prizes content goes here'**
  String get prizesContent;

  /// No description provided for @teamMembersTitle.
  ///
  /// In en, this message translates to:
  /// **'Team Members'**
  String get teamMembersTitle;

  /// No description provided for @teamTournamentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Team Tournaments'**
  String get teamTournamentsTitle;

  /// No description provided for @teamWinsTitle.
  ///
  /// In en, this message translates to:
  /// **'Team Wins'**
  String get teamWinsTitle;

  /// No description provided for @teamTournamentsList.
  ///
  /// In en, this message translates to:
  /// **'List of participated tournaments'**
  String get teamTournamentsList;

  /// No description provided for @teamWinsHistory.
  ///
  /// In en, this message translates to:
  /// **'Win history'**
  String get teamWinsHistory;

  /// No description provided for @verifyImageTitle.
  ///
  /// In en, this message translates to:
  /// **'View image'**
  String get verifyImageTitle;

  /// No description provided for @changeProfileImageTitle.
  ///
  /// In en, this message translates to:
  /// **'Change profile image'**
  String get changeProfileImageTitle;

  /// No description provided for @deletePost.
  ///
  /// In en, this message translates to:
  /// **'Delete post'**
  String get deletePost;

  /// No description provided for @searchTeamSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Team: {name}'**
  String searchTeamSnackbar(String name);

  /// No description provided for @noPostsYet.
  ///
  /// In en, this message translates to:
  /// **'No posts yet'**
  String get noPostsYet;

  /// No description provided for @followToSeePosts.
  ///
  /// In en, this message translates to:
  /// **'Follow a team or player to see their posts.'**
  String get followToSeePosts;

  /// No description provided for @searchUsersTeams.
  ///
  /// In en, this message translates to:
  /// **'Search users or teams'**
  String get searchUsersTeams;

  /// No description provided for @playersSection.
  ///
  /// In en, this message translates to:
  /// **'Players'**
  String get playersSection;

  /// No description provided for @teamsSection.
  ///
  /// In en, this message translates to:
  /// **'Teams'**
  String get teamsSection;

  /// No description provided for @verifiedStatus.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verifiedStatus;

  /// No description provided for @pendingStatus.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pendingStatus;

  /// No description provided for @membersLabel.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get membersLabel;

  /// No description provided for @gamesLabel.
  ///
  /// In en, this message translates to:
  /// **'Games'**
  String get gamesLabel;

  /// No description provided for @searchPlayersHint.
  ///
  /// In en, this message translates to:
  /// **'Search players...'**
  String get searchPlayersHint;

  /// No description provided for @searchTeamsHint.
  ///
  /// In en, this message translates to:
  /// **'Search teams...'**
  String get searchTeamsHint;

  /// No description provided for @teamSizeFilter.
  ///
  /// In en, this message translates to:
  /// **'Team Size'**
  String get teamSizeFilter;

  /// No description provided for @verifiedTeamsOnly.
  ///
  /// In en, this message translates to:
  /// **'Verified teams only'**
  String get verifiedTeamsOnly;

  /// No description provided for @playersSearchResult.
  ///
  /// In en, this message translates to:
  /// **'Player search with filters: {filters}'**
  String playersSearchResult(String filters);

  /// No description provided for @teamsSearchResult.
  ///
  /// In en, this message translates to:
  /// **'Team search with filters: {filters}'**
  String teamsSearchResult(String filters);

  /// No description provided for @viewMembersButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'View members'**
  String get viewMembersButtonLabel;

  /// No description provided for @contactButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contactButtonLabel;

  /// No description provided for @statisticsLabel.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statisticsLabel;

  /// No description provided for @tournamentsPlayedLabel.
  ///
  /// In en, this message translates to:
  /// **'Tournaments played'**
  String get tournamentsPlayedLabel;

  /// No description provided for @winsLabel.
  ///
  /// In en, this message translates to:
  /// **'Wins'**
  String get winsLabel;

  /// No description provided for @photoGalleryOption.
  ///
  /// In en, this message translates to:
  /// **'Photo Gallery'**
  String get photoGalleryOption;

  /// No description provided for @cameraOption.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get cameraOption;

  /// No description provided for @unauthorizedError.
  ///
  /// In en, this message translates to:
  /// **'Unauthorized'**
  String get unauthorizedError;

  /// No description provided for @unexpectedError.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred. Please try again.'**
  String get unexpectedError;

  /// No description provided for @acceptButton.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get acceptButton;

  /// No description provided for @incorrectCredentials.
  ///
  /// In en, this message translates to:
  /// **'The email or password is incorrect'**
  String get incorrectCredentials;

  /// No description provided for @photoVideoButton.
  ///
  /// In en, this message translates to:
  /// **'Photo / Video'**
  String get photoVideoButton;

  /// No description provided for @writeMessageHint.
  ///
  /// In en, this message translates to:
  /// **'Write message...'**
  String get writeMessageHint;

  /// No description provided for @tournamentTitleColumn.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get tournamentTitleColumn;

  /// No description provided for @officialColumn.
  ///
  /// In en, this message translates to:
  /// **'Official'**
  String get officialColumn;

  /// No description provided for @gameColumn.
  ///
  /// In en, this message translates to:
  /// **'Game'**
  String get gameColumn;

  /// No description provided for @registeredPlayersColumn.
  ///
  /// In en, this message translates to:
  /// **'Registered players'**
  String get registeredPlayersColumn;

  /// No description provided for @settingsLabel.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsLabel;

  /// No description provided for @darkmodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Darkmode'**
  String get darkmodeLabel;

  /// No description provided for @languageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageLabel;

  /// No description provided for @commentsLabel.
  ///
  /// In en, this message translates to:
  /// **'comments'**
  String get commentsLabel;

  /// No description provided for @imageNotSupported.
  ///
  /// In en, this message translates to:
  /// **'This image type is not supported'**
  String get imageNotSupported;

  /// No description provided for @pickImageError.
  ///
  /// In en, this message translates to:
  /// **'Pick image error'**
  String get pickImageError;

  /// No description provided for @noImageSelected.
  ///
  /// In en, this message translates to:
  /// **'You have not yet picked an image.'**
  String get noImageSelected;

  /// No description provided for @errorLoadingUserProfile.
  ///
  /// In en, this message translates to:
  /// **'Error loading user profile'**
  String get errorLoadingUserProfile;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
