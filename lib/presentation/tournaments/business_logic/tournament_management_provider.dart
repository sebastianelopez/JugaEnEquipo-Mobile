import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jugaenequipo/datasources/models/game_model.dart';
import 'package:jugaenequipo/datasources/models/tournament_model.dart';
import 'package:jugaenequipo/datasources/models/user_model.dart';
import 'package:jugaenequipo/datasources/tournaments_use_cases/delete_tournament_use_case.dart'
    as delete_use_case;
import 'package:jugaenequipo/datasources/tournaments_use_cases/create_tournament_use_case.dart'
    as create_use_case;
import 'package:jugaenequipo/datasources/tournaments_use_cases/update_tournament_background_image_use_case.dart';
import 'package:jugaenequipo/datasources/games_use_cases/search_games_use_case.dart';
import 'package:jugaenequipo/datasources/games_use_cases/get_game_ranks_use_case.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';

class TournamentManagementProvider extends ChangeNotifier {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController rulesController = TextEditingController();
  final TextEditingController regionController = TextEditingController();

  String? selectedGameId;
  String? selectedResponsibleId;
  String? selectedMinRankId;
  String? selectedMaxRankId;
  int? maxTeams;
  DateTime? startDate;
  DateTime? endDate;

  bool isFormValid = false;
  String? titleError;
  String? descriptionError;
  String? gameError;
  String? dateError;

  bool isCreating = false;
  bool isUpdating = false;
  bool isDeleting = false;
  bool isLoadingGames = false;
  bool isLoadingRanks = false;
  String? gamesError;
  String? ranksError;

  TournamentModel? tournamentToEdit;

  List<GameModel> availableGames = [];
  List<GameRankModel> availableRanks = [];
  UserModel? selectedResponsible;
  XFile? selectedImage;
  String? selectedImageUrl;

  TournamentManagementProvider({TournamentModel? tournament}) {
    _loadAvailableGames();
    if (tournament != null) {
      _initializeForEdit(tournament);
    }
  }

  Future<void> _loadAvailableGames() async {
    isLoadingGames = true;
    gamesError = null;
    notifyListeners();

    try {
      final games = await searchGames();
      if (games != null && games.isNotEmpty) {
        availableGames = games;
        gamesError = null;
      } else {
        gamesError = 'No se pudieron cargar los juegos';
      }
    } catch (e) {
      gamesError = 'Error al cargar juegos: $e';
    } finally {
      isLoadingGames = false;
      notifyListeners();
    }
  }

  void _initializeForEdit(TournamentModel tournament) {
    tournamentToEdit = tournament;
    titleController.text = tournament.title;
    descriptionController.text = tournament.description ?? '';
    rulesController.text = tournament.rules ?? '';
    regionController.text = tournament.region;

    final gameId = tournament.game.id;
    final gameExists = availableGames.any((game) => game.id == gameId);

    if (gameExists) {
      selectedGameId = gameId;
      _loadRanksForGame(gameId);
    } else {
      availableGames.add(
        GameModel(
          id: gameId,
          name: tournament.gameName,
          image: tournament.image,
        ),
      );
      selectedGameId = gameId;
      _loadRanksForGame(gameId);
    }

    startDate = tournament.startDate;
    endDate = tournament.endDate;
    maxTeams = tournament.maxParticipants;

    selectedResponsibleId = tournament.responsibleId;
    selectedMinRankId = tournament.minGameRankId;
    selectedMaxRankId = tournament.maxGameRankId;
    selectedImageUrl = tournament.image;
  }

  Future<void> _loadRanksForGame(String gameId) async {
    isLoadingRanks = true;
    ranksError = null;
    availableRanks = [];
    notifyListeners();

    try {
      final ranks = await getGameRanks(gameId: gameId);
      if (ranks != null && ranks.isNotEmpty) {
        availableRanks = ranks;
        ranksError = null;
      } else {
        ranksError = 'No se pudieron cargar los rangos';
      }
    } catch (e) {
      ranksError = 'Error al cargar rangos: $e';
    } finally {
      isLoadingRanks = false;
      notifyListeners();
    }
  }

  void setGame(String gameId) {
    selectedGameId = gameId;
    selectedMinRankId = null;
    selectedMaxRankId = null;
    _loadRanksForGame(gameId);
    notifyListeners();
  }

  void setResponsible(UserModel user) {
    selectedResponsible = user;
    selectedResponsibleId = user.id;
    notifyListeners();
  }

  void clearResponsible() {
    selectedResponsible = null;
    selectedResponsibleId = null;
    notifyListeners();
  }

  void setMinRank(String? rankId) {
    selectedMinRankId = rankId;
    notifyListeners();
  }

  void setMaxRank(String? rankId) {
    selectedMaxRankId = rankId;
    notifyListeners();
  }

  void setMaxTeams(int teams) {
    maxTeams = teams;
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

  Future<void> selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 600,
      imageQuality: 60,
    );

