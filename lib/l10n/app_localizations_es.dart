// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get loginButton => 'Ingresar';

  @override
  String get loginCreateAccountButton => 'Crear una nueva cuenta';

  @override
  String get loginUserHintText => 'Usuario';

  @override
  String get loginPasswordHintText => 'Contraseña';

  @override
  String get loginPasswordValidation =>
      'La contraseña debe contener al menos seis caracteres';

  @override
  String get loginUserValidation =>
      'El valor ingresado no parece un correo electrónico';

  @override
  String get loginUserRequiredValidation => 'El email es obligatorio';

  @override
  String get navSearchInputLabel => 'Buscar';

  @override
  String get advancedSearchTitle => 'Busqueda avanzada';

  @override
  String get advancedSearchPlayersButton => 'Buscar jugadores';

  @override
  String get advancedSearchTeamsButton => 'Buscar equipos';

  @override
  String get advancedSearchTeams => 'Equipos';

  @override
  String get advancedSearchPlayers => 'Jugadores';

  @override
  String get advancedSearchGame => 'Juego';

  @override
  String get advancedSearchRole => 'Rol';

  @override
  String get advancedSearchRanking => 'Ranking';

  @override
  String get timePrefixText => 'Hace ';

  @override
  String get timeYearSuffixText => 'año';

  @override
  String get timeYearsSuffixText => 'años';

  @override
  String get timeMonthSuffixText => 'mes';

  @override
  String get timeMonthsSuffixText => 'meses';

  @override
  String get timeWeekSuffixText => 'semana';

  @override
  String get timeWeeksSuffixText => 'semanas';

  @override
  String get timeDaySuffixText => 'día';

  @override
  String get timeDaysSuffixText => 'días';

  @override
  String get timeHourSuffixText => 'hora';

  @override
  String get timeHoursSuffixText => 'horas';

  @override
  String get timeMinuteSuffixText => 'minuto';

  @override
  String get timeMinutesSuffixText => 'minutos';

  @override
  String get timeSecondSuffixText => 'segundo';

  @override
  String get timeSecondsSuffixText => 'segundos';

  @override
  String get drawerlanguageLabel => 'Idioma';

  @override
  String get drawerProfileLabel => 'Perfil';

  @override
  String get drawerSettingsLabel => 'Configuracion';

  @override
  String get drawerLogoutLabel => 'Cerrar sesion';

  @override
  String get profilePageLabel => 'Perfil';

  @override
  String get profileFollowButtonLabel => 'Seguir';

  @override
  String get profileUnfollowButtonLabel => 'Dejar de seguir';

  @override
  String get profileMessagesButtonLabel => 'Mensajes';

  @override
  String get profileSendMessageButtonLabel => 'Enviar mensaje';

  @override
  String get profileFollowingButtonLabel => 'Siguiendo';

  @override
  String get profileFollowersButtonLabel => 'Seguidores';

  @override
  String get profilePrizesButtonLabel => 'Premios';

  @override
  String get messagesPageLabel => 'Mensajes';

  @override
  String get commentsModalLabel => 'Comentarios';

  @override
  String get notificationsPageLabel => 'Notificaciones';

  @override
  String notificationPostLiked(String name) {
    return 'A <b>$name</b> le gustó tu publicacion.';
  }

  @override
  String notificationInviteToTeam(String name, String team) {
    return '<b>$name</b> te ha invitado a formar parte de su equipo <b>$team</b>.';
  }

  @override
  String notificationApplicationAccepted(String role, String team) {
    return '<b>$team</b> ha aceptado tu postulacion para el puesto de $role en Overwatch. Ahora eres miembro del equipo profesional.';
  }

  @override
  String get errorTitle => 'Error';

  @override
  String get errorMessage =>
      'Ha ocurrido un error. Por favor, inténtalo de nuevo.';

  @override
  String get okButton => 'Aceptar';

  @override
  String get editProfileButtonLabel => 'Editar perfil';

  @override
  String get userNotFound => 'Usuario no encontrado';

  @override
  String get teamNotFound => 'Equipo no encontrado';

  @override
  String get tryAgain => 'Intentar de nuevo';

  @override
  String get teamIdRequired => 'ID del equipo es requerido';

  @override
  String get prizesContent => 'El contenido de premios va aquí';

  @override
  String get teamMembersTitle => 'Miembros del Equipo';

  @override
  String get teamTournamentsTitle => 'Torneos del Equipo';

  @override
  String get teamWinsTitle => 'Victorias del Equipo';

  @override
  String get teamTournamentsList => 'Lista de torneos participados';

  @override
  String get teamWinsHistory => 'Historial de victorias';

  @override
  String get verifyImageTitle => 'Ver imagen';

  @override
  String get changeProfileImageTitle => 'Cambiar imagen de perfil';

  @override
  String get deletePost => 'Eliminar publicación';

  @override
  String searchTeamSnackbar(String name) {
    return 'Equipo: $name';
  }

  @override
  String get noPostsYet => 'No hay publicaciones aún';

  @override
  String get followToSeePosts =>
      'Sigue a un equipo o jugador para ver sus publicaciones.';

  @override
  String get searchUsersTeams => 'Busca usuarios o equipos';

  @override
  String get playersSection => 'Jugadores';

  @override
  String get teamsSection => 'Equipos';

  @override
  String get verifiedStatus => 'Verificado';

  @override
  String get pendingStatus => 'Pendiente';

  @override
  String get membersLabel => 'Miembros';

  @override
  String get gamesLabel => 'Juegos';

  @override
  String get searchPlayersHint => 'Buscar jugadores...';

  @override
  String get searchTeamsHint => 'Buscar equipos...';

  @override
  String get teamSizeFilter => 'Tamaño del Equipo';

  @override
  String get verifiedTeamsOnly => 'Solo equipos verificados';

  @override
  String playersSearchResult(String filters) {
    return 'Búsqueda de jugadores con filtros: $filters';
  }

  @override
  String teamsSearchResult(String filters) {
    return 'Búsqueda de equipos con filtros: $filters';
  }

  @override
  String get viewMembersButtonLabel => 'Ver miembros';

  @override
  String get contactButtonLabel => 'Contactar';

  @override
  String get statisticsLabel => 'Estadísticas';

  @override
  String get tournamentsPlayedLabel => 'Torneos jugados';

  @override
  String get winsLabel => 'Victorias';

  @override
  String get photoGalleryOption => 'Galería de fotos';

  @override
  String get cameraOption => 'Cámara';

  @override
  String get unauthorizedError => 'No autorizado';

  @override
  String get unexpectedError =>
      'Ocurrió un error inesperado. Por favor, inténtalo de nuevo.';

  @override
  String get acceptButton => 'Aceptar';

  @override
  String get incorrectCredentials => 'El mail o la contraseña no son correctas';

  @override
  String get photoVideoButton => 'Foto / Video';

  @override
  String get writeMessageHint => 'Escribir mensaje...';

  @override
  String get tournamentTitleColumn => 'Título';

  @override
  String get officialColumn => 'Oficial';

  @override
  String get gameColumn => 'Juego';

  @override
  String get registeredPlayersColumn => 'Jugadores inscriptos';

  @override
  String get settingsLabel => 'Configuración';

  @override
  String get darkmodeLabel => 'Modo oscuro';

  @override
  String get languageLabel => 'Idioma';

  @override
  String get commentsLabel => 'comentarios';

  @override
  String get imageNotSupported => 'Este tipo de imagen no es compatible';

  @override
  String get pickImageError => 'Error al seleccionar imagen';

  @override
  String get noImageSelected => 'Aún no has seleccionado una imagen.';

  @override
  String get errorLoadingUserProfile => 'Error al cargar el perfil del usuario';

  @override
  String get tournamentDetailsTitle => 'Detalles del Torneo';

  @override
  String get tournamentParticipantsLabel => 'Participantes';

  @override
  String get tournamentGameInfoLabel => 'Información del Juego';

  @override
  String get tournamentGameTypeLabel => 'Tipo de Juego';

  @override
  String get tournamentOfficialLabel => 'Torneo Oficial';

  @override
  String get tournamentCommunityLabel => 'Torneo Comunitario';

  @override
  String get tournamentOfficialDescription =>
      'Organizado por desarrolladores oficiales o patrocinadores';

  @override
  String get tournamentCommunityDescription => 'Organizado por la comunidad';

  @override
  String get tournamentParticipantsListLabel =>
      'La lista de participantes registrados se mostrará aquí';

  @override
  String get tournamentNoParticipantsLabel =>
      'Aún no hay participantes. ¡Sé el primero en unirte!';

  @override
  String get tournamentRegistrationSuccess =>
      '¡Te has registrado exitosamente para el torneo!';

  @override
  String get tournamentAlreadyRegisteredLabel => 'Ya Registrado';

  @override
  String get tournamentRegisterButtonLabel => 'Registrarse para el Torneo';

  @override
  String get tournamentAdditionalInfoLabel => 'Información Adicional';

  @override
  String get tournamentStartDateLabel => 'Fecha de Inicio';

  @override
  String get tournamentStartDatePlaceholder => 'Por anunciar';

  @override
  String get tournamentLocationLabel => 'Ubicación';

  @override
  String get tournamentLocationPlaceholder => 'En línea';

  @override
  String get tournamentPrizePoolLabel => 'Premio del Torneo';

  @override
  String get tournamentPrizePoolPlaceholder => 'Por anunciar';
}
