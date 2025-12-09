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
  String get loginPasswordValidation => 'Password is required';

  @override
  String get loginUserValidation => 'The entered value doesn\'t look like an email';

  @override
  String get loginUserRequiredValidation => 'Email is required';

  @override
  String get loginForgotPassword => 'Forgot your password?';

  @override
  String get forgotPasswordTitle => 'Recover password';

  @override
  String get forgotPasswordSubtitle => 'Enter your email and we\'ll send you a link to reset your password';

  @override
  String get forgotPasswordEmailHint => 'Email';

  @override
  String get forgotPasswordButton => 'Send recovery link';

  @override
  String get forgotPasswordSuccess => 'An email has been sent with instructions to reset your password';

  @override
  String get forgotPasswordError => 'Error sending email. Please verify that the email is correct.';

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
  String notificationNewFollower(String name) {
    return '<b>$name</b> started following you.';
  }

  @override
  String notificationPostCommented(String name) {
    return '<b>$name</b> commented on your post.';
  }

  @override
  String notificationPostShared(String name) {
    return '<b>$name</b> shared your post.';
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
  String notificationTournamentRequestReceived(String name) {
    return '<b>$name</b> sent a tournament registration request.';
  }

  @override
  String notificationUserMentioned(String name) {
    return '<b>$name</b> mentioned you in a post.';
  }

  @override
  String notificationTeamRequestReceived(String name) {
    return '<b>$name</b> sent a team join request.';
  }

  @override
  String notificationTeamRequestAccepted(String name) {
    return '<b>$name</b> accepted your team join request.';
  }

  @override
  String notificationTournamentRequestAccepted(String name) {
    return '<b>$name</b> accepted your tournament registration request.';
  }

  @override
  String notificationPostModerated(String name) {
    return 'Your post has been moderated and not published due to inappropriate content. Please review our community policies.';
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
  String get unexpectedError => 'An unexpected error occurred. Please try again.';

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
  String get tournamentOfficialDescription => 'Organized by official game developers or sponsors';

  @override
  String get tournamentCommunityDescription => 'Organized by the community';

  @override
  String get tournamentParticipantsListLabel => 'List of registered participants will be displayed here';

  @override
  String get tournamentRegisteredTeamsLabel => 'Registered Teams';

  @override
  String get tournamentNoParticipantsLabel => 'No participants yet. Be the first to join!';

  @override
  String get tournamentRegistrationSuccess => 'Successfully registered for tournament!';

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
  String get tournamentFormOfficial => 'Official Tournament';

  @override
  String get tournamentFormOfficialSubtitle => 'Mark as official platform tournament';

  @override
  String get tournamentFormPrivate => 'Private Tournament';

  @override
  String get tournamentFormPrivateSubtitle => 'Only visible to invited participants';

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
  String get tournamentFormDeleteMessage => 'Are you sure you want to delete this tournament? This action cannot be undone.';

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
  String get tournamentFormValidationTitleMinLength => 'Title must have at least 3 characters';

  @override
  String get tournamentFormValidationDescriptionRequired => 'Description is required';

  @override
  String get tournamentFormValidationDescriptionMinLength => 'Description must have at least 10 characters';

  @override
  String get tournamentFormValidationGameRequired => 'You must select a game';

  @override
  String get tournamentFormValidationStartDateRequired => 'You must select a start date';

  @override
  String get tournamentFormValidationEndDateRequired => 'You must select an end date';

  @override
  String get tournamentFormValidationDateOrder => 'Start date must be before end date';

  @override
  String get tournamentFormValidationDatePast => 'Start date cannot be in the past';

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
  String get tournamentFormCheckBackLater => 'Check back later for new tournaments';

  @override
  String get tournamentFormPleaseFixErrors => 'Please fix the errors in the form';

  @override
  String get validationRequired => 'This field is required';

  @override
  String get validationFirstNameMin => 'First name must have at least 2 characters';

  @override
  String get validationFirstNameMax => 'First name must have at most 50 characters';

  @override
  String get validationLastNameMin => 'Last name must have at least 2 characters';

  @override
  String get validationLastNameMax => 'Last name must have at most 50 characters';

  @override
  String get validationInvalidEmail => 'Please enter a valid email address';

  @override
  String get validationUsernameMin => 'Username must have at least 3 characters';

  @override
  String get validationUsernameMax => 'Username must have at most 20 characters';

  @override
  String get validationUsernameInvalid => 'Username can only contain letters, numbers, underscores and dots';

  @override
  String get validationPasswordMinLength => 'Password must have at least 8 characters';

  @override
  String get validationPasswordHasUpperCase => 'Password must contain at least one uppercase letter';

  @override
  String get validationPasswordHasLowerCase => 'Password must contain at least one lowercase letter';

  @override
  String get validationPasswordHasNumber => 'Password must contain at least one number';

  @override
  String get validationPasswordHasSpecialChar => 'Password must contain at least one special character';

  @override
  String get validationPasswordsDontMatch => 'Passwords do not match';

  @override
  String get passwordRequirementsTitle => 'Password Requirements';

  @override
  String get registerFirstNameHint => 'First Name';

  @override
  String get registerLastNameHint => 'Last Name';

  @override
  String get registerUsernameHint => 'Username';

  @override
  String get registerEmailHint => 'Email';

  @override
  String get registerPasswordHint => 'Password';

  @override
  String get registerConfirmPasswordHint => 'Repeat password';

  @override
  String get registerButton => 'Register';

  @override
  String get registerAlreadyHaveAccount => 'Already have an account? Sign In';

  @override
  String get registerErrorCreatingAccount => 'Error creating account';

  @override
  String get editTeam => 'Edit Team';

  @override
  String get manageGames => 'Manage Games';

  @override
  String get teamRequests => 'Team Requests';

  @override
  String get requests => 'Requests';

  @override
  String get deleteTeam => 'Delete Team';

  @override
  String get leaveTeam => 'Leave Team';

  @override
  String get requestAccess => 'Request Access';

  @override
  String get removeMember => 'Remove Member';

  @override
  String get acceptRequest => 'Accept Request';

  @override
  String get declineRequest => 'Decline Request';

  @override
  String get teamUpdatedSuccessfully => 'Team updated successfully';

  @override
  String get errorUpdatingTeam => 'Error updating team';

  @override
  String get teamDeletedSuccessfully => 'Team deleted successfully';

  @override
  String get errorDeletingTeam => 'Error deleting team';

  @override
  String get leftTeamSuccessfully => 'Left team successfully';

  @override
  String get errorLeavingTeam => 'Error leaving team';

  @override
  String get accessRequestSent => 'Access request sent';

  @override
  String get errorSendingRequest => 'Error sending request';

  @override
  String get requestAccepted => 'Request accepted';

  @override
  String get errorAcceptingRequest => 'Error accepting request';

  @override
  String get requestDeclined => 'Request declined';

  @override
  String get errorDecliningRequest => 'Error declining request';

  @override
  String get memberRemovedFromTeam => 'Member removed from team';

  @override
  String get errorRemovingMember => 'Error removing member';

  @override
  String get gameAdded => 'Game added';

  @override
  String get errorAddingGame => 'Error adding game';

  @override
  String get gameRemoved => 'Game removed';

  @override
  String get errorRemovingGame => 'Error removing game';

  @override
  String get noPendingRequests => 'No pending requests';

  @override
  String get areYouSureDeleteTeam => 'Are you sure you want to delete this team? This action cannot be undone.';

  @override
  String get areYouSureLeaveTeam => 'Are you sure you want to leave this team?';

  @override
  String areYouSureRemoveMember(String name) {
    return 'Are you sure you want to remove $name from the team?';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get remove => 'Remove';

  @override
  String get delete => 'Delete';

  @override
  String get leave => 'Leave';

  @override
  String get teamName => 'Team Name';

  @override
  String get description => 'Description';

  @override
  String get waitingForApproval => 'Waiting for Approval';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get profileImage => 'Profile Image';

  @override
  String get backgroundImage => 'Background Image';

  @override
  String get changeProfileImage => 'Tap to change profile image';

  @override
  String get changeBackgroundImage => 'Change Background Image';

  @override
  String get dangerZone => 'Danger Zone';

  @override
  String get deleteTeamConfirmation => 'Are you sure you want to delete this team? This action cannot be undone.';

  @override
  String get resetPasswordTitle => 'Reset Password';

  @override
  String get resetPasswordSubtitle => 'Enter your new password below';

  @override
  String get resetPasswordSuccess => 'Password reset successfully! You can now log in with your new password.';

  @override
  String get resetPasswordGoToLogin => 'Go to Login';

  @override
  String get resetPasswordButton => 'Reset Password';

  @override
  String get resetPasswordInvalidToken => 'The token is invalid or has expired';

  @override
  String get resetPasswordError => 'Error resetting password. Please try again.';

  @override
  String get tournamentStatusFinished => 'Finished';

  @override
  String get tournamentStatusOngoing => 'Ongoing';

  @override
  String get tournamentStatusUpcoming => 'Upcoming';

  @override
  String get tournamentStatusLabel => 'Tournament Status';

  @override
  String get tournamentResponsible => 'Tournament Responsible';

  @override
  String get tournamentStartDate => 'Start';

  @override
  String get tournamentEndDate => 'End';

  @override
  String get tournamentPrize => 'Prize';

  @override
  String get tournamentUserNotAvailable => 'User not available';

  @override
  String get tournamentYouAreCreator => 'You are the creator';

  @override
  String tournamentYouAreRole(String role) {
    return 'You are $role';
  }

  @override
  String get loading => 'Loading...';

  @override
  String get tournamentPendingRequests => 'Pending Requests';

  @override
  String get tournamentNoPendingRequests => 'No pending requests';

  @override
  String get tournamentRequestCountSingular => '1 request';

  @override
  String tournamentRequestCountPlural(num count) {
    return '$count requests';
  }

  @override
  String get tournamentRequestRequested => 'Requested';

  @override
  String get tournamentAcceptRequest => 'Accept';

  @override
  String get tournamentDeclineRequest => 'Decline';

  @override
  String get tournamentAcceptRequestTitle => 'Accept Request';

  @override
  String tournamentAcceptRequestMessage(String teamName) {
    return 'Are you sure you want to accept the request from $teamName?';
  }

  @override
  String get tournamentDeclineRequestTitle => 'Decline Request';

  @override
  String tournamentDeclineRequestMessage(String teamName) {
    return 'Are you sure you want to decline the request from $teamName?';
  }

  @override
  String get tournamentRequestAccepted => 'Request accepted successfully';

  @override
  String get tournamentRequestDeclined => 'Request declined successfully';

  @override
  String get tournamentErrorAcceptingRequest => 'Error accepting request';

  @override
  String get tournamentErrorDecliningRequest => 'Error declining request';

  @override
  String get tournamentTabInfo => 'Information';

  @override
  String get tournamentTabRequests => 'Requests';

  @override
  String get optional => 'Optional';

  @override
  String get tournamentFormImage => 'Tournament Image';

  @override
  String get tournamentFormSelectImage => 'Select Image';

  @override
  String get tournamentFormRegion => 'Region';

  @override
  String get tournamentFormRegionHint => 'LATAM';

  @override
  String get tournamentFormSearchResponsible => 'Search Responsible';

  @override
  String get tournamentFormSearchResponsibleTitle => 'Search Responsible User';

  @override
  String get tournamentFormSelectMaxTeams => 'Select maximum teams';

  @override
  String get tournamentFormMinRank => 'Minimum Rank';

  @override
  String get tournamentFormMaxRank => 'Maximum Rank';

  @override
  String get tournamentFormRules => 'Tournament Rules';

  @override
  String get tournamentFormRulesList => 'List';

  @override
  String get tournamentFormRulesNumberedList => 'Numbered List';

  @override
  String get tournamentFormRulesBold => 'Bold';

  @override
  String get tournamentFormRulesItalic => 'Italic';

  @override
  String get tournamentFormRulesTitle => 'Title';

  @override
  String get tournamentFormRulesHint => 'Write the tournament rules...\n\nExample:\n# General Rules\n- Respect others\n- Punctuality\n\n# Game Rules\n1. First rule\n2. Second rule';

  @override
  String get tournamentFormRulesHelp => 'Use the buttons to add formatting. The text will be displayed as markdown.';

  @override
  String get username => 'Username';

  @override
  String get tournamentFormSearchUsernameHint => 'Search by username...';

  @override
  String get tournamentFormNoUsersFound => 'No users found';

  @override
  String get tournamentFormSearchMinChars => 'Type at least 3 characters to search';

  @override
  String get profileTabPosts => 'Posts';

  @override
  String get profileTabInfo => 'Information';

  @override
  String get tournamentFormMaxTeams => 'Maximum Teams';

  @override
  String get retryButton => 'Retry';

  @override
  String get noConversations => 'No conversations';

  @override
  String get errorLoadingConversations => 'Error loading conversations';

  @override
  String get chatLabel => 'Chat';

  @override
  String get onlineLabel => 'Online';

  @override
  String get editProfileTitle => 'Edit Profile';

  @override
  String errorLoadingSocialNetworks(String error) {
    return 'Error loading social networks: $error';
  }

  @override
  String errorPickingImage(String error) {
    return 'Error picking image: $error';
  }

  @override
  String get backgroundImageUpdatedSuccessfully => 'Background image updated successfully';

  @override
  String get failedToUpdateBackgroundImage => 'Failed to update background image';

  @override
  String get descriptionUpdatedSuccessfully => 'Description updated successfully';

  @override
  String get failedToUpdateDescription => 'Failed to update description';

  @override
  String addSocialNetwork(String networkName) {
    return 'Add $networkName';
  }

  @override
  String get usernameLabel => 'Username';

  @override
  String enterSocialNetworkUsername(String networkName) {
    return 'Enter your $networkName username';
  }

  @override
  String get addButton => 'Add';

  @override
  String socialNetworkAddedSuccessfully(String networkName) {
    return '$networkName added successfully';
  }

  @override
  String failedToAddSocialNetwork(String networkName) {
    return 'Failed to add $networkName';
  }

  @override
  String get removeNetwork => 'Remove Network';

  @override
  String areYouSureRemoveNetwork(String networkName) {
    return 'Are you sure you want to remove $networkName?';
  }

  @override
  String socialNetworkRemoved(String networkName) {
    return '$networkName removed';
  }

  @override
  String get backgroundImageLabel => 'Background Image';

  @override
  String get descriptionLabel => 'Description';

  @override
  String get tellUsAboutYourself => 'Tell us about yourself...';

  @override
  String get saveDescription => 'Save Description';

  @override
  String get socialNetworksLabel => 'Social Networks';

  @override
  String get yourNetworks => 'Your Networks:';

  @override
  String get addNetwork => 'Add Network:';

  @override
  String get mustBeInTeamToRegister => 'You must be in a team to register';

  @override
  String get noTeamsInTournament => 'You don\'t have teams in this tournament';

  @override
  String get leaveTournament => 'Leave Tournament';

  @override
  String get leaveTournamentConfirmation => 'Are you sure you want to leave this tournament?';

  @override
  String get selectTeam => 'Select Team';

  @override
  String get changePasswordTitle => 'Change Password';

  @override
  String get currentPassword => 'Current Password';

  @override
  String get newPassword => 'New Password';

  @override
  String get confirmNewPassword => 'Confirm New Password';

  @override
  String get passwordsDoNotMatch => 'New passwords do not match';

  @override
  String get passwordChangedSuccessfully => 'Password changed successfully';

  @override
  String get failedToChangePassword => 'Failed to change password. Please check your old password.';

  @override
  String get pleaseEnterCurrentPassword => 'Please enter your current password';

  @override
  String get pleaseEnterNewPassword => 'Please enter a new password';

  @override
  String get passwordMinLength => 'Password must be at least 6 characters';

  @override
  String get pleaseConfirmNewPassword => 'Please confirm your new password';

  @override
  String get passwordsDoNotMatchValidation => 'Passwords do not match';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get deleteAccountConfirmation => 'Are you sure you want to delete your account? This action cannot be undone.';

  @override
  String get accountDeletedSuccessfully => 'Account deleted successfully';

  @override
  String get failedToDeleteAccount => 'Failed to delete account';

  @override
  String get deletePlayerProfile => 'Delete Player Profile';

  @override
  String deletePlayerProfileConfirmation(String gameName) {
    return 'Are you sure you want to delete your $gameName profile?';
  }

  @override
  String get playerProfileDeletedSuccessfully => 'Player profile deleted successfully';

  @override
  String get errorDeletingPlayerProfile => 'Error deleting player profile';

  @override
  String get pleaseSelectGame => 'Please select a game';

  @override
  String get playerProfileAddedSuccessfully => 'Player profile added successfully';

  @override
  String get playerProfileUpdatedSuccessfully => 'Player profile updated successfully';

  @override
  String get errorSavingPlayerProfile => 'Error saving player profile';

  @override
  String get steamId => 'Steam ID';

  @override
  String get riotUsername => 'Username (RIOT)';

  @override
  String get riotTag => 'Tag (RIOT)';

  @override
  String get riotRegion => 'Region';

  @override
  String get steam => 'Steam';

  @override
  String get riot => 'RIOT';

  @override
  String get selectGame => 'Select a game';

  @override
  String get leaveTeamConfirmation => 'Are you sure you want to leave this team?';

  @override
  String get addPlayerProfile => 'Add Player Profile';

  @override
  String get editPlayerProfile => 'Edit Player Profile';

  @override
  String get gameLabel => 'Game';

  @override
  String get accountType => 'Account Type';

  @override
  String get viewTeamProfile => 'View Team Profile';

  @override
  String get noGames => 'No Games';

  @override
  String get yearSingular => 'year';

  @override
  String get yearPlural => 'years';

  @override
  String get monthSingular => 'month';

  @override
  String get monthPlural => 'months';

  @override
  String get newTeam => 'New';
}
