// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get loginButton => 'Conecte-se';

  @override
  String get loginCreateAccountButton => 'Criar uma nova conta';

  @override
  String get loginUserHintText => 'Usuario';

  @override
  String get loginPasswordHintText => 'Senha';

  @override
  String get loginPasswordValidation =>
      'A senha deve ter pelo menos seis caracteres';

  @override
  String get loginUserValidation =>
      'O valor inserido não se parece com um e-mail';

  @override
  String get loginUserRequiredValidation => 'O e-mail é obrigatório';

  @override
  String get navSearchInputLabel => 'Busca';

  @override
  String get timePrefixText => '';

  @override
  String get timeYearSuffixText => 'ano atras';

  @override
  String get timeYearsSuffixText => 'anos atras';

  @override
  String get timeMonthSuffixText => 'mes atras';

  @override
  String get timeMonthsSuffixText => 'meses atras';

  @override
  String get timeWeekSuffixText => 'semana atras';

  @override
  String get timeWeeksSuffixText => 'semanas atras';

  @override
  String get timeDaySuffixText => 'dia atras';

  @override
  String get timeDaysSuffixText => 'dias atras';

  @override
  String get timeHourSuffixText => 'hora atras';

  @override
  String get timeHoursSuffixText => 'horas atras';

  @override
  String get timeMinuteSuffixText => 'minuto atras';

  @override
  String get timeMinutesSuffixText => 'minutos atras';

  @override
  String get timeSecondSuffixText => 'segundo atras';

  @override
  String get timeSecondsSuffixText => 'segundos atras';

  @override
  String get drawerlanguageLabel => 'Linguagem';

  @override
  String get drawerProfileLabel => 'Perfil';

  @override
  String get drawerSettingsLabel => 'Configurações';

  @override
  String get drawerLogoutLabel => 'Sair';

  @override
  String get profilePageLabel => 'Profile';

  @override
  String get profileFollowButtonLabel => 'Seguir';

  @override
  String get profileMessagesButtonLabel => 'Mensagens';

  @override
  String get profileSendMessageButtonLabel => 'Enviar mensagem';

  @override
  String get profileFollowingButtonLabel => 'Seguindo';

  @override
  String get profileFollowersButtonLabel => 'Seguidores';

  @override
  String get profilePrizesButtonLabel => 'Prêmios';

  @override
  String get messagesPageLabel => 'Mensagens';

  @override
  String get commentsModalLabel => 'Comentários';

  @override
  String get notificationsPageLabel => 'Notificações';

  @override
  String notificationPostLiked(String name) {
    return '<b>$name</b> gostou do seu post.';
  }

  @override
  String notificationInviteToTeam(String name, String team) {
    return '<b>$name</b> convidou você para fazer parte de sua equipe <b>$team</b>.';
  }

  @override
  String notificationApplicationAccepted(String role, String team) {
    return '<b>$team</b> aceitou sua inscrição para a posição de $role em Overwatch. Você agora é membro da equipe profissional.';
  }
}
