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
  String get advancedSearchTitle => 'Advanced search';

  @override
  String get advancedSearchPlayersButton => 'Search players';

  @override
  String get advancedSearchTeamsButton => 'Search teams';

  @override
  String get advancedSearchTeams => 'Teams';

  @override
  String get advancedSearchPlayers => 'Players';

  @override
  String get advancedSearchGame => 'Game';

  @override
  String get advancedSearchRole => 'Role';

  @override
  String get advancedSearchRanking => 'Ranking';

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
  String get profileUnfollowButtonLabel => 'Unfollow';

  @override
  String get profileMessagesButtonLabel => 'Messages';

  @override
  String get profileSendMessageButtonLabel => 'Send message';

  @override
  String get profileFollowingButtonLabel => 'Following';

  @override
  String get profileFollowersButtonLabel => 'Followers';

  @override
  String get profilePrizesButtonLabel => 'Prizes';

  @override
  String get memberSinceLabel => 'Member since';

  @override
  String get tournamentWinsLabel => 'Tournament Wins';

  @override
  String get socialMediaLabel => 'Social Media';

  @override
  String get achievementsAwardsLabel => 'Achievements & Awards';

  @override
  String get postsLabel => 'Posts';

  @override
  String get profileTeamsLabel => 'Teams';

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

  @override
  String get errorTitle => 'Error';

  @override
  String get errorMessage => 'An error has occurred. Please try again.';

  @override
  String get okButton => 'OK';

  @override
  String get editProfileButtonLabel => 'Edit profile';

  @override
  String get userNotFound => 'User not found';

  @override
  String get teamNotFound => 'Team not found';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get teamIdRequired => 'Team ID is required';

  @override
  String get prizesContent => 'Prizes content goes here';

  @override
  String get teamMembersTitle => 'Team Members';

  @override
  String get teamTournamentsTitle => 'Team Tournaments';

  @override
  String get teamWinsTitle => 'Team Wins';

  @override
  String get teamTournamentsList => 'List of participated tournaments';

  @override
  String get teamWinsHistory => 'Win history';

  @override
  String get verifyImageTitle => 'View image';

  @override
  String get changeProfileImageTitle => 'Change profile image';

  @override
  String get deletePost => 'Delete post';

  @override
  String searchTeamSnackbar(String name) {
    return 'Team: $name';
  }

  @override
  String get noPostsYet => 'No posts yet';

  @override
  String get followToSeePosts => 'Follow a team or player to see their posts.';

  @override
  String get searchUsersTeams => 'Search users or teams';

  @override
  String get playersSection => 'Players';

  @override
  String get teamsSection => 'Teams';

  @override
  String get verifiedStatus => 'Verified';

  @override
  String get pendingStatus => 'Pending';

  @override
  String get membersLabel => 'Members';

  @override
  String get gamesLabel => 'Games';

  @override
  String get searchPlayersHint => 'Search players...';

  @override
  String get searchTeamsHint => 'Search teams...';

  @override
  String get teamSizeFilter => 'Team Size';

  @override
  String get verifiedTeamsOnly => 'Verified teams only';

  @override
  String playersSearchResult(String filters) {
    return 'Player search with filters: $filters';
  }

  @override
  String teamsSearchResult(String filters) {
    return 'Team search with filters: $filters';
  }

  @override
  String get viewMembersButtonLabel => 'View members';

  @override
  String get contactButtonLabel => 'Contact';

  @override
  String get statisticsLabel => 'Statistics';

  @override
  String get tournamentsPlayedLabel => 'Tournaments played';

  @override
  String get winsLabel => 'Wins';

  @override
  String get photoGalleryOption => 'Photo Gallery';

  @override
  String get cameraOption => 'Camera';

  @override
  String get unauthorizedError => 'Unauthorized';

  @override
  String get unexpectedError =>
      'An unexpected error occurred. Please try again.';

  @override
  String get acceptButton => 'Accept';

  @override
  String get incorrectCredentials => 'The email or password is incorrect';

  @override
  String get photoVideoButton => 'Photo / Video';

  @override
  String get writeMessageHint => 'Write message...';

  @override
  String get tournamentTitleColumn => 'Title';

  @override
  String get officialColumn => 'Official';

  @override
  String get gameColumn => 'Game';

  @override
  String get registeredPlayersColumn => 'Registered players';

  @override
  String get settingsLabel => 'Settings';

  @override
  String get darkmodeLabel => 'Darkmode';

  @override
  String get languageLabel => 'Language';

  @override
  String get commentsLabel => 'comments';

  @override
  String get imageNotSupported => 'This image type is not supported';

  @override
  String get pickImageError => 'Pick image error';

  @override
  String get noImageSelected => 'You have not yet picked an image.';

  @override
  String get errorLoadingUserProfile => 'Error loading user profile';

  @override
  String get tournamentDetailsTitle => 'Tournament Details';

  @override
  String get tournamentParticipantsLabel => 'Participants';

  @override
  String get tournamentGameInfoLabel => 'Game Information';

  @override
  String get tournamentGameTypeLabel => 'Game Type';

  @override
  String get tournamentOfficialLabel => 'Official Tournament';

  @override
  String get tournamentCommunityLabel => 'Community Tournament';

  @override
  String get tournamentOfficialDescription =>
      'Organized by official game developers or sponsors';

  @override
  String get tournamentCommunityDescription => 'Organized by the community';

  @override
  String get tournamentParticipantsListLabel =>
      'List of registered participants will be displayed here';

  @override
  String get tournamentNoParticipantsLabel =>
      'No participants yet. Be the first to join!';

  @override
  String get tournamentRegistrationSuccess =>
      'Successfully registered for tournament!';

  @override
  String get tournamentAlreadyRegisteredLabel => 'Already Registered';

  @override
  String get tournamentRegisterButtonLabel => 'Register for Tournament';

  @override
  String get tournamentAdditionalInfoLabel => 'Additional Information';

  @override
  String get tournamentStartDateLabel => 'Start Date';

  @override
  String get tournamentStartDatePlaceholder => 'To be announced';

  @override
  String get tournamentLocationLabel => 'Location';

  @override
  String get tournamentLocationPlaceholder => 'Online';

  @override
  String get tournamentPrizePoolLabel => 'Prize Pool';

  @override
  String get tournamentPrizePoolPlaceholder => 'To be announced';

  @override
  String get tournamentFormTitle => 'Tournament Title';

  @override
  String get tournamentFormTitleHint => 'Ex: Summer Cup 2024';

  @override
  String get tournamentFormDescription => 'Description';

  @override
  String get tournamentFormDescriptionHint => 'Describe your tournament...';

  @override
  String get tournamentFormGame => 'Game';

  @override
  String get tournamentFormGameHint => 'Select a game';

  @override
  String get tournamentFormType => 'Tournament Format';

  @override
  String get tournamentFormDates => 'Tournament Dates';

  @override
  String get tournamentFormStartDate => 'Start Date';

  @override
  String get tournamentFormEndDate => 'End Date';

  @override
  String get tournamentFormSelectDate => 'Select date';

  @override
  String get tournamentFormRegistrationDeadline => 'Registration Deadline';

  @override
  String get tournamentFormConfiguration => 'Configuration';

  @override
  String get tournamentFormOfficial => 'Official';

  @override
  String get tournamentFormOfficialSubtitle =>
      'Mark as official platform tournament';

  @override
  String get tournamentFormPrivate => 'Private Tournament';

  @override
  String get tournamentFormPrivateSubtitle =>
      'Only visible to invited participants';

  @override
  String get tournamentFormMaxParticipants => 'Max Participants';

  @override
  String get tournamentFormPrizePool => 'Total Prize (\$)';

  @override
  String get tournamentFormCreateButton => 'Create Tournament';

  @override
  String get tournamentFormUpdateButton => 'Update Tournament';

  @override
  String get tournamentFormCancelButton => 'Cancel';

  @override
  String get tournamentFormDeleteButton => 'Delete';

  @override
  String get tournamentFormDeleteTitle => 'Delete Tournament';

  @override
  String get tournamentFormDeleteMessage =>
      'Are you sure you want to delete this tournament? This action cannot be undone.';

  @override
  String get tournamentFormDeleteConfirm => 'Delete';

  @override
  String get tournamentFormDeleteCancel => 'Cancel';

  @override
  String get tournamentFormSuccessCreate => 'Tournament created successfully';

  @override
  String get tournamentFormSuccessUpdate => 'Tournament updated successfully';

  @override
  String get tournamentFormSuccessDelete => 'Tournament deleted successfully';

  @override
  String get tournamentFormErrorCreate => 'Error creating tournament';

  @override
  String get tournamentFormErrorUpdate => 'Error updating tournament';

  @override
  String get tournamentFormErrorDelete => 'Error deleting tournament';

  @override
  String get tournamentFormValidationTitleRequired => 'Title is required';

  @override
  String get tournamentFormValidationTitleMinLength =>
      'Title must have at least 3 characters';

  @override
  String get tournamentFormValidationDescriptionRequired =>
      'Description is required';

  @override
  String get tournamentFormValidationDescriptionMinLength =>
      'Description must have at least 10 characters';

  @override
  String get tournamentFormValidationGameRequired => 'You must select a game';

  @override
  String get tournamentFormValidationStartDateRequired =>
      'You must select a start date';

  @override
  String get tournamentFormValidationEndDateRequired =>
      'You must select an end date';

  @override
  String get tournamentFormValidationDateOrder =>
      'Start date must be before end date';

  @override
  String get tournamentFormValidationDatePast =>
      'Start date cannot be in the past';

  @override
  String get tournamentFormTypeSingleElimination => 'Single Elimination';

  @override
  String get tournamentFormTypeDoubleElimination => 'Double Elimination';

  @override
  String get tournamentFormTypeRoundRobin => 'Round Robin';

  @override
  String get tournamentFormTypeSwissSystem => 'Swiss System';

  @override
  String get tournamentFormDeadline1Day => '1 day before';

  @override
  String get tournamentFormDeadline3Days => '3 days before';

  @override
  String get tournamentFormDeadline1Week => '1 week before';

  @override
  String get tournamentFormDeadline2Weeks => '2 weeks before';

  @override
  String get tournamentFormSelectGame => 'Select a game';

  @override
  String get tournamentFormViewDetails => 'View Details';

  @override
  String get tournamentFormPlayers => 'Players';

  @override
  String get tournamentFormEdit => 'Edit';

  @override
  String get tournamentFormDelete => 'Delete';

  @override
  String tournamentFormTournamentDeleted(String title) {
    return 'Tournament \"$title\" deleted';
  }

  @override
  String get tournamentFormLoadingTournaments => 'Loading tournaments...';

  @override
  String get tournamentFormNoTournamentsAvailable => 'No tournaments available';

  @override
  String get tournamentFormCheckBackLater =>
      'Check back later for new tournaments';

  @override
  String get tournamentFormPleaseFixErrors =>
      'Please fix the errors in the form';
}
