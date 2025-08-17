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
}
