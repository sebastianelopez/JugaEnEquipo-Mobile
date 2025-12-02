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
  String get loginPasswordValidation => 'A senha é obrigatória';

  @override
  String get loginUserValidation => 'O valor inserido não se parece com um e-mail';

  @override
  String get loginUserRequiredValidation => 'O e-mail é obrigatório';

  @override
  String get navSearchInputLabel => 'Busca';

  @override
  String get advancedSearchTitle => 'Busca avançada';

  @override
  String get advancedSearchPlayersButton => 'Buscar jogadores';

  @override
  String get advancedSearchTeamsButton => 'Buscar equipes';

  @override
  String get advancedSearchTeams => 'Equipes';

  @override
  String get advancedSearchPlayers => 'Jogadores';

  @override
  String get advancedSearchGame => 'Jogo';

  @override
  String get advancedSearchRole => 'Função';

  @override
  String get advancedSearchRanking => 'Classificação';

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
  String get profilePageLabel => 'Perfil';

  @override
  String get profileFollowButtonLabel => 'Seguir';

  @override
  String get profileUnfollowButtonLabel => 'Deixar de seguir';

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
  String get memberSinceLabel => 'Membro desde';

  @override
  String get tournamentWinsLabel => 'Vitórias em Torneios';

  @override
  String get socialMediaLabel => 'Redes Sociais';

  @override
  String get achievementsAwardsLabel => 'Conquistas e Prêmios';

  @override
  String get postsLabel => 'Publicações';

  @override
  String get profileTeamsLabel => 'Equipes';

  @override
  String get messagesPageLabel => 'Mensagens';

  @override
  String get commentsModalLabel => 'Comentários';

  @override
  String get notificationsPageLabel => 'Notificações';

  @override
  String notificationPostLiked(String name) {
    return '<b>$name</b> curtiu sua publicação.';
  }

  @override
  String notificationNewFollower(String name) {
    return '<b>$name</b> começou a te seguir.';
  }

  @override
  String notificationPostCommented(String name) {
    return '<b>$name</b> comentou na sua publicação.';
  }

  @override
  String notificationPostShared(String name) {
    return '<b>$name</b> compartilhou sua publicação.';
  }

  @override
  String notificationInviteToTeam(String name, String team) {
    return '<b>$name</b> convidou você para fazer parte de sua equipe <b>$team</b>.';
  }

  @override
  String notificationApplicationAccepted(String role, String team) {
    return '<b>$team</b> aceitou sua inscrição para a posição de $role em Overwatch. Você agora é membro da equipe profissional.';
  }

  @override
  String get errorTitle => 'Erro';

  @override
  String get errorMessage => 'Ocorreu um erro. Por favor, tente novamente.';

  @override
  String get okButton => 'OK';

  @override
  String get editProfileButtonLabel => 'Editar perfil';

  @override
  String get userNotFound => 'Usuário não encontrado';

  @override
  String get teamNotFound => 'Equipe não encontrada';

  @override
  String get tryAgain => 'Tentar novamente';

  @override
  String get teamIdRequired => 'ID da equipe é obrigatório';

  @override
  String get prizesContent => 'Conteúdo de prêmios vai aqui';

  @override
  String get teamMembersTitle => 'Membros da Equipe';

  @override
  String get teamTournamentsTitle => 'Torneios da Equipe';

  @override
  String get teamWinsTitle => 'Vitórias da Equipe';

  @override
  String get teamTournamentsList => 'Lista de torneios participados';

  @override
  String get teamWinsHistory => 'Histórico de vitórias';

  @override
  String get verifyImageTitle => 'Ver imagem';

  @override
  String get changeProfileImageTitle => 'Alterar imagem do perfil';

  @override
  String get deletePost => 'Excluir post';

  @override
  String searchTeamSnackbar(String name) {
    return 'Equipe: $name';
  }

  @override
  String get noPostsYet => 'Ainda não há posts';

  @override
  String get followToSeePosts => 'Siga uma equipe ou jogador para ver seus posts.';

  @override
  String get searchUsersTeams => 'Pesquisar usuários ou equipes';

  @override
  String get playersSection => 'Jogadores';

  @override
  String get teamsSection => 'Equipes';

  @override
  String get verifiedStatus => 'Verificado';

  @override
  String get pendingStatus => 'Pendente';

  @override
  String get membersLabel => 'Membros';

  @override
  String get gamesLabel => 'Jogos';

  @override
  String get searchPlayersHint => 'Pesquisar jogadores...';

  @override
  String get searchTeamsHint => 'Pesquisar equipes...';

  @override
  String get teamSizeFilter => 'Tamanho da Equipe';

  @override
  String get verifiedTeamsOnly => 'Apenas equipes verificadas';

  @override
  String playersSearchResult(String filters) {
    return 'Pesquisa de jogadores com filtros: $filters';
  }

  @override
  String teamsSearchResult(String filters) {
    return 'Pesquisa de equipes com filtros: $filters';
  }

  @override
  String get viewMembersButtonLabel => 'Ver membros';

  @override
  String get contactButtonLabel => 'Contatar';

  @override
  String get statisticsLabel => 'Estatísticas';

  @override
  String get tournamentsPlayedLabel => 'Torneios jogados';

  @override
  String get winsLabel => 'Vitórias';

  @override
  String get photoGalleryOption => 'Galeria de fotos';

  @override
  String get cameraOption => 'Câmera';

  @override
  String get unauthorizedError => 'Não autorizado';

  @override
  String get unexpectedError => 'Ocorreu um erro inesperado. Por favor, tente novamente.';

  @override
  String get acceptButton => 'Aceitar';

  @override
  String get incorrectCredentials => 'O e-mail ou senha está incorreto';

  @override
  String get photoVideoButton => 'Foto / Vídeo';

  @override
  String get writeMessageHint => 'Escrever mensagem...';

  @override
  String get tournamentTitleColumn => 'Título';

  @override
  String get officialColumn => 'Oficial';

  @override
  String get gameColumn => 'Jogo';

  @override
  String get registeredPlayersColumn => 'Jogadores inscritos';

  @override
  String get settingsLabel => 'Configurações';

  @override
  String get darkmodeLabel => 'Modo escuro';

  @override
  String get languageLabel => 'Idioma';

  @override
  String get commentsLabel => 'comentários';

  @override
  String get imageNotSupported => 'Este tipo de imagem não é suportado';

  @override
  String get pickImageError => 'Erro ao selecionar imagem';

  @override
  String get noImageSelected => 'Você ainda não selecionou uma imagem.';

  @override
  String get errorLoadingUserProfile => 'Erro ao carregar o perfil do usuário';

  @override
  String get tournamentDetailsTitle => 'Detalhes do Torneio';

  @override
  String get tournamentParticipantsLabel => 'Participantes';

  @override
  String get tournamentGameInfoLabel => 'Informações do Jogo';

  @override
  String get tournamentGameTypeLabel => 'Tipo de Jogo';

  @override
  String get tournamentOfficialLabel => 'Torneio Oficial';

  @override
  String get tournamentCommunityLabel => 'Torneio da Comunidade';

  @override
  String get tournamentOfficialDescription => 'Organizado por desenvolvedores oficiais ou patrocinadores';

  @override
  String get tournamentCommunityDescription => 'Organizado pela comunidade';

  @override
  String get tournamentParticipantsListLabel => 'A lista de participantes registrados será exibida aqui';

  @override
  String get tournamentNoParticipantsLabel => 'Ainda não há participantes. Seja o primeiro a se juntar!';

  @override
  String get tournamentRegistrationSuccess => 'Registrado com sucesso no torneio!';

  @override
  String get tournamentAlreadyRegisteredLabel => 'Já Registrado';

  @override
  String get tournamentRegisterButtonLabel => 'Registrar no Torneio';

  @override
  String get tournamentAdditionalInfoLabel => 'Informações Adicionais';

  @override
  String get tournamentStartDateLabel => 'Data de Início';

  @override
  String get tournamentStartDatePlaceholder => 'A ser anunciado';

  @override
  String get tournamentLocationLabel => 'Localização';

  @override
  String get tournamentLocationPlaceholder => 'Online';

  @override
  String get tournamentPrizePoolLabel => 'Prêmio do Torneio';

  @override
  String get tournamentPrizePoolPlaceholder => 'A ser anunciado';

  @override
  String get tournamentFormTitle => 'Título do Torneio';

  @override
  String get tournamentFormTitleHint => 'Ex: Copa de Verão 2024';

  @override
  String get tournamentFormDescription => 'Descrição';

  @override
  String get tournamentFormDescriptionHint => 'Descreva seu torneio...';

  @override
  String get tournamentFormGame => 'Jogo';

  @override
  String get tournamentFormGameHint => 'Selecione um jogo';

  @override
  String get tournamentFormType => 'Formato do Torneio';

  @override
  String get tournamentFormDates => 'Datas do Torneio';

  @override
  String get tournamentFormStartDate => 'Data de Início';

  @override
  String get tournamentFormEndDate => 'Data de Fim';

  @override
  String get tournamentFormSelectDate => 'Selecionar data';

  @override
  String get tournamentFormRegistrationDeadline => 'Prazo de Inscrição';

  @override
  String get tournamentFormConfiguration => 'Configuração';

  @override
  String get tournamentFormOfficial => 'Torneio Oficial';

  @override
  String get tournamentFormOfficialSubtitle => 'Marcar como torneio oficial da plataforma';

  @override
  String get tournamentFormPrivate => 'Torneio Privado';

  @override
  String get tournamentFormPrivateSubtitle => 'Apenas visível para participantes convidados';

  @override
  String get tournamentFormMaxParticipants => 'Máx. Participantes';

  @override
  String get tournamentFormPrizePool => 'Prêmio Total (\$)';

  @override
  String get tournamentFormCreateButton => 'Criar Torneio';

  @override
  String get tournamentFormUpdateButton => 'Atualizar Torneio';

  @override
  String get tournamentFormCancelButton => 'Cancelar';

  @override
  String get tournamentFormDeleteButton => 'Excluir';

  @override
  String get tournamentFormDeleteTitle => 'Excluir Torneio';

  @override
  String get tournamentFormDeleteMessage => 'Tem certeza de que deseja excluir este torneio? Esta ação não pode ser desfeita.';

  @override
  String get tournamentFormDeleteConfirm => 'Excluir';

  @override
  String get tournamentFormDeleteCancel => 'Cancelar';

  @override
  String get tournamentFormSuccessCreate => 'Torneio criado com sucesso';

  @override
  String get tournamentFormSuccessUpdate => 'Torneio atualizado com sucesso';

  @override
  String get tournamentFormSuccessDelete => 'Torneio excluído com sucesso';

  @override
  String get tournamentFormErrorCreate => 'Erro ao criar torneio';

  @override
  String get tournamentFormErrorUpdate => 'Erro ao atualizar torneio';

  @override
  String get tournamentFormErrorDelete => 'Erro ao excluir torneio';

  @override
  String get tournamentFormValidationTitleRequired => 'O título é obrigatório';

  @override
  String get tournamentFormValidationTitleMinLength => 'O título deve ter pelo menos 3 caracteres';

  @override
  String get tournamentFormValidationDescriptionRequired => 'A descrição é obrigatória';

  @override
  String get tournamentFormValidationDescriptionMinLength => 'A descrição deve ter pelo menos 10 caracteres';

  @override
  String get tournamentFormValidationGameRequired => 'Você deve selecionar um jogo';

  @override
  String get tournamentFormValidationStartDateRequired => 'Você deve selecionar uma data de início';

  @override
  String get tournamentFormValidationEndDateRequired => 'Você deve selecionar uma data de fim';

  @override
  String get tournamentFormValidationDateOrder => 'A data de início deve ser anterior à data de fim';

  @override
  String get tournamentFormValidationDatePast => 'A data de início não pode estar no passado';

  @override
  String get tournamentFormTypeSingleElimination => 'Eliminação Simples';

  @override
  String get tournamentFormTypeDoubleElimination => 'Eliminação Dupla';

  @override
  String get tournamentFormTypeRoundRobin => 'Todos contra Todos';

  @override
  String get tournamentFormTypeSwissSystem => 'Sistema Suíço';

  @override
  String get tournamentFormDeadline1Day => '1 dia antes';

  @override
  String get tournamentFormDeadline3Days => '3 dias antes';

  @override
  String get tournamentFormDeadline1Week => '1 semana antes';

  @override
  String get tournamentFormDeadline2Weeks => '2 semanas antes';

  @override
  String get tournamentFormSelectGame => 'Selecione um jogo';

  @override
  String get tournamentFormViewDetails => 'Ver Detalhes';

  @override
  String get tournamentFormPlayers => 'Jogadores';

  @override
  String get tournamentFormEdit => 'Editar';

  @override
  String get tournamentFormDelete => 'Excluir';

  @override
  String tournamentFormTournamentDeleted(String title) {
    return 'Torneio \"$title\" excluído';
  }

  @override
  String get tournamentFormLoadingTournaments => 'Carregando torneios...';

  @override
  String get tournamentFormNoTournamentsAvailable => 'Nenhum torneio disponível';

  @override
  String get tournamentFormCheckBackLater => 'Volte mais tarde para novos torneios';

  @override
  String get tournamentFormPleaseFixErrors => 'Por favor, corrija os erros no formulário';

  @override
  String get validationRequired => 'Este campo é obrigatório';

  @override
  String get validationFirstNameMin => 'O nome deve ter pelo menos 2 caracteres';

  @override
  String get validationFirstNameMax => 'O nome deve ter no máximo 50 caracteres';

  @override
  String get validationLastNameMin => 'O sobrenome deve ter pelo menos 2 caracteres';

  @override
  String get validationLastNameMax => 'O sobrenome deve ter no máximo 50 caracteres';

  @override
  String get validationInvalidEmail => 'Por favor insira um endereço de e-mail válido';

  @override
  String get validationUsernameMin => 'O nome de usuário deve ter pelo menos 3 caracteres';

  @override
  String get validationUsernameMax => 'O nome de usuário deve ter no máximo 20 caracteres';

  @override
  String get validationUsernameInvalid => 'O nome de usuário pode conter apenas letras, números, sublinhados e pontos';

  @override
  String get validationPasswordMinLength => 'A senha deve ter pelo menos 8 caracteres';

  @override
  String get validationPasswordHasUpperCase => 'A senha deve conter pelo menos uma letra maiúscula';

  @override
  String get validationPasswordHasLowerCase => 'A senha deve conter pelo menos uma letra minúscula';

  @override
  String get validationPasswordHasNumber => 'A senha deve conter pelo menos um número';

  @override
  String get validationPasswordHasSpecialChar => 'A senha deve conter pelo menos um caractere especial';

  @override
  String get validationPasswordsDontMatch => 'As senhas não coincidem';

  @override
  String get passwordRequirementsTitle => 'Requisitos de Senha';

  @override
  String get registerFirstNameHint => 'Nome';

  @override
  String get registerLastNameHint => 'Sobrenome';

  @override
  String get registerUsernameHint => 'Nome de usuário';

  @override
  String get registerEmailHint => 'E-mail';

  @override
  String get registerPasswordHint => 'Senha';

  @override
  String get registerConfirmPasswordHint => 'Repetir senha';

  @override
  String get registerButton => 'Registrar';

  @override
  String get registerAlreadyHaveAccount => 'Já tem uma conta? Faça login';

  @override
  String get registerErrorCreatingAccount => 'Erro ao criar conta';
}