    if (pickedFile != null) {
      selectedImage = pickedFile;
      _updateFormValidity();
      notifyListeners();
    }
  }

  void clearImage() {
    selectedImage = null;
    selectedImageUrl = null;
    _updateFormValidity();
    notifyListeners();
  }

  List<int> getAvailableTeamSizes() {
    // Return even numbers from 2 to 20
    return List.generate(10, (index) => (index + 1) * 2);
  }

  String? regionError;
  String? responsibleError;

  void validateForm(AppLocalizations l10n) {
    titleError = null;
    descriptionError = null;
    gameError = null;
    dateError = null;
    regionError = null;
    responsibleError = null;

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

    if (regionController.text.trim().isEmpty) {
      regionError = 'La región es requerida';
    }

    if (selectedResponsibleId == null) {
      responsibleError = 'Debes seleccionar un responsable';
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
        dateError == null &&
        regionError == null &&
        responsibleError == null;

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
        dateError == null &&
        regionError == null &&
        responsibleError == null;
  }

  Future<bool> createTournament() async {
    debugPrint('=== CREATE TOURNAMENT STARTED ===');
    debugPrint('isFormValid: $isFormValid');
    debugPrint('Fields:');
    debugPrint('  - name: ${titleController.text.trim()}');
    debugPrint('  - description: ${descriptionController.text.trim()}');
    debugPrint('  - rules: ${rulesController.text.trim()}');
    debugPrint('  - gameId: $selectedGameId');
    debugPrint('  - region: ${regionController.text.trim()}');
    debugPrint('  - maxTeams: $maxTeams');
    debugPrint('  - startAt: $startDate');
    debugPrint('  - endAt: $endDate');
    debugPrint('  - responsibleId: $selectedResponsibleId');
    debugPrint('  - minGameRankId: $selectedMinRankId');
    debugPrint('  - maxGameRankId: $selectedMaxRankId');
    debugPrint('  - hasImage: ${selectedImage != null}');

    if (!isFormValid) {
      debugPrint('VALIDATION FAILED:');
      debugPrint('  - titleError: $titleError');
      debugPrint('  - descriptionError: $descriptionError');
      debugPrint('  - gameError: $gameError');
      debugPrint('  - dateError: $dateError');
      debugPrint('  - regionError: $regionError');
      debugPrint('  - responsibleError: $responsibleError');
      return false;
    }

    isCreating = true;
    notifyListeners();

    try {
      debugPrint('Calling create_use_case.createTournament...');
      final result = await create_use_case.createTournament(
        name: titleController.text.trim(),
        description: descriptionController.text.trim(),
        rules: rulesController.text.trim(),
        gameId: selectedGameId!,
        region: regionController.text.trim(),
        maxTeams: maxTeams ?? 8, // Default to 8 if not set
        startAt: startDate!,
        endAt: endDate!,
        responsibleId: selectedResponsibleId!,
        minGameRankId: selectedMinRankId,
        maxGameRankId: selectedMaxRankId,
        image: selectedImage,
      );

      debugPrint('create_use_case.createTournament result: $result');

      final success = result != null;

      // If tournament created successfully and there's an image, upload it
      if (success && selectedImage != null && result['tournamentId'] != null) {
        debugPrint(
            'Uploading background image for tournament ${result['tournamentId']}...');
        final imageUploaded = await updateTournamentBackgroundImage(
          tournamentId: result['tournamentId'] as String,
          image: selectedImage!,
        );
        if (kDebugMode) {
          debugPrint(
              'Background image upload: ${imageUploaded ? "SUCCESS" : "FAILED"}');
        }
      }

      isCreating = false;
      notifyListeners();

      debugPrint(
          '=== CREATE TOURNAMENT FINISHED: ${success ? "SUCCESS" : "FAILED"} ===');
      return success;
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('Error creating tournament: $e');
        debugPrint('Stack trace: $stackTrace');
      }
      isCreating = false;
      notifyListeners();
      debugPrint('=== CREATE TOURNAMENT FINISHED: EXCEPTION ===');
      return false;
    }
  }

  Future<bool> updateTournament() async {
    if (!isFormValid || tournamentToEdit == null) return false;

    isUpdating = true;
    notifyListeners();

    try {
      debugPrint('Calling create_use_case.createTournament (UPDATE mode)...');
      // Use the same createTournament use case, but pass the tournamentId
      final result = await create_use_case.createTournament(
        tournamentId: tournamentToEdit!.id, // Pass existing ID for update
        name: titleController.text.trim(),
        description: descriptionController.text.trim(),
        rules: rulesController.text.trim(),
        gameId: selectedGameId!,
        region: regionController.text.trim(),
        maxTeams: maxTeams ?? 8,
        startAt: startDate!,
        endAt: endDate!,
        responsibleId: selectedResponsibleId!,
        minGameRankId: selectedMinRankId,
        maxGameRankId: selectedMaxRankId,
        image: selectedImage,
      );

      debugPrint('create_use_case.createTournament (UPDATE) result: $result');

      final success = result != null;

      // If tournament updated successfully and there's an image, upload it
      if (success && selectedImage != null) {
        debugPrint(
            'Uploading background image for tournament ${tournamentToEdit!.id}...');
        final imageUploaded = await updateTournamentBackgroundImage(
          tournamentId: tournamentToEdit!.id,
          image: selectedImage!,
        );
        if (kDebugMode) {
          debugPrint(
              'Background image upload: ${imageUploaded ? "SUCCESS" : "FAILED"}');
        }
      }

      isUpdating = false;
      notifyListeners();

      debugPrint(
          '=== UPDATE TOURNAMENT FINISHED: ${success ? "SUCCESS" : "FAILED"} ===');
      return success;
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('Error updating tournament: $e');
        debugPrint('Stack trace: $stackTrace');
      }
      isUpdating = false;
      notifyListeners();
      debugPrint('=== UPDATE TOURNAMENT FINISHED: EXCEPTION ===');
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
    rulesController.dispose();
    regionController.dispose();
    super.dispose();
  }
}
