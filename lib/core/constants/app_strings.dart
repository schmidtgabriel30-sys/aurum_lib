/// Textos fixos da interface.
///
/// Centralizar as strings aqui evita texto duplicado nas telas e deixa o app
/// pronto para tradução no futuro.
abstract final class AppStrings {
  static const String appName = 'Aurum Automotive';
  static const String logoFallback = 'AURUM';

  // Navegação / menu
  static const String menuSchedule = 'Agendar';
  static const String menuAppointments = 'Meus agendamentos';
  static const String menuVehicles = 'Meus veículos';
  static const String menuAccount = 'Minha conta';
  static const String menuSignOut = 'Sair';
  static const String menuSignIn = 'Entrar';
  static const String back = 'Voltar à página anterior';
  static const String backHome = 'Voltar ao início';
  static const String or = 'Ou';
  static const String cancel = 'Cancelar';
  static const String retry = 'Tentar novamente';
  static const String requiredMark = ' *';
  static const String requiredFields = '* Campos obrigatórios';
  static const String saving = 'Salvando...';
  static const String saveChanges = 'Salvar alterações';
  static const String delete = 'Excluir';

  // Login
  static const String signInTitle = 'Entrar';
  static const String signInSubtitle = 'Acesse sua conta para continuar';
  static const String signInButton = 'Entrar';
  static const String signInLoading = 'Entrando...';
  static const String forgotPassword = 'Esqueceu sua senha?';
  static const String goToSignUp = 'Não tem conta? Criar conta';

  // Cadastro
  static const String signUpTitle = 'Criar conta';
  static const String signUpSubtitle = 'Cadastre-se para agendar sua revisão';
  static const String signUpButton = 'Criar conta';
  static const String signUpLoading = 'Criando conta...';
  static const String goToSignIn = 'Já tem conta? Entrar';

  // Campos de conta
  static const String fieldName = 'Nome completo';
  static const String fieldEmail = 'E-mail';
  static const String fieldPassword = 'Senha';
  static const String fieldPasswordConfirmation = 'Confirmar senha';
  static const String hintName = 'Como podemos chamar você?';
  static const String hintEmail = 'seuemail@exemplo.com';
  static const String hintPassword = '••••••••';
  static const String hintNewPassword = 'Mínimo de 8 caracteres';
  static const String hintRepeatPassword = 'Repita a senha';

  // Conta
  static const String accountTitle = 'Minha Conta';
  static const String accountSubtitle = 'Você está conectado(a)';
  static const String accountSignOut = 'Sair da conta';

  // Veículos
  static const String vehiclesTitle = 'Meus veículos';
  static const String vehiclesEmpty =
      'Nenhum veículo cadastrado.\nCadastre seu carro para poder agendar.';
  static const String vehicleNewTitle = 'Cadastrar veículo';
  static const String vehicleEditTitle = 'Editar veículo';
  static const String vehicleSave = 'Cadastrar veículo';
  static const String vehicleCreated = 'Veículo cadastrado.';
  static const String vehicleUpdated = 'Veículo atualizado.';
  static const String vehicleDeleted = 'Veículo excluído.';
  static const String vehicleDelete = 'Excluir veículo';
  static const String vehicleDeleteTitle = 'Excluir veículo?';
  static const String vehicleDeleteMessage =
      'O veículo será removido. Não é possível excluir um veículo com agendamento em aberto.';
  static const String fieldBrand = 'Marca';
  static const String fieldModel = 'Modelo';
  static const String fieldPlate = 'Placa';
  static const String fieldYear = 'Ano';
  static const String hintBrand = 'Ex.: Volkswagen';
  static const String hintModel = 'Ex.: Gol 1.6';
  static const String hintPlate = 'ABC1D23';
  static const String hintYear = 'Ex.: 2015';

  // Agendamentos — listagem
  static const String appointmentsTitle = 'Meus agendamentos';
  static const String appointmentsNew = 'Novo';
  static const String appointmentsEmpty =
      'Você ainda não tem agendamentos.\nToque em "Novo" para solicitar uma revisão.';

