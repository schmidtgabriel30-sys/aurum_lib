/// Nomes e caminhos das rotas do app.
///
/// Nunca escreva o caminho como texto ao navegar: use
/// `context.goNamed(AppRoutes.appointments)`. Assim, mudar um caminho é uma
/// alteração em um arquivo só.
abstract final class AppRoutes {
  // Página inicial (pública)
  static const String home = 'home';
  static const String homePath = '/';

  // Autenticação
  static const String signIn = 'sign-in';
  static const String signInPath = '/login';

  static const String signUp = 'sign-up';
  static const String signUpPath = '/cadastro';

  // Conta (exige login)
  static const String account = 'account';
  static const String accountPath = '/conta';

  // Agendamentos — CRUD (exige login)
  static const String appointments = 'appointments';
  static const String appointmentsPath = '/agendamentos';

  static const String appointmentNew = 'appointment-new';
  static const String appointmentNewPath = 'novo';

  static const String appointmentDetails = 'appointment-details';
  static const String appointmentDetailsPath = ':id';

  static const String appointmentEdit = 'appointment-edit';
  static const String appointmentEditPath = 'editar';

  /// Nome do parâmetro de caminho usado em detalhes e edição.
  static const String idParam = 'id';
}
