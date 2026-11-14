import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../screens/account/account_screen.dart';
import '../../screens/appointments/appointment_details_screen.dart';
import '../../screens/appointments/appointment_form_screen.dart';
import '../../screens/appointments/appointments_screen.dart';
import '../../screens/auth/sign_in_screen.dart';
import '../../screens/auth/sign_up_screen.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/vehicles/vehicle_form_screen.dart';
import '../../screens/vehicles/vehicles_screen.dart';
import '../constants/app_strings.dart';
import 'app_routes.dart';

/// Configuração de navegação (go_router).
///
/// ```
/// /                              → página inicial (pública)
/// /login                         → entrar
/// /cadastro                      → criar conta
/// /conta                         → minha conta            (login)
/// /agendamentos                  → lista                  (login)
///   ├ /agendamentos/novo         → formulário de criação
///   └ /agendamentos/:id          → detalhes
///       └ /agendamentos/:id/editar → formulário de edição
/// /veiculos                      → lista de veículos      (login)
///   ├ /veiculos/novo             → cadastro
///   └ /veiculos/:id/editar       → edição e exclusão
/// ```
///
/// O `redirect` protege as rotas privadas: quem não está logado é levado ao
/// login. Ele é reavaliado sempre que o estado de login muda, porque o
/// router escuta a sessão através de `refreshListenable`.
///
/// O router recebe a sessão por parâmetro (`isSignedIn` e `authChanges`)
/// em vez de importar o service, porque `core/` não depende de `services/`.
abstract final class AppRouter {
  static GoRouter create({
    required bool Function() isSignedIn,
    required Listenable authChanges,
  }) {
    return GoRouter(
      initialLocation: AppRoutes.homePath,
      refreshListenable: authChanges,
      redirect: (context, state) {
        final String location = state.matchedLocation;
        final bool isPrivate = AppRoutes.privatePaths.any(location.startsWith);
        final bool isAuthPage =
            location == AppRoutes.signInPath ||
            location == AppRoutes.signUpPath;

        if (!isSignedIn() && isPrivate) return AppRoutes.signInPath;
        if (isSignedIn() && isAuthPage) return AppRoutes.homePath;
        return null;
      },
      routes: <RouteBase>[
        GoRoute(
          path: AppRoutes.homePath,
          name: AppRoutes.home,
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: AppRoutes.signInPath,
          name: AppRoutes.signIn,
          builder: (context, state) => const SignInScreen(),
        ),
        GoRoute(
          path: AppRoutes.signUpPath,
          name: AppRoutes.signUp,
          builder: (context, state) => const SignUpScreen(),
        ),
        GoRoute(
          path: AppRoutes.accountPath,
          name: AppRoutes.account,
          builder: (context, state) => const AccountScreen(),
        ),
        GoRoute(
          path: AppRoutes.appointmentsPath,
          name: AppRoutes.appointments,
          builder: (context, state) => const AppointmentsScreen(),
          routes: <RouteBase>[
            GoRoute(
              path: AppRoutes.appointmentNewPath,
              name: AppRoutes.appointmentNew,
              builder: (context, state) => const AppointmentFormScreen(),
            ),
            GoRoute(
              path: AppRoutes.appointmentDetailsPath,
              name: AppRoutes.appointmentDetails,
              builder: (context, state) =>
                  AppointmentDetailsScreen(appointmentId: _idFrom(state)),
              routes: <RouteBase>[
                GoRoute(
                  path: AppRoutes.appointmentEditPath,
                  name: AppRoutes.appointmentEdit,
                  builder: (context, state) =>
                      AppointmentFormScreen(appointmentId: _idFrom(state)),
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: AppRoutes.vehiclesPath,
          name: AppRoutes.vehicles,
          builder: (context, state) => const VehiclesScreen(),
          routes: <RouteBase>[
            GoRoute(
              path: AppRoutes.vehicleNewPath,
              name: AppRoutes.vehicleNew,
              builder: (context, state) => const VehicleFormScreen(),
            ),
            GoRoute(
              path: AppRoutes.vehicleEditPath,
              name: AppRoutes.vehicleEdit,
              builder: (context, state) =>
                  VehicleFormScreen(vehicleId: _idFrom(state)),
            ),
          ],
        ),
      ],
      errorBuilder: (context, state) =>
          const Scaffold(body: Center(child: Text(AppStrings.errorNotFound))),
    );
  }

  /// Lê o `:id` da URL. Um id inválido vira 0, e a tela mostra o erro.
  static int _idFrom(GoRouterState state) =>
      int.tryParse(state.pathParameters[AppRoutes.idParam] ?? '') ?? 0;
}
