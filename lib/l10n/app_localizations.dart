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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
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
  /// **'Password is required'**
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

  /// No description provided for @loginForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password?'**
  String get loginForgotPassword;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Recover password'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email and we\'ll send you a link to reset your password'**
  String get forgotPasswordSubtitle;

  /// No description provided for @forgotPasswordEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get forgotPasswordEmailHint;

  /// No description provided for @forgotPasswordButton.
  ///
  /// In en, this message translates to:
  /// **'Send recovery link'**
  String get forgotPasswordButton;

  /// No description provided for @forgotPasswordSuccess.
  ///
  /// In en, this message translates to:
  /// **'An email has been sent with instructions to reset your password'**
  String get forgotPasswordSuccess;

  /// No description provided for @forgotPasswordError.
  ///
  /// In en, this message translates to:
  /// **'Error sending email. Please verify that the email is correct.'**
  String get forgotPasswordError;

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

  /// No description provided for @memberSinceLabel.
  ///
  /// In en, this message translates to:
  /// **'Member since'**
  String get memberSinceLabel;

  /// No description provided for @tournamentWinsLabel.
  ///
  /// In en, this message translates to:
  /// **'Tournament Wins'**
  String get tournamentWinsLabel;

  /// No description provided for @socialMediaLabel.
  ///
  /// In en, this message translates to:
  /// **'Social Media'**
  String get socialMediaLabel;

  /// No description provided for @achievementsAwardsLabel.
  ///
  /// In en, this message translates to:
  /// **'Achievements & Awards'**
  String get achievementsAwardsLabel;

  /// No description provided for @postsLabel.
  ///
  /// In en, this message translates to:
  /// **'Posts'**
  String get postsLabel;

  /// No description provided for @profileTeamsLabel.
  ///
  /// In en, this message translates to:
  /// **'Teams'**
  String get profileTeamsLabel;

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

  /// Notification about a new follower
  ///
  /// In en, this message translates to:
  /// **'<b>{name}</b> started following you.'**
  String notificationNewFollower(String name);

  /// Notification about a user who commented on a post
  ///
  /// In en, this message translates to:
  /// **'<b>{name}</b> commented on your post.'**
  String notificationPostCommented(String name);

  /// Notification about a user who shared a post
  ///
  /// In en, this message translates to:
  /// **'<b>{name}</b> shared your post.'**
  String notificationPostShared(String name);

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

  /// No description provided for @tournamentDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Tournament Details'**
  String get tournamentDetailsTitle;

  /// No description provided for @tournamentParticipantsLabel.
  ///
  /// In en, this message translates to:
  /// **'Participants'**
  String get tournamentParticipantsLabel;

  /// No description provided for @tournamentGameInfoLabel.
  ///
  /// In en, this message translates to:
  /// **'Game Information'**
  String get tournamentGameInfoLabel;

  /// No description provided for @tournamentGameTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Game Type'**
  String get tournamentGameTypeLabel;

  /// No description provided for @tournamentOfficialLabel.
  ///
  /// In en, this message translates to:
  /// **'Official Tournament'**
  String get tournamentOfficialLabel;

  /// No description provided for @tournamentCommunityLabel.
  ///
  /// In en, this message translates to:
  /// **'Community Tournament'**
  String get tournamentCommunityLabel;

  /// No description provided for @tournamentOfficialDescription.
  ///
  /// In en, this message translates to:
  /// **'Organized by official game developers or sponsors'**
  String get tournamentOfficialDescription;

  /// No description provided for @tournamentCommunityDescription.
  ///
  /// In en, this message translates to:
  /// **'Organized by the community'**
  String get tournamentCommunityDescription;

  /// No description provided for @tournamentParticipantsListLabel.
  ///
  /// In en, this message translates to:
  /// **'List of registered participants will be displayed here'**
  String get tournamentParticipantsListLabel;

  /// No description provided for @tournamentRegisteredTeamsLabel.
  ///
  /// In en, this message translates to:
  /// **'Registered Teams'**
  String get tournamentRegisteredTeamsLabel;

  /// No description provided for @tournamentNoParticipantsLabel.
  ///
  /// In en, this message translates to:
  /// **'No participants yet. Be the first to join!'**
  String get tournamentNoParticipantsLabel;

  /// No description provided for @tournamentRegistrationSuccess.
  ///
  /// In en, this message translates to:
  /// **'Successfully registered for tournament!'**
  String get tournamentRegistrationSuccess;

  /// No description provided for @tournamentAlreadyRegisteredLabel.
  ///
  /// In en, this message translates to:
  /// **'Already Registered'**
  String get tournamentAlreadyRegisteredLabel;

  /// No description provided for @tournamentRegisterButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Register for Tournament'**
  String get tournamentRegisterButtonLabel;

  /// No description provided for @tournamentAdditionalInfoLabel.
  ///
  /// In en, this message translates to:
  /// **'Additional Information'**
  String get tournamentAdditionalInfoLabel;

  /// No description provided for @tournamentStartDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get tournamentStartDateLabel;

  /// No description provided for @tournamentStartDatePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'To be announced'**
  String get tournamentStartDatePlaceholder;

  /// No description provided for @tournamentLocationLabel.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get tournamentLocationLabel;

  /// No description provided for @tournamentLocationPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get tournamentLocationPlaceholder;

  /// No description provided for @tournamentPrizePoolLabel.
  ///
  /// In en, this message translates to:
  /// **'Prize Pool'**
  String get tournamentPrizePoolLabel;

  /// No description provided for @tournamentPrizePoolPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'To be announced'**
  String get tournamentPrizePoolPlaceholder;

  /// No description provided for @tournamentFormTitle.
  ///
  /// In en, this message translates to:
  /// **'Tournament Title'**
  String get tournamentFormTitle;

  /// No description provided for @tournamentFormTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Ex: Summer Cup 2024'**
  String get tournamentFormTitleHint;

  /// No description provided for @tournamentFormDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get tournamentFormDescription;

  /// No description provided for @tournamentFormDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Describe your tournament...'**
  String get tournamentFormDescriptionHint;

  /// No description provided for @tournamentFormGame.
  ///
  /// In en, this message translates to:
  /// **'Game'**
  String get tournamentFormGame;

  /// No description provided for @tournamentFormGameHint.
  ///
  /// In en, this message translates to:
  /// **'Select a game'**
  String get tournamentFormGameHint;

  /// No description provided for @tournamentFormType.
  ///
  /// In en, this message translates to:
  /// **'Tournament Format'**
  String get tournamentFormType;

  /// No description provided for @tournamentFormDates.
  ///
  /// In en, this message translates to:
  /// **'Tournament Dates'**
  String get tournamentFormDates;

  /// No description provided for @tournamentFormStartDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get tournamentFormStartDate;

  /// No description provided for @tournamentFormEndDate.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get tournamentFormEndDate;

  /// No description provided for @tournamentFormSelectDate.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get tournamentFormSelectDate;

  /// No description provided for @tournamentFormRegistrationDeadline.
  ///
  /// In en, this message translates to:
  /// **'Registration Deadline'**
  String get tournamentFormRegistrationDeadline;

  /// No description provided for @tournamentFormConfiguration.
  ///
  /// In en, this message translates to:
  /// **'Configuration'**
  String get tournamentFormConfiguration;

  /// No description provided for @tournamentFormOfficial.
  ///
  /// In en, this message translates to:
  /// **'Official Tournament'**
  String get tournamentFormOfficial;

  /// No description provided for @tournamentFormOfficialSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Mark as official platform tournament'**
  String get tournamentFormOfficialSubtitle;

  /// No description provided for @tournamentFormPrivate.
  ///
  /// In en, this message translates to:
  /// **'Private Tournament'**
  String get tournamentFormPrivate;

  /// No description provided for @tournamentFormPrivateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Only visible to invited participants'**
  String get tournamentFormPrivateSubtitle;

  /// No description provided for @tournamentFormMaxParticipants.
  ///
  /// In en, this message translates to:
  /// **'Max Participants'**
  String get tournamentFormMaxParticipants;

  /// No description provided for @tournamentFormPrizePool.
  ///
  /// In en, this message translates to:
  /// **'Total Prize (\$)'**
  String get tournamentFormPrizePool;

  /// No description provided for @tournamentFormCreateButton.
  ///
  /// In en, this message translates to:
  /// **'Create Tournament'**
  String get tournamentFormCreateButton;

  /// No description provided for @tournamentFormUpdateButton.
  ///
  /// In en, this message translates to:
  /// **'Update Tournament'**
  String get tournamentFormUpdateButton;

  /// No description provided for @tournamentFormCancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get tournamentFormCancelButton;

  /// No description provided for @tournamentFormDeleteButton.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get tournamentFormDeleteButton;

  /// No description provided for @tournamentFormDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Tournament'**
  String get tournamentFormDeleteTitle;

  /// No description provided for @tournamentFormDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this tournament? This action cannot be undone.'**
  String get tournamentFormDeleteMessage;

  /// No description provided for @tournamentFormDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get tournamentFormDeleteConfirm;

  /// No description provided for @tournamentFormDeleteCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get tournamentFormDeleteCancel;

  /// No description provided for @tournamentFormSuccessCreate.
  ///
  /// In en, this message translates to:
  /// **'Tournament created successfully'**
  String get tournamentFormSuccessCreate;

  /// No description provided for @tournamentFormSuccessUpdate.
  ///
  /// In en, this message translates to:
  /// **'Tournament updated successfully'**
  String get tournamentFormSuccessUpdate;

  /// No description provided for @tournamentFormSuccessDelete.
  ///
  /// In en, this message translates to:
  /// **'Tournament deleted successfully'**
  String get tournamentFormSuccessDelete;

  /// No description provided for @tournamentFormErrorCreate.
  ///
  /// In en, this message translates to:
  /// **'Error creating tournament'**
  String get tournamentFormErrorCreate;

  /// No description provided for @tournamentFormErrorUpdate.
  ///
  /// In en, this message translates to:
  /// **'Error updating tournament'**
  String get tournamentFormErrorUpdate;

  /// No description provided for @tournamentFormErrorDelete.
  ///
  /// In en, this message translates to:
  /// **'Error deleting tournament'**
  String get tournamentFormErrorDelete;

  /// No description provided for @tournamentFormValidationTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Title is required'**
  String get tournamentFormValidationTitleRequired;

  /// No description provided for @tournamentFormValidationTitleMinLength.
  ///
  /// In en, this message translates to:
  /// **'Title must have at least 3 characters'**
  String get tournamentFormValidationTitleMinLength;

  /// No description provided for @tournamentFormValidationDescriptionRequired.
  ///
  /// In en, this message translates to:
  /// **'Description is required'**
  String get tournamentFormValidationDescriptionRequired;

  /// No description provided for @tournamentFormValidationDescriptionMinLength.
  ///
  /// In en, this message translates to:
  /// **'Description must have at least 10 characters'**
  String get tournamentFormValidationDescriptionMinLength;

  /// No description provided for @tournamentFormValidationGameRequired.
  ///
  /// In en, this message translates to:
  /// **'You must select a game'**
  String get tournamentFormValidationGameRequired;

  /// No description provided for @tournamentFormValidationStartDateRequired.
  ///
  /// In en, this message translates to:
  /// **'You must select a start date'**
  String get tournamentFormValidationStartDateRequired;

  /// No description provided for @tournamentFormValidationEndDateRequired.
  ///
  /// In en, this message translates to:
  /// **'You must select an end date'**
  String get tournamentFormValidationEndDateRequired;

  /// No description provided for @tournamentFormValidationDateOrder.
  ///
  /// In en, this message translates to:
  /// **'Start date must be before end date'**
  String get tournamentFormValidationDateOrder;

  /// No description provided for @tournamentFormValidationDatePast.
  ///
  /// In en, this message translates to:
  /// **'Start date cannot be in the past'**
  String get tournamentFormValidationDatePast;

  /// No description provided for @tournamentFormTypeSingleElimination.
  ///
  /// In en, this message translates to:
  /// **'Single Elimination'**
  String get tournamentFormTypeSingleElimination;

  /// No description provided for @tournamentFormTypeDoubleElimination.
  ///
  /// In en, this message translates to:
  /// **'Double Elimination'**
  String get tournamentFormTypeDoubleElimination;

  /// No description provided for @tournamentFormTypeRoundRobin.
  ///
  /// In en, this message translates to:
  /// **'Round Robin'**
  String get tournamentFormTypeRoundRobin;

  /// No description provided for @tournamentFormTypeSwissSystem.
  ///
  /// In en, this message translates to:
  /// **'Swiss System'**
  String get tournamentFormTypeSwissSystem;

  /// No description provided for @tournamentFormDeadline1Day.
  ///
  /// In en, this message translates to:
  /// **'1 day before'**
  String get tournamentFormDeadline1Day;

  /// No description provided for @tournamentFormDeadline3Days.
  ///
  /// In en, this message translates to:
  /// **'3 days before'**
  String get tournamentFormDeadline3Days;

  /// No description provided for @tournamentFormDeadline1Week.
  ///
  /// In en, this message translates to:
  /// **'1 week before'**
  String get tournamentFormDeadline1Week;

  /// No description provided for @tournamentFormDeadline2Weeks.
  ///
  /// In en, this message translates to:
  /// **'2 weeks before'**
  String get tournamentFormDeadline2Weeks;

  /// No description provided for @tournamentFormSelectGame.
  ///
  /// In en, this message translates to:
  /// **'Select a game'**
  String get tournamentFormSelectGame;

  /// No description provided for @tournamentFormViewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get tournamentFormViewDetails;

  /// No description provided for @tournamentFormPlayers.
  ///
  /// In en, this message translates to:
  /// **'Players'**
  String get tournamentFormPlayers;

  /// No description provided for @tournamentFormEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get tournamentFormEdit;

  /// No description provided for @tournamentFormDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get tournamentFormDelete;

  /// No description provided for @tournamentFormTournamentDeleted.
  ///
  /// In en, this message translates to:
  /// **'Tournament \"{title}\" deleted'**
  String tournamentFormTournamentDeleted(String title);

  /// No description provided for @tournamentFormLoadingTournaments.
  ///
  /// In en, this message translates to:
  /// **'Loading tournaments...'**
  String get tournamentFormLoadingTournaments;

  /// No description provided for @tournamentFormNoTournamentsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No tournaments available'**
  String get tournamentFormNoTournamentsAvailable;

  /// No description provided for @tournamentFormCheckBackLater.
  ///
  /// In en, this message translates to:
  /// **'Check back later for new tournaments'**
  String get tournamentFormCheckBackLater;

  /// No description provided for @tournamentFormPleaseFixErrors.
  ///
  /// In en, this message translates to:
  /// **'Please fix the errors in the form'**
  String get tournamentFormPleaseFixErrors;

  /// No description provided for @validationRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get validationRequired;

  /// No description provided for @validationFirstNameMin.
  ///
  /// In en, this message translates to:
  /// **'First name must have at least 2 characters'**
  String get validationFirstNameMin;

  /// No description provided for @validationFirstNameMax.
  ///
  /// In en, this message translates to:
  /// **'First name must have at most 50 characters'**
  String get validationFirstNameMax;

  /// No description provided for @validationLastNameMin.
  ///
  /// In en, this message translates to:
  /// **'Last name must have at least 2 characters'**
  String get validationLastNameMin;

  /// No description provided for @validationLastNameMax.
  ///
  /// In en, this message translates to:
  /// **'Last name must have at most 50 characters'**
  String get validationLastNameMax;

  /// No description provided for @validationInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get validationInvalidEmail;

  /// No description provided for @validationUsernameMin.
  ///
  /// In en, this message translates to:
  /// **'Username must have at least 3 characters'**
  String get validationUsernameMin;

  /// No description provided for @validationUsernameMax.
  ///
  /// In en, this message translates to:
  /// **'Username must have at most 20 characters'**
  String get validationUsernameMax;

  /// No description provided for @validationUsernameInvalid.
  ///
  /// In en, this message translates to:
  /// **'Username can only contain letters, numbers, underscores and dots'**
  String get validationUsernameInvalid;

  /// No description provided for @validationPasswordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must have at least 8 characters'**
  String get validationPasswordMinLength;

  /// No description provided for @validationPasswordHasUpperCase.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one uppercase letter'**
  String get validationPasswordHasUpperCase;

  /// No description provided for @validationPasswordHasLowerCase.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one lowercase letter'**
  String get validationPasswordHasLowerCase;

  /// No description provided for @validationPasswordHasNumber.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one number'**
  String get validationPasswordHasNumber;

  /// No description provided for @validationPasswordHasSpecialChar.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one special character'**
  String get validationPasswordHasSpecialChar;

  /// No description provided for @validationPasswordsDontMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get validationPasswordsDontMatch;

  /// No description provided for @passwordRequirementsTitle.
  ///
  /// In en, this message translates to:
  /// **'Password Requirements'**
  String get passwordRequirementsTitle;

  /// No description provided for @registerFirstNameHint.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get registerFirstNameHint;

  /// No description provided for @registerLastNameHint.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get registerLastNameHint;

  /// No description provided for @registerUsernameHint.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get registerUsernameHint;

  /// No description provided for @registerEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get registerEmailHint;

  /// No description provided for @registerPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get registerPasswordHint;

  /// No description provided for @registerConfirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Repeat password'**
  String get registerConfirmPasswordHint;

  /// No description provided for @registerButton.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerButton;

  /// No description provided for @registerAlreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign In'**
  String get registerAlreadyHaveAccount;

  /// No description provided for @registerErrorCreatingAccount.
  ///
  /// In en, this message translates to:
  /// **'Error creating account'**
  String get registerErrorCreatingAccount;

  /// No description provided for @editTeam.
  ///
  /// In en, this message translates to:
  /// **'Edit Team'**
  String get editTeam;

  /// No description provided for @manageGames.
  ///
  /// In en, this message translates to:
  /// **'Manage Games'**
  String get manageGames;

  /// No description provided for @teamRequests.
  ///
  /// In en, this message translates to:
  /// **'Team Requests'**
  String get teamRequests;

  /// No description provided for @requests.
  ///
  /// In en, this message translates to:
  /// **'Requests'**
  String get requests;

  /// No description provided for @deleteTeam.
  ///
  /// In en, this message translates to:
  /// **'Delete Team'**
  String get deleteTeam;

  /// No description provided for @leaveTeam.
  ///
  /// In en, this message translates to:
  /// **'Leave Team'**
  String get leaveTeam;

  /// No description provided for @requestAccess.
  ///
  /// In en, this message translates to:
  /// **'Request Access'**
  String get requestAccess;

  /// No description provided for @removeMember.
  ///
  /// In en, this message translates to:
  /// **'Remove Member'**
  String get removeMember;

  /// No description provided for @acceptRequest.
  ///
  /// In en, this message translates to:
  /// **'Accept Request'**
  String get acceptRequest;

  /// No description provided for @declineRequest.
  ///
  /// In en, this message translates to:
  /// **'Decline Request'**
  String get declineRequest;

  /// No description provided for @teamUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Team updated successfully'**
  String get teamUpdatedSuccessfully;

  /// No description provided for @errorUpdatingTeam.
  ///
  /// In en, this message translates to:
  /// **'Error updating team'**
  String get errorUpdatingTeam;

  /// No description provided for @teamDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Team deleted successfully'**
  String get teamDeletedSuccessfully;

  /// No description provided for @errorDeletingTeam.
  ///
  /// In en, this message translates to:
  /// **'Error deleting team'**
  String get errorDeletingTeam;

  /// No description provided for @leftTeamSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Left team successfully'**
  String get leftTeamSuccessfully;

  /// No description provided for @errorLeavingTeam.
  ///
  /// In en, this message translates to:
  /// **'Error leaving team'**
  String get errorLeavingTeam;

  /// No description provided for @accessRequestSent.
  ///
  /// In en, this message translates to:
  /// **'Access request sent'**
  String get accessRequestSent;

  /// No description provided for @errorSendingRequest.
  ///
  /// In en, this message translates to:
  /// **'Error sending request'**
  String get errorSendingRequest;

  /// No description provided for @requestAccepted.
  ///
  /// In en, this message translates to:
  /// **'Request accepted'**
  String get requestAccepted;

  /// No description provided for @errorAcceptingRequest.
  ///
  /// In en, this message translates to:
  /// **'Error accepting request'**
  String get errorAcceptingRequest;

  /// No description provided for @requestDeclined.
  ///
  /// In en, this message translates to:
  /// **'Request declined'**
  String get requestDeclined;

  /// No description provided for @errorDecliningRequest.
  ///
  /// In en, this message translates to:
  /// **'Error declining request'**
  String get errorDecliningRequest;

  /// No description provided for @memberRemovedFromTeam.
  ///
  /// In en, this message translates to:
  /// **'Member removed from team'**
  String get memberRemovedFromTeam;

  /// No description provided for @errorRemovingMember.
  ///
  /// In en, this message translates to:
  /// **'Error removing member'**
  String get errorRemovingMember;

  /// No description provided for @gameAdded.
  ///
  /// In en, this message translates to:
  /// **'Game added'**
  String get gameAdded;

  /// No description provided for @errorAddingGame.
  ///
  /// In en, this message translates to:
  /// **'Error adding game'**
  String get errorAddingGame;

  /// No description provided for @gameRemoved.
  ///
  /// In en, this message translates to:
  /// **'Game removed'**
  String get gameRemoved;

  /// No description provided for @errorRemovingGame.
  ///
  /// In en, this message translates to:
  /// **'Error removing game'**
  String get errorRemovingGame;

  /// No description provided for @noPendingRequests.
  ///
  /// In en, this message translates to:
  /// **'No pending requests'**
  String get noPendingRequests;

  /// No description provided for @areYouSureDeleteTeam.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this team? This action cannot be undone.'**
  String get areYouSureDeleteTeam;

  /// No description provided for @areYouSureLeaveTeam.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to leave this team?'**
  String get areYouSureLeaveTeam;

  /// No description provided for @areYouSureRemoveMember.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove {name} from the team?'**
  String areYouSureRemoveMember(String name);

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @leave.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get leave;

  /// No description provided for @teamName.
  ///
  /// In en, this message translates to:
  /// **'Team Name'**
  String get teamName;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @waitingForApproval.
  ///
  /// In en, this message translates to:
  /// **'Waiting for Approval'**
  String get waitingForApproval;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @profileImage.
  ///
  /// In en, this message translates to:
  /// **'Profile Image'**
  String get profileImage;

  /// No description provided for @backgroundImage.
  ///
  /// In en, this message translates to:
  /// **'Background Image'**
  String get backgroundImage;

  /// No description provided for @changeProfileImage.
  ///
  /// In en, this message translates to:
  /// **'Tap to change profile image'**
  String get changeProfileImage;

  /// No description provided for @changeBackgroundImage.
  ///
  /// In en, this message translates to:
  /// **'Change Background Image'**
  String get changeBackgroundImage;

  /// No description provided for @dangerZone.
  ///
  /// In en, this message translates to:
  /// **'Danger Zone'**
  String get dangerZone;

  /// No description provided for @deleteTeamConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this team? This action cannot be undone.'**
  String get deleteTeamConfirmation;

  /// No description provided for @resetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPasswordTitle;

  /// No description provided for @resetPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your new password below'**
  String get resetPasswordSubtitle;

  /// No description provided for @resetPasswordSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password reset successfully! You can now log in with your new password.'**
  String get resetPasswordSuccess;

  /// No description provided for @resetPasswordGoToLogin.
  ///
  /// In en, this message translates to:
  /// **'Go to Login'**
  String get resetPasswordGoToLogin;

  /// No description provided for @resetPasswordButton.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPasswordButton;

  /// No description provided for @resetPasswordInvalidToken.
  ///
  /// In en, this message translates to:
  /// **'The token is invalid or has expired'**
  String get resetPasswordInvalidToken;

  /// No description provided for @resetPasswordError.
  ///
  /// In en, this message translates to:
  /// **'Error resetting password. Please try again.'**
  String get resetPasswordError;

  /// No description provided for @tournamentStatusFinished.
  ///
  /// In en, this message translates to:
  /// **'Finished'**
  String get tournamentStatusFinished;

  /// No description provided for @tournamentStatusOngoing.
  ///
  /// In en, this message translates to:
  /// **'Ongoing'**
  String get tournamentStatusOngoing;

  /// No description provided for @tournamentStatusUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get tournamentStatusUpcoming;

  /// No description provided for @tournamentStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Tournament Status'**
  String get tournamentStatusLabel;

  /// No description provided for @tournamentResponsible.
  ///
  /// In en, this message translates to:
  /// **'Tournament Responsible'**
  String get tournamentResponsible;

  /// No description provided for @tournamentStartDate.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get tournamentStartDate;

  /// No description provided for @tournamentEndDate.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get tournamentEndDate;

  /// No description provided for @tournamentPrize.
  ///
  /// In en, this message translates to:
  /// **'Prize'**
  String get tournamentPrize;

  /// No description provided for @tournamentUserNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'User not available'**
  String get tournamentUserNotAvailable;

  /// No description provided for @tournamentYouAreCreator.
  ///
  /// In en, this message translates to:
  /// **'You are the creator'**
  String get tournamentYouAreCreator;

  /// No description provided for @tournamentYouAreRole.
  ///
  /// In en, this message translates to:
  /// **'You are {role}'**
  String tournamentYouAreRole(String role);

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @tournamentPendingRequests.
  ///
  /// In en, this message translates to:
  /// **'Pending Requests'**
  String get tournamentPendingRequests;

  /// No description provided for @tournamentNoPendingRequests.
  ///
  /// In en, this message translates to:
  /// **'No pending requests'**
  String get tournamentNoPendingRequests;

  /// No description provided for @tournamentRequestCountSingular.
  ///
  /// In en, this message translates to:
  /// **'1 request'**
  String get tournamentRequestCountSingular;

  /// No description provided for @tournamentRequestCountPlural.
  ///
  /// In en, this message translates to:
  /// **'{count} requests'**
  String tournamentRequestCountPlural(num count);

  /// No description provided for @tournamentRequestRequested.
  ///
  /// In en, this message translates to:
  /// **'Requested'**
  String get tournamentRequestRequested;

  /// No description provided for @tournamentAcceptRequest.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get tournamentAcceptRequest;

  /// No description provided for @tournamentDeclineRequest.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get tournamentDeclineRequest;

  /// No description provided for @tournamentAcceptRequestTitle.
  ///
  /// In en, this message translates to:
  /// **'Accept Request'**
  String get tournamentAcceptRequestTitle;

  /// No description provided for @tournamentAcceptRequestMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to accept the request from {teamName}?'**
  String tournamentAcceptRequestMessage(String teamName);

  /// No description provided for @tournamentDeclineRequestTitle.
  ///
  /// In en, this message translates to:
  /// **'Decline Request'**
  String get tournamentDeclineRequestTitle;

  /// No description provided for @tournamentDeclineRequestMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to decline the request from {teamName}?'**
  String tournamentDeclineRequestMessage(String teamName);

  /// No description provided for @tournamentRequestAccepted.
  ///
  /// In en, this message translates to:
  /// **'Request accepted successfully'**
  String get tournamentRequestAccepted;

  /// No description provided for @tournamentRequestDeclined.
  ///
  /// In en, this message translates to:
  /// **'Request declined successfully'**
  String get tournamentRequestDeclined;

  /// No description provided for @tournamentErrorAcceptingRequest.
  ///
  /// In en, this message translates to:
  /// **'Error accepting request'**
  String get tournamentErrorAcceptingRequest;

  /// No description provided for @tournamentErrorDecliningRequest.
  ///
  /// In en, this message translates to:
  /// **'Error declining request'**
  String get tournamentErrorDecliningRequest;

  /// No description provided for @tournamentTabInfo.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get tournamentTabInfo;

  /// No description provided for @tournamentTabRequests.
  ///
  /// In en, this message translates to:
  /// **'Requests'**
  String get tournamentTabRequests;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// No description provided for @tournamentFormImage.
  ///
  /// In en, this message translates to:
  /// **'Tournament Image'**
  String get tournamentFormImage;

  /// No description provided for @tournamentFormSelectImage.
  ///
  /// In en, this message translates to:
  /// **'Select Image'**
  String get tournamentFormSelectImage;

  /// No description provided for @tournamentFormRegion.
  ///
  /// In en, this message translates to:
  /// **'Region'**
  String get tournamentFormRegion;

  /// No description provided for @tournamentFormRegionHint.
  ///
  /// In en, this message translates to:
  /// **'LATAM'**
  String get tournamentFormRegionHint;

  /// No description provided for @tournamentFormSearchResponsible.
  ///
  /// In en, this message translates to:
  /// **'Search Responsible'**
  String get tournamentFormSearchResponsible;

  /// No description provided for @tournamentFormSearchResponsibleTitle.
  ///
  /// In en, this message translates to:
  /// **'Search Responsible User'**
  String get tournamentFormSearchResponsibleTitle;

  /// No description provided for @tournamentFormSelectMaxTeams.
  ///
  /// In en, this message translates to:
  /// **'Select maximum teams'**
  String get tournamentFormSelectMaxTeams;

  /// No description provided for @tournamentFormMinRank.
  ///
  /// In en, this message translates to:
  /// **'Minimum Rank'**
  String get tournamentFormMinRank;

  /// No description provided for @tournamentFormMaxRank.
  ///
  /// In en, this message translates to:
  /// **'Maximum Rank'**
  String get tournamentFormMaxRank;

  /// No description provided for @tournamentFormRules.
  ///
  /// In en, this message translates to:
  /// **'Tournament Rules'**
  String get tournamentFormRules;

  /// No description provided for @tournamentFormRulesList.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get tournamentFormRulesList;

  /// No description provided for @tournamentFormRulesNumberedList.
  ///
  /// In en, this message translates to:
  /// **'Numbered List'**
  String get tournamentFormRulesNumberedList;

  /// No description provided for @tournamentFormRulesBold.
  ///
  /// In en, this message translates to:
  /// **'Bold'**
  String get tournamentFormRulesBold;

  /// No description provided for @tournamentFormRulesItalic.
  ///
  /// In en, this message translates to:
  /// **'Italic'**
  String get tournamentFormRulesItalic;

  /// No description provided for @tournamentFormRulesTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get tournamentFormRulesTitle;

  /// No description provided for @tournamentFormRulesHint.
  ///
  /// In en, this message translates to:
  /// **'Write the tournament rules...\n\nExample:\n# General Rules\n- Respect others\n- Punctuality\n\n# Game Rules\n1. First rule\n2. Second rule'**
  String get tournamentFormRulesHint;

  /// No description provided for @tournamentFormRulesHelp.
  ///
  /// In en, this message translates to:
  /// **'Use the buttons to add formatting. The text will be displayed as markdown.'**
  String get tournamentFormRulesHelp;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @tournamentFormSearchUsernameHint.
  ///
  /// In en, this message translates to:
  /// **'Search by username...'**
  String get tournamentFormSearchUsernameHint;

  /// No description provided for @tournamentFormNoUsersFound.
  ///
  /// In en, this message translates to:
  /// **'No users found'**
  String get tournamentFormNoUsersFound;

  /// No description provided for @tournamentFormSearchMinChars.
  ///
  /// In en, this message translates to:
  /// **'Type at least 3 characters to search'**
  String get tournamentFormSearchMinChars;

  /// No description provided for @profileTabPosts.
  ///
  /// In en, this message translates to:
  /// **'Posts'**
  String get profileTabPosts;

  /// No description provided for @profileTabInfo.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get profileTabInfo;

  /// No description provided for @tournamentFormMaxTeams.
  ///
  /// In en, this message translates to:
  /// **'Maximum Teams'**
  String get tournamentFormMaxTeams;

  /// No description provided for @retryButton.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryButton;

  /// No description provided for @noConversations.
  ///
  /// In en, this message translates to:
  /// **'No conversations'**
  String get noConversations;

  /// No description provided for @errorLoadingConversations.
  ///
  /// In en, this message translates to:
  /// **'Error loading conversations'**
  String get errorLoadingConversations;

  /// No description provided for @chatLabel.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chatLabel;

  /// No description provided for @onlineLabel.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get onlineLabel;

  /// No description provided for @editProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfileTitle;

  /// No description provided for @errorLoadingSocialNetworks.
  ///
  /// In en, this message translates to:
  /// **'Error loading social networks: {error}'**
  String errorLoadingSocialNetworks(String error);

  /// No description provided for @errorPickingImage.
  ///
  /// In en, this message translates to:
  /// **'Error picking image: {error}'**
  String errorPickingImage(String error);

  /// No description provided for @backgroundImageUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Background image updated successfully'**
  String get backgroundImageUpdatedSuccessfully;

  /// No description provided for @failedToUpdateBackgroundImage.
  ///
  /// In en, this message translates to:
  /// **'Failed to update background image'**
  String get failedToUpdateBackgroundImage;

  /// No description provided for @descriptionUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Description updated successfully'**
  String get descriptionUpdatedSuccessfully;

  /// No description provided for @failedToUpdateDescription.
  ///
  /// In en, this message translates to:
  /// **'Failed to update description'**
  String get failedToUpdateDescription;

  /// No description provided for @addSocialNetwork.
  ///
  /// In en, this message translates to:
  /// **'Add {networkName}'**
  String addSocialNetwork(String networkName);

  /// No description provided for @usernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get usernameLabel;

  /// No description provided for @enterSocialNetworkUsername.
  ///
  /// In en, this message translates to:
  /// **'Enter your {networkName} username'**
  String enterSocialNetworkUsername(String networkName);

  /// No description provided for @addButton.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get addButton;

  /// No description provided for @socialNetworkAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'{networkName} added successfully'**
  String socialNetworkAddedSuccessfully(String networkName);

  /// No description provided for @failedToAddSocialNetwork.
  ///
  /// In en, this message translates to:
  /// **'Failed to add {networkName}'**
  String failedToAddSocialNetwork(String networkName);

  /// No description provided for @removeNetwork.
  ///
  /// In en, this message translates to:
  /// **'Remove Network'**
  String get removeNetwork;

  /// No description provided for @areYouSureRemoveNetwork.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove {networkName}?'**
  String areYouSureRemoveNetwork(String networkName);

  /// No description provided for @socialNetworkRemoved.
  ///
  /// In en, this message translates to:
  /// **'{networkName} removed'**
  String socialNetworkRemoved(String networkName);

  /// No description provided for @backgroundImageLabel.
  ///
  /// In en, this message translates to:
  /// **'Background Image'**
  String get backgroundImageLabel;

  /// No description provided for @descriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get descriptionLabel;

  /// No description provided for @tellUsAboutYourself.
  ///
  /// In en, this message translates to:
  /// **'Tell us about yourself...'**
  String get tellUsAboutYourself;

  /// No description provided for @saveDescription.
  ///
  /// In en, this message translates to:
  /// **'Save Description'**
  String get saveDescription;

  /// No description provided for @socialNetworksLabel.
  ///
  /// In en, this message translates to:
  /// **'Social Networks'**
  String get socialNetworksLabel;

  /// No description provided for @yourNetworks.
  ///
  /// In en, this message translates to:
  /// **'Your Networks:'**
  String get yourNetworks;

  /// No description provided for @addNetwork.
  ///
  /// In en, this message translates to:
  /// **'Add Network:'**
  String get addNetwork;

  /// No description provided for @mustBeInTeamToRegister.
  ///
  /// In en, this message translates to:
  /// **'You must be in a team to register'**
  String get mustBeInTeamToRegister;

  /// No description provided for @noTeamsInTournament.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have teams in this tournament'**
  String get noTeamsInTournament;

  /// No description provided for @leaveTournament.
  ///
  /// In en, this message translates to:
  /// **'Leave Tournament'**
  String get leaveTournament;

  /// No description provided for @leaveTournamentConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to leave this tournament?'**
  String get leaveTournamentConfirmation;

  /// No description provided for @selectTeam.
  ///
  /// In en, this message translates to:
  /// **'Select Team'**
  String get selectTeam;

  /// No description provided for @changePasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePasswordTitle;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @confirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get confirmNewPassword;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'New passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @passwordChangedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully'**
  String get passwordChangedSuccessfully;

  /// No description provided for @failedToChangePassword.
  ///
  /// In en, this message translates to:
  /// **'Failed to change password. Please check your old password.'**
  String get failedToChangePassword;

  /// No description provided for @pleaseEnterCurrentPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your current password'**
  String get pleaseEnterCurrentPassword;

  /// No description provided for @pleaseEnterNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter a new password'**
  String get pleaseEnterNewPassword;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMinLength;

  /// No description provided for @pleaseConfirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your new password'**
  String get pleaseConfirmNewPassword;

  /// No description provided for @passwordsDoNotMatchValidation.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatchValidation;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @deleteAccountConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account? This action cannot be undone.'**
  String get deleteAccountConfirmation;

  /// No description provided for @accountDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Account deleted successfully'**
  String get accountDeletedSuccessfully;

  /// No description provided for @failedToDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete account'**
  String get failedToDeleteAccount;

  /// No description provided for @deletePlayerProfile.
  ///
  /// In en, this message translates to:
  /// **'Delete Player Profile'**
  String get deletePlayerProfile;

  /// No description provided for @deletePlayerProfileConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your {gameName} profile?'**
  String deletePlayerProfileConfirmation(String gameName);

  /// No description provided for @playerProfileDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Player profile deleted successfully'**
  String get playerProfileDeletedSuccessfully;

  /// No description provided for @errorDeletingPlayerProfile.
  ///
  /// In en, this message translates to:
  /// **'Error deleting player profile'**
  String get errorDeletingPlayerProfile;

  /// No description provided for @pleaseSelectGame.
  ///
  /// In en, this message translates to:
  /// **'Please select a game'**
  String get pleaseSelectGame;

  /// No description provided for @playerProfileAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Player profile added successfully'**
  String get playerProfileAddedSuccessfully;

  /// No description provided for @playerProfileUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Player profile updated successfully'**
  String get playerProfileUpdatedSuccessfully;

  /// No description provided for @errorSavingPlayerProfile.
  ///
  /// In en, this message translates to:
  /// **'Error saving player profile'**
  String get errorSavingPlayerProfile;

  /// No description provided for @steamId.
  ///
  /// In en, this message translates to:
  /// **'Steam ID'**
  String get steamId;

  /// No description provided for @riotUsername.
  ///
  /// In en, this message translates to:
  /// **'Username (RIOT)'**
  String get riotUsername;

  /// No description provided for @riotTag.
  ///
  /// In en, this message translates to:
  /// **'Tag (RIOT)'**
  String get riotTag;

  /// No description provided for @riotRegion.
  ///
  /// In en, this message translates to:
  /// **'Region'**
  String get riotRegion;

  /// No description provided for @steam.
  ///
  /// In en, this message translates to:
  /// **'Steam'**
  String get steam;

  /// No description provided for @riot.
  ///
  /// In en, this message translates to:
  /// **'RIOT'**
  String get riot;

  /// No description provided for @selectGame.
  ///
  /// In en, this message translates to:
  /// **'Select a game'**
  String get selectGame;

  /// No description provided for @leaveTeamConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to leave this team?'**
  String get leaveTeamConfirmation;

  /// No description provided for @addPlayerProfile.
  ///
  /// In en, this message translates to:
  /// **'Add Player Profile'**
  String get addPlayerProfile;

  /// No description provided for @editPlayerProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Player Profile'**
  String get editPlayerProfile;

  /// No description provided for @gameLabel.
  ///
  /// In en, this message translates to:
  /// **'Game'**
  String get gameLabel;

  /// No description provided for @accountType.
  ///
  /// In en, this message translates to:
  /// **'Account Type'**
  String get accountType;

  /// No description provided for @viewTeamProfile.
  ///
  /// In en, this message translates to:
  /// **'View Team Profile'**
  String get viewTeamProfile;

  /// No description provided for @noGames.
  ///
  /// In en, this message translates to:
  /// **'No Games'**
  String get noGames;

  /// No description provided for @yearSingular.
  ///
  /// In en, this message translates to:
  /// **'year'**
  String get yearSingular;

  /// No description provided for @yearPlural.
  ///
  /// In en, this message translates to:
  /// **'years'**
  String get yearPlural;

  /// No description provided for @monthSingular.
  ///
  /// In en, this message translates to:
  /// **'month'**
  String get monthSingular;

  /// No description provided for @monthPlural.
  ///
  /// In en, this message translates to:
  /// **'months'**
  String get monthPlural;

  /// No description provided for @newTeam.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get newTeam;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'pt': return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
