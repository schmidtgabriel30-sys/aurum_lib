import 'package:go_router/go_router.dart';
import '../../screens/home_screen.dart';     // Troque pelos nomes reais das suas telas
import '../../screens/list_screen.dart';     // Exemplo de segunda tela
import '../../screens/form_screen.dart';     // Exemplo de terceira tela
import '../../screens/details_screen.dart';  // Exemplo de quarta tela

class AppRoutes {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/list',
        name: 'list',
        builder: (context, state) => const ListScreen(),
      ),
      GoRoute(
        path: '/form',
        name: 'form',
        builder: (context, state) => const FormScreen(),
      ),
      GoRoute(
        path: '/details',
        name: 'details',
        builder: (context, state) => const DetailsScreen(),
      ),
    ],
  );
}