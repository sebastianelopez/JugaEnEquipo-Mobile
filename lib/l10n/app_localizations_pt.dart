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
  String get loginForgotPassword => 'Esqueceu sua senha?';

  @override
  String get forgotPasswordTitle => 'Recuperar senha';

  @override
  String get forgotPasswordSubtitle => 'Digite seu e-mail e enviaremos um link para redefinir sua senha';

  @override
  String get forgotPasswordEmailHint => 'E-mail';

  @override
  String get forgotPasswordButton => 'Enviar link de recuperação';

  @override
  String get forgotPasswordSuccess => 'Um e-mail foi enviado com instruções para redefinir sua senha';

  @override
  String get forgotPasswordError => 'Erro ao enviar e-mail. Verifique se o e-mail está correto.';

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
  String notificationTournamentRequestReceived(String name) {
    return '<b>$name</b> enviou uma solicitação de inscrição no torneio.';
  }

  @override
  String notificationUserMentioned(String name) {
    return '<b>$name</b> mencionou você em uma publicação.';
  }

  @override
  String notificationTeamRequestReceived(String name) {
    return '<b>$name</b> enviou uma solicitação para entrar na equipe.';
  }

  @override
  String notificationTeamRequestAccepted(String name) {
    return '<b>$name</b> aceitou sua solicitação para entrar na equipe.';
  }

  @override
  String notificationTournamentRequestAccepted(String name) {
    return '<b>$name</b> aceitou sua solicitação de inscrição no torneio.';
  }

  @override
  String notificationPostModerated(String name) {
    return 'Sua publicação foi moderada e não foi publicada devido a conteúdo inadequado. Por favor, revise nossas políticas de comunidade.';
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
  String get tournamentRegisteredTeamsLabel => 'Equipes registrados';

  @override
  String get tournamentNoParticipantsLabel => 'Ainda não há participantes. Seja o primeiro a se juntar!';

  @override
  String get tournamentRegistrationSuccess => 'Registrado com sucesso no torneio!';

  @override
  String get tournamentAlreadyRegisteredLabel => 'Já Registrado';

  @override
  String get tournamentRegisterButtonLabel => 'Registrar no Torneio';

  @override
  String get tournamentStartDatePassed => 'O torneio já começou, você não pode se inscrever';

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

  @override
  String get editTeam => 'Editar Equipe';

  @override
  String get manageGames => 'Gerenciar Jogos';

  @override
  String get teamRequests => 'Solicitações da Equipe';

  @override
  String get requests => 'Solicitações';

  @override
  String get deleteTeam => 'Excluir Equipe';

  @override
  String get leaveTeam => 'Deixar Equipe';

  @override
  String get requestAccess => 'Solicitar Acesso';

  @override
  String get removeMember => 'Remover Membro';

  @override
  String get acceptRequest => 'Aceitar Solicitação';

  @override
  String get declineRequest => 'Recusar Solicitação';

  @override
  String get teamUpdatedSuccessfully => 'Equipe atualizada com sucesso';

  @override
  String get errorUpdatingTeam => 'Erro ao atualizar a equipe';

  @override
  String get teamDeletedSuccessfully => 'Equipe excluída com sucesso';

  @override
  String get errorDeletingTeam => 'Erro ao excluir a equipe';

  @override
  String get leftTeamSuccessfully => 'Você deixou a equipe com sucesso';

  @override
  String get errorLeavingTeam => 'Erro ao deixar a equipe';

  @override
  String get accessRequestSent => 'Solicitação de acesso enviada';

  @override
  String get errorSendingRequest => 'Erro ao enviar a solicitação';

  @override
  String get requestAccepted => 'Solicitação aceita';

  @override
  String get errorAcceptingRequest => 'Erro ao aceitar a solicitação';

  @override
  String get requestDeclined => 'Solicitação recusada';

  @override
  String get errorDecliningRequest => 'Erro ao recusar a solicitação';

  @override
  String get memberRemovedFromTeam => 'Membro removido da equipe';

  @override
  String get errorRemovingMember => 'Erro ao remover o membro';

  @override
  String get gameAdded => 'Jogo adicionado';

  @override
  String get errorAddingGame => 'Erro ao adicionar o jogo';

  @override
  String get gameRemoved => 'Jogo removido';

  @override
  String get errorRemovingGame => 'Erro ao remover o jogo';

  @override
  String get noPendingRequests => 'Não há solicitações pendentes';

  @override
  String get areYouSureDeleteTeam => 'Tem certeza de que deseja excluir esta equipe? Esta ação não pode ser desfeita.';

  @override
  String get areYouSureLeaveTeam => 'Tem certeza de que deseja deixar esta equipe?';

  @override
  String areYouSureRemoveMember(String name) {
    return 'Tem certeza de que deseja remover $name da equipe?';
  }

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Salvar';

  @override
  String get remove => 'Remover';

  @override
  String get delete => 'Excluir';

  @override
  String get leave => 'Deixar';

  @override
  String get teamName => 'Nome da Equipe';

  @override
  String get description => 'Descrição';

  @override
  String get waitingForApproval => 'Aguardando Aprovação';

  @override
  String get editProfile => 'Editar Perfil';

  @override
  String get profileImage => 'Imagem de Perfil';

  @override
  String get backgroundImage => 'Imagem de Fundo';

  @override
  String get changeProfileImage => 'Toque para alterar a imagem de perfil';

  @override
  String get changeBackgroundImage => 'Alterar Imagem de Fundo';

  @override
  String get dangerZone => 'Zona de Perigo';

  @override
  String get deleteTeamConfirmation => 'Tem certeza de que deseja excluir esta equipe? Esta ação não pode ser desfeita.';

  @override
  String get resetPasswordTitle => 'Redefinir Senha';

  @override
  String get resetPasswordSubtitle => 'Digite sua nova senha abaixo';

  @override
  String get resetPasswordSuccess => 'Senha redefinida com sucesso! Agora você pode fazer login com sua nova senha.';

  @override
  String get resetPasswordGoToLogin => 'Ir para Login';

  @override
  String get resetPasswordButton => 'Redefinir Senha';

  @override
  String get resetPasswordInvalidToken => 'O token é inválido ou expirou';

  @override
  String get resetPasswordError => 'Erro ao redefinir a senha. Por favor, tente novamente.';

  @override
  String get tournamentStatusFinished => 'Finalizado';

  @override
  String get tournamentStatusOngoing => 'Em andamento';

  @override
  String get tournamentStatusUpcoming => 'Próximo';

  @override
  String get tournamentStatusLabel => 'Status do Torneio';

  @override
  String get tournamentResponsible => 'Responsável do Torneio';

  @override
  String get tournamentStartDate => 'Início';

  @override
  String get tournamentEndDate => 'Fim';

  @override
  String get tournamentPrize => 'Prêmio';

  @override
  String get tournamentUserNotAvailable => 'Usuário não disponível';

  @override
  String get tournamentYouAreCreator => 'Você é o criador';

  @override
  String tournamentYouAreRole(String role) {
    return 'Você é $role';
  }

  @override
  String get loading => 'Carregando...';

  @override
  String get tournamentPendingRequests => 'Solicitações Pendentes';

  @override
  String get tournamentNoPendingRequests => 'Não há solicitações pendentes';

  @override
  String get tournamentRequestCountSingular => '1 solicitação';

  @override
  String tournamentRequestCountPlural(num count) {
    return '$count solicitações';
  }

  @override
  String get tournamentRequestRequested => 'Solicitado';

  @override
  String get tournamentAcceptRequest => 'Aceitar';

  @override
  String get tournamentDeclineRequest => 'Recusar';

  @override
  String get tournamentAcceptRequestTitle => 'Aceitar Solicitação';

  @override
  String tournamentAcceptRequestMessage(String teamName) {
    return 'Tem certeza de que deseja aceitar a solicitação de $teamName?';
  }

  @override
  String get tournamentDeclineRequestTitle => 'Recusar Solicitação';

  @override
  String tournamentDeclineRequestMessage(String teamName) {
    return 'Tem certeza de que deseja recusar a solicitação de $teamName?';
  }

  @override
  String get tournamentRequestAccepted => 'Solicitação aceita com sucesso';

  @override
  String get tournamentRequestDeclined => 'Solicitação recusada com sucesso';

  @override
  String get tournamentErrorAcceptingRequest => 'Erro ao aceitar solicitação';

  @override
  String get tournamentErrorDecliningRequest => 'Erro ao recusar solicitação';

  @override
  String get tournamentTabInfo => 'Informação';

  @override
  String get tournamentTabRequests => 'Solicitações';

  @override
  String get optional => 'Opcional';

  @override
  String get tournamentFormImage => 'Imagem do Torneio';

  @override
  String get tournamentFormSelectImage => 'Selecionar Imagem';

  @override
  String get tournamentFormRegion => 'Região';

  @override
  String get tournamentFormRegionHint => 'LATAM';

  @override
  String get tournamentFormSearchResponsible => 'Buscar Responsável';

  @override
  String get tournamentFormSearchResponsibleTitle => 'Buscar Usuário Responsável';

  @override
  String get tournamentFormSelectMaxTeams => 'Selecione o máximo de equipes';

  @override
  String get tournamentFormMinRank => 'Rank Mínimo';

  @override
  String get tournamentFormMaxRank => 'Rank Máximo';

  @override
  String get tournamentFormRules => 'Regras do Torneio';

  @override
  String get tournamentFormRulesList => 'Lista';

  @override
  String get tournamentFormRulesNumberedList => 'Lista numerada';

  @override
  String get tournamentFormRulesBold => 'Negrito';

  @override
  String get tournamentFormRulesItalic => 'Itálico';

  @override
  String get tournamentFormRulesTitle => 'Título';

  @override
  String get tournamentFormRulesHint => 'Escreva as regras do torneio...\n\nExemplo:\n# Regras Gerais\n- Respeitar os outros\n- Pontualidade\n\n# Regras de Jogo\n1. Primeira regra\n2. Segunda regra';

  @override
  String get tournamentFormRulesHelp => 'Use os botões para adicionar formatação. O texto será exibido como markdown.';

  @override
  String get username => 'Nome de usuário';

  @override
  String get tournamentFormSearchUsernameHint => 'Buscar por nome de usuário...';

  @override
  String get tournamentFormNoUsersFound => 'Nenhum usuário encontrado';

  @override
  String get tournamentFormSearchMinChars => 'Digite pelo menos 3 caracteres para buscar';

  @override
  String get profileTabPosts => 'Posts';

  @override
  String get profileTabInfo => 'Informação';

  @override
  String get tournamentFormMaxTeams => 'Máximo de Equipes';

  @override
  String get retryButton => 'Tentar novamente';

  @override
  String get noConversations => 'Não há conversas';

  @override
  String get errorLoadingConversations => 'Erro ao carregar conversas';

  @override
  String get chatLabel => 'Chat';

  @override
  String get onlineLabel => 'Online';

  @override
  String get editProfileTitle => 'Editar Perfil';

  @override
  String errorLoadingSocialNetworks(String error) {
    return 'Erro ao carregar redes sociais: $error';
  }

  @override
  String errorPickingImage(String error) {
    return 'Erro ao selecionar imagem: $error';
  }

  @override
  String get backgroundImageUpdatedSuccessfully => 'Imagem de fundo atualizada com sucesso';

  @override
  String get failedToUpdateBackgroundImage => 'Erro ao atualizar a imagem de fundo';

  @override
  String get descriptionUpdatedSuccessfully => 'Descrição atualizada com sucesso';

  @override
  String get failedToUpdateDescription => 'Erro ao atualizar a descrição';

  @override
  String addSocialNetwork(String networkName) {
    return 'Adicionar $networkName';
  }

  @override
  String get usernameLabel => 'Nome de usuário';

  @override
  String enterSocialNetworkUsername(String networkName) {
    return 'Digite seu nome de usuário do $networkName';
  }

  @override
  String get addButton => 'Adicionar';

  @override
  String socialNetworkAddedSuccessfully(String networkName) {
    return '$networkName adicionado com sucesso';
  }

  @override
  String failedToAddSocialNetwork(String networkName) {
    return 'Erro ao adicionar $networkName';
  }

  @override
  String get removeNetwork => 'Remover Rede';

  @override
  String areYouSureRemoveNetwork(String networkName) {
    return 'Tem certeza de que deseja remover $networkName?';
  }

  @override
  String socialNetworkRemoved(String networkName) {
    return '$networkName removido';
  }

  @override
  String get backgroundImageLabel => 'Imagem de Fundo';

  @override
  String get descriptionLabel => 'Descrição';

  @override
  String get tellUsAboutYourself => 'Conte-nos sobre você...';

  @override
  String get saveDescription => 'Salvar Descrição';

  @override
  String get socialNetworksLabel => 'Redes Sociais';

  @override
  String get yourNetworks => 'Suas Redes:';

  @override
  String get addNetwork => 'Adicionar Rede:';

  @override
  String get mustBeInTeamToRegister => 'Você deve estar em uma equipe para se registrar';

  @override
  String get noTeamsInTournament => 'Você não tem equipes neste torneio';

  @override
  String get leaveTournament => 'Abandonar Torneio';

  @override
  String get leaveTournamentConfirmation => 'Tem certeza de que deseja abandonar este torneio?';

  @override
  String get selectTeam => 'Selecione a Equipe';

  @override
  String get changePasswordTitle => 'Alterar Senha';

  @override
  String get currentPassword => 'Senha Atual';

  @override
  String get newPassword => 'Nova Senha';

  @override
  String get confirmNewPassword => 'Confirmar Nova Senha';

  @override
  String get passwordsDoNotMatch => 'As novas senhas não coincidem';

  @override
  String get passwordChangedSuccessfully => 'Senha alterada com sucesso';

  @override
  String get failedToChangePassword => 'Erro ao alterar a senha. Por favor, verifique sua senha antiga.';

  @override
  String get pleaseEnterCurrentPassword => 'Por favor, digite sua senha atual';

  @override
  String get pleaseEnterNewPassword => 'Por favor, digite uma nova senha';

  @override
  String get passwordMinLength => 'A senha deve ter pelo menos 6 caracteres';

  @override
  String get pleaseConfirmNewPassword => 'Por favor, confirme sua nova senha';

  @override
  String get passwordsDoNotMatchValidation => 'As senhas não coincidem';

  @override
  String get deleteAccount => 'Excluir Conta';

  @override
  String get deleteAccountConfirmation => 'Tem certeza de que deseja excluir sua conta? Esta ação não pode ser desfeita.';

  @override
  String get accountDeletedSuccessfully => 'Conta excluída com sucesso';

  @override
  String get failedToDeleteAccount => 'Erro ao excluir a conta';

  @override
  String get deletePlayerProfile => 'Excluir Perfil de Jogador';

  @override
  String deletePlayerProfileConfirmation(String gameName) {
    return 'Tem certeza de que deseja excluir seu perfil de $gameName?';
  }

  @override
  String get playerProfileDeletedSuccessfully => 'Perfil de jogador excluído com sucesso';

  @override
  String get errorDeletingPlayerProfile => 'Erro ao excluir o perfil de jogador';

  @override
  String get pleaseSelectGame => 'Por favor, selecione um jogo';

  @override
  String get playerProfileAddedSuccessfully => 'Perfil de jogador adicionado com sucesso';

  @override
  String get playerProfileUpdatedSuccessfully => 'Perfil de jogador atualizado com sucesso';

  @override
  String get errorSavingPlayerProfile => 'Erro ao salvar o perfil de jogador';

  @override
  String get steamId => 'Steam ID';

  @override
  String get riotUsername => 'Nome de Usuário (RIOT)';

  @override
  String get riotTag => 'Tag (RIOT)';

  @override
  String get riotRegion => 'Região';

  @override
  String get steam => 'Steam';

  @override
  String get riot => 'RIOT';

  @override
  String get selectGame => 'Selecione um jogo';

  @override
  String get leaveTeamConfirmation => 'Tem certeza de que deseja deixar esta equipe?';

  @override
  String get addPlayerProfile => 'Adicionar Perfil de Jogador';

  @override
  String get editPlayerProfile => 'Editar Perfil de Jogador';

  @override
  String get gameLabel => 'Jogo';

  @override
  String get accountType => 'Tipo de Conta';

  @override
  String get viewTeamProfile => 'Ver Perfil da Equipe';

  @override
  String get noGames => 'Sem Jogos';

  @override
  String get yearSingular => 'ano';

  @override
  String get yearPlural => 'anos';

  @override
  String get monthSingular => 'mês';

  @override
  String get monthPlural => 'meses';

  @override
  String get newTeam => 'Novo';

  @override
  String get closeButton => 'Fechar';

  @override
  String get noNotifications => 'Você não tem notificações';

  @override
  String newNotificationFrom(String username) {
    return 'Nova notificação de <b>$username</b>.';
  }

  @override
  String viewProfileLabel(String username) {
    return 'Ver perfil de $username';
  }

  @override
  String get likePostLabel => 'Curtir publicação';

  @override
  String get unlikePostLabel => 'Descurtir publicação';

  @override
  String get addCommentLabel => 'Adicionar comentário';

  @override
  String get sharePostLabel => 'Compartilhar publicação';
}
