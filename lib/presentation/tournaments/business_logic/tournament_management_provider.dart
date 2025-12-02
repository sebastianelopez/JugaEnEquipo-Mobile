import 'package:flutter/material.dart';
import 'package:jugaenequipo/datasources/models/game_model.dart';
import 'package:jugaenequipo/datasources/models/tournament_model.dart';
import 'package:jugaenequipo/datasources/tournaments_use_cases/delete_tournament_use_case.dart'
    as delete_use_case;
import 'package:jugaenequipo/l10n/app_localizations.dart';

class TournamentManagementProvider extends ChangeNotifier {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController maxParticipantsController =
      TextEditingController();
  final TextEditingController prizePoolController = TextEditingController();

  String? selectedGameId;
  DateTime? startDate;
  DateTime? endDate;
  bool isOfficial = false;
  bool isPrivate = false;
  String tournamentType = 'single_elimination';
  String registrationDeadline = '1_week';

  bool isFormValid = false;
  String? titleError;
  String? descriptionError;
  String? gameError;
  String? dateError;

  bool isCreating = false;
  bool isUpdating = false;
  bool isDeleting = false;

  TournamentModel? tournamentToEdit;

  List<GameModel> availableGames = [
    GameModel(id: '1', name: 'Valorant', image: 'assets/valorant.png'),
    GameModel(id: '2', name: 'CS:GO', image: 'assets/csgo.png'),
    GameModel(id: '3', name: 'League of Legends', image: 'assets/lol.png'),
    GameModel(id: '4', name: 'Dota 2', image: 'assets/dota2.png'),
    GameModel(
        id: '5', name: 'Rocket League', image: 'assets/rocket_league.png'),
  ];

  List<Map<String, String>> getTournamentTypes(AppLocalizations l10n) {
    return [
      {
        'value': 'single_elimination',
        'label': l10n.tournamentFormTypeSingleElimination
      },
      {
        'value': 'double_elimination',
        'label': l10n.tournamentFormTypeDoubleElimination
      },
      {'value': 'round_robin', 'label': l10n.tournamentFormTypeRoundRobin},
      {'value': 'swiss_system', 'label': l10n.tournamentFormTypeSwissSystem},
    ];
  }

  List<Map<String, String>> getRegistrationDeadlines(AppLocalizations l10n) {
    return [
      {'value': '1_day', 'label': l10n.tournamentFormDeadline1Day},
      {'value': '3_days', 'label': l10n.tournamentFormDeadline3Days},
      {'value': '1_week', 'label': l10n.tournamentFormDeadline1Week},
      {'value': '2_weeks', 'label': l10n.tournamentFormDeadline2Weeks},
    ];
  }

  TournamentManagementProvider({TournamentModel? tournament}) {
    if (tournament != null) {
      _initializeForEdit(tournament);
    }
    // validateForm will be called from the UI with l10n context
  }

  void _initializeForEdit(TournamentModel tournament) {
    tournamentToEdit = tournament;
    titleController.text = tournament.title;
    descriptionController.text = tournament.description ?? '';
    
    // Validate that the game ID exists in availableGames before setting it
    final gameId = tournament.game.id;
    final gameExists = availableGames.any((game) => game.id == gameId);
    
    if (gameExists) {
      selectedGameId = gameId;
    } else {
      // If the game doesn't exist in the list, add it temporarily
      availableGames.add(
        GameModel(
          id: gameId,
          name: tournament.gameName,
          image: tournament.image,
        ),
      );
      selectedGameId = gameId;
    }
    
    startDate = tournament.startDate;
    endDate = tournament.endDate;
    isOfficial = tournament.isOfficial;
    isPrivate = tournament.isPrivate ?? false;
    maxParticipantsController.text =
        tournament.maxParticipants?.toString() ?? '';
    prizePoolController.text = tournament.prizePool?.toString() ?? '';

    tournamentType = tournament.tournamentType ?? 'single_elimination';

    registrationDeadline = tournament.registrationDeadline ?? '1_week';

    // validateForm will be called from the UI with l10n context
  }

  void setGame(String gameId) {
    selectedGameId = gameId;
    notifyListeners();
  }

  void setStartDate(DateTime date) {
    startDate = date;
    notifyListeners();
  }

  void setEndDate(DateTime date) {
    endDate = date;
    notifyListeners();
  }

  void setOfficial(bool value) {
    isOfficial = value;
    notifyListeners();
  }

  void setPrivate(bool value) {
    isPrivate = value;
    notifyListeners();
  }

  void setTournamentType(String type) {
    tournamentType = type;
    notifyListeners();
  }

  void setRegistrationDeadline(String deadline) {
    registrationDeadline = deadline;
    notifyListeners();
  }

