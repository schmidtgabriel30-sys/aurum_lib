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
  static const String menuAccount = 'Minha conta';
  static const String menuSignOut = 'Sair';
  static const String menuSignIn = 'Entrar';
  static const String back = 'Voltar à página anterior';
  static const String backHome = 'Voltar ao início';
  static const String or = 'Ou';

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

  // Campos
  static const String fieldName = 'Nome completo';
  static const String fieldEmail = 'E-mail';
  static const String fieldPassword = 'Senha';
  static const String fieldPasswordConfirmation = 'Confirmar senha';
  static const String fieldPhone = 'Celular com DDD';
  static const String fieldVehicle = 'Veículo';
  static const String fieldDate = 'Dia de preferência';
  static const String fieldPeriod = 'Período';
  static const String fieldNotes = 'Observações (opcional)';
  static const String requiredMark = ' *';

  static const String hintName = 'Como podemos chamar você?';
  static const String hintEmail = 'seuemail@exemplo.com';
  static const String hintPassword = '••••••••';
  static const String hintNewPassword = 'Mínimo de 8 caracteres';
  static const String hintRepeatPassword = 'Repita a senha';
  static const String hintPhone = '(00) 00000-0000';
  static const String hintVehicle = 'Marca, modelo e ano';
  static const String hintDate = 'dd/mm/aaaa';
  static const String hintPeriod = 'Selecione';
  static const String hintNotes = 'Quer nos contar algo sobre o carro?';

  // Conta
  static const String accountTitle = 'Minha Conta';
  static const String accountSubtitle = 'Você está conectado(a)';
  static const String accountSignOut = 'Sair da conta';

  // Agendamentos — listagem
  static const String appointmentsTitle = 'Meus agendamentos';
  static const String appointmentsNew = 'Novo';
  static const String appointmentsEmpty =
      'Você ainda não tem agendamentos.\nToque em "Novo" para solicitar uma revisão.';

  // Agendamentos — formulário
  static const String appointmentNewTitle = 'Novo agendamento';
  static const String appointmentEditTitle = 'Editar agendamento';
  static const String appointmentFormIntro =
      'Solicite sua revisão preventiva. Nossa equipe entrará em contato para confirmar os detalhes.';
  static const String appointmentSave = 'Solicitar agendamento';
  static const String appointmentUpdate = 'Salvar alterações';
  static const String appointmentSaving = 'Salvando...';
  static const String appointmentConsent =
      'Autorizo o contato da Aurum Automotive para dar continuidade a esta solicitação.';
  static const String appointmentDisclaimer =
      'O envio é uma solicitação, não uma reserva. O dia e o horário dependem da confirmação da equipe.';
  static const String requiredFields = '* Campos obrigatórios';
  static const String appointmentCreated =
      'Solicitação enviada! Entraremos em contato.';
  static const String appointmentUpdated = 'Agendamento atualizado.';

  // Agendamentos — detalhes
  static const String appointmentDetailsTitle = 'Detalhes do agendamento';
  static const String appointmentEdit = 'Editar';
  static const String appointmentDelete = 'Excluir';
  static const String appointmentDeleted = 'Agendamento excluído.';
  static const String deleteDialogTitle = 'Excluir agendamento?';
  static const String deleteDialogMessage =
      'Esta ação não pode ser desfeita. O agendamento será removido do sistema.';
  static const String cancel = 'Cancelar';
  static const String noNotes = 'Sem observações';
  static const String retry = 'Tentar novamente';

  // Pacote
  static const String packageName = 'Revisão preventiva completa';
  static const String packagePrice =
      r'R$ 249,90 à vista ou em até 3x sem juros';

  // Validações
  static const String validationRequired = 'é obrigatório.';
  static const String validationEmail = 'Informe um e-mail válido.';
  static const String validationPasswordMin = 'A senha precisa ter ao menos';
  static const String validationPasswordChars = 'caracteres.';
  static const String validationPasswordMatch = 'As senhas não conferem.';
  static const String validationPhone = 'Informe um celular válido com DDD.';
  static const String validationName = 'Informe nome e sobrenome.';
  static const String validationConsent =
      'É preciso autorizar o contato para continuar.';
  static const String validationPastDate = 'Escolha uma data a partir de hoje.';

  // Erros
  static const String errorGeneric =
      'Algo deu errado. Tente novamente em instantes.';
  static const String errorNoConnection = 'Sem conexão com o servidor.';
  static const String errorUnauthorized =
      'Sua sessão expirou. Entre novamente.';
  static const String errorInvalidCredentials = 'E-mail ou senha inválidos.';
  static const String errorNotFound = 'Registro não encontrado.';
  static const String errorUnexpectedResponse =
      'Resposta inesperada do servidor.';
}