  // Agendamentos — formulário
  static const String appointmentNewTitle = 'Novo agendamento';
  static const String appointmentEditTitle = 'Reagendar';
  static const String appointmentFormIntro =
      'Escolha o veículo, o serviço e sua preferência de dia e período. Nossa equipe confirmará o agendamento.';
  static const String appointmentEditIntro =
      'Você pode alterar a data, o período e as observações enquanto o agendamento estiver pendente.';
  static const String appointmentSave = 'Solicitar agendamento';
  static const String appointmentDisclaimer =
      'O envio é uma solicitação, não uma reserva. O agendamento fica pendente até a confirmação da equipe.';
  static const String appointmentCreated =
      'Solicitação enviada! Entraremos em contato.';
  static const String appointmentUpdated = 'Agendamento atualizado.';
  static const String fieldVehicle = 'Veículo';
  static const String fieldService = 'Serviço';
  static const String fieldDate = 'Data';
  static const String fieldPeriod = 'Período';
  static const String fieldNotes = 'Observações (opcional)';
  static const String fieldMechanic = 'Mecânico';
  static const String fieldPrice = 'Valor';
  static const String hintVehicle = 'Selecione o veículo';
  static const String hintService = 'Selecione o serviço';
  static const String hintDate = 'dd/mm/aaaa';
  static const String hintPeriod = 'Selecione';
  static const String hintNotes = 'Quer nos contar algo sobre o carro?';
  static const String noVehicleYet =
      'Você precisa cadastrar um veículo antes de agendar.';
  static const String goToNewVehicle = 'Cadastrar veículo';
  static const String lockedOnEdit =
      'Veículo e serviço não podem ser alterados depois da solicitação.';

  // Agendamentos — detalhes
  static const String appointmentDetailsTitle = 'Detalhes do agendamento';
  static const String appointmentCancel = 'Cancelar agendamento';
  static const String appointmentCanceled = 'Agendamento cancelado.';
  static const String cancelDialogTitle = 'Cancelar agendamento?';
  static const String cancelDialogMessage =
      'A oficina será avisada e o horário ficará livre. Não é possível desfazer.';
  static const String cancelDialogConfirm = 'Cancelar agendamento';
  static const String keep = 'Manter';
  static const String appointmentDeleted = 'Agendamento excluído.';
  static const String deleteDialogTitle = 'Excluir agendamento?';
  static const String deleteDialogMessage =
      'Esta ação não pode ser desfeita. O agendamento será removido do sistema.';
  static const String noNotes = 'Sem observações';
  static const String noMechanic = 'A definir pela oficina';

  // Pacote em destaque na página inicial
  static const String packageName = 'Revisão preventiva completa';
  static const String packagePrice =
      r'R$ 249,90 à vista ou em até 3x sem juros';

  // Validações
  static const String validationRequired = 'é obrigatório.';
  static const String validationEmail = 'Informe um e-mail válido.';
  static const String validationPasswordMin = 'A senha precisa ter ao menos';
  static const String validationPasswordChars = 'caracteres.';
  static const String validationPasswordMatch = 'As senhas não conferem.';
  static const String validationName = 'Informe nome e sobrenome.';
  static const String validationPastDate = 'Escolha uma data a partir de hoje.';
  static const String validationPlate =
      'Placa inválida. Use o formato ABC1234 ou ABC1D23.';
  static const String validationYear = 'Informe um ano entre';
  static const String validationYearAnd = 'e';

  // Erros
  static const String errorGeneric =
      'Algo deu errado. Tente novamente em instantes.';
  static const String errorNoConnection = 'Sem conexão com o servidor.';
  static const String errorUnauthorized =
      'Sua sessão expirou. Entre novamente.';
  static const String errorForbidden =
      'Você não tem permissão para acessar este registro.';
  static const String errorInvalidCredentials = 'E-mail ou senha inválidos.';
  static const String errorNotFound = 'Registro não encontrado.';
  static const String errorUnexpectedResponse =
      'Resposta inesperada do servidor.';
}