  void validateForm(AppLocalizations l10n) {
    titleError = null;
    descriptionError = null;
    gameError = null;
    dateError = null;

    if (titleController.text.trim().isEmpty) {
      titleError = l10n.tournamentFormValidationTitleRequired;
    } else if (titleController.text.trim().length < 3) {
      titleError = l10n.tournamentFormValidationTitleMinLength;
    }

    if (descriptionController.text.trim().isEmpty) {
      descriptionError = l10n.tournamentFormValidationDescriptionRequired;
    } else if (descriptionController.text.trim().length < 10) {
      descriptionError = l10n.tournamentFormValidationDescriptionMinLength;
    }

    if (selectedGameId == null) {
      gameError = l10n.tournamentFormValidationGameRequired;
    }

    if (startDate == null) {
      dateError = l10n.tournamentFormValidationStartDateRequired;
    } else if (endDate == null) {
      dateError = l10n.tournamentFormValidationEndDateRequired;
    } else if (startDate!.isAfter(endDate!)) {
      dateError = l10n.tournamentFormValidationDateOrder;
    } else if (startDate!.isBefore(DateTime.now())) {
      dateError = l10n.tournamentFormValidationDatePast;
    }

    isFormValid = titleError == null &&
        descriptionError == null &&
        gameError == null &&
        dateError == null;

    notifyListeners();
  }

  void validateTitle(AppLocalizations l10n) {
    titleError = null;
    if (titleController.text.trim().isEmpty) {
      titleError = l10n.tournamentFormValidationTitleRequired;
    } else if (titleController.text.trim().length < 3) {
      titleError = l10n.tournamentFormValidationTitleMinLength;
    }
    _updateFormValidity();
    notifyListeners();
  }

  void validateDescription(AppLocalizations l10n) {
    descriptionError = null;
    if (descriptionController.text.trim().isEmpty) {
      descriptionError = l10n.tournamentFormValidationDescriptionRequired;
    } else if (descriptionController.text.trim().length < 10) {
      descriptionError = l10n.tournamentFormValidationDescriptionMinLength;
    }
    _updateFormValidity();
    notifyListeners();
  }

  void validateGame(AppLocalizations l10n) {
    gameError = null;
    if (selectedGameId == null) {
      gameError = l10n.tournamentFormValidationGameRequired;
    }
    _updateFormValidity();
    notifyListeners();
  }

  void validateDates(AppLocalizations l10n) {
    dateError = null;
    if (startDate == null) {
      dateError = l10n.tournamentFormValidationStartDateRequired;
    } else if (endDate == null) {
      dateError = l10n.tournamentFormValidationEndDateRequired;
    } else if (startDate!.isAfter(endDate!)) {
      dateError = l10n.tournamentFormValidationDateOrder;
    } else if (startDate!.isBefore(DateTime.now())) {
      dateError = l10n.tournamentFormValidationDatePast;
    }
    _updateFormValidity();
    notifyListeners();
  }

  void _updateFormValidity() {
    isFormValid = titleError == null &&
        descriptionError == null &&
        gameError == null &&
        dateError == null;
  }

  Future<bool> createTournament() async {
    if (!isFormValid) return false;

    isCreating = true;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // TODO: Implement actual API call
      // final result = await createTournamentUseCase(
      //   title: titleController.text.trim(),
      //   description: descriptionController.text.trim(),
      //   gameId: selectedGameId!,
      //   startDate: startDate!,
      //   endDate: endDate!,
      //   isOfficial: isOfficial,
      //   isPrivate: isPrivate,
      //   maxParticipants: int.tryParse(maxParticipantsController.text),
      //   prizePool: double.tryParse(prizePoolController.text),
      //   tournamentType: tournamentType,
      //   registrationDeadline: registrationDeadline,
      // );

      isCreating = false;
      notifyListeners();
      return true;
    } catch (e) {
      isCreating = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateTournament() async {
    if (!isFormValid || tournamentToEdit == null) return false;

    isUpdating = true;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // TODO: Implement actual API call
      // final result = await updateTournamentUseCase(
      //   tournamentId: tournamentToEdit!.id,
      //   title: titleController.text.trim(),
      //   description: descriptionController.text.trim(),
      //   gameId: selectedGameId!,
      //   startDate: startDate!,
      //   endDate: endDate!,
      //   isOfficial: isOfficial,
      //   isPrivate: isPrivate,
      //   maxParticipants: int.tryParse(maxParticipantsController.text),
      //   prizePool: double.tryParse(prizePoolController.text),
      //   tournamentType: tournamentType,
      //   registrationDeadline: registrationDeadline,
      // );

      isUpdating = false;
      notifyListeners();
      return true;
    } catch (e) {
      isUpdating = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteTournament() async {
    if (tournamentToEdit == null) return false;

    isDeleting = true;
    notifyListeners();

    try {
      final result = await delete_use_case.deleteTournament(
        tournamentId: tournamentToEdit!.id,
      );

      isDeleting = false;
      notifyListeners();
      return result;
    } catch (e) {
      isDeleting = false;
      notifyListeners();
      return false;
    }
  }

  bool get isEditing => tournamentToEdit != null;
  String getActionButtonText(AppLocalizations l10n) => isEditing
      ? l10n.tournamentFormUpdateButton
      : l10n.tournamentFormCreateButton;
  String getPageTitle(AppLocalizations l10n) => isEditing
      ? l10n.tournamentFormUpdateButton
      : l10n.tournamentFormCreateButton;

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    maxParticipantsController.dispose();
    prizePoolController.dispose();
    super.dispose();
  }
}
