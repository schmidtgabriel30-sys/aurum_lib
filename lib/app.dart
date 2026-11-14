import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import 'core/constants/app_strings.dart';
import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'services/auth_service.dart';

/// Widget raiz da Aurum.
///
/// Amarra três coisas: o tema (`AppTheme`), a navegação (`AppRouter`) e o
/// título do app. Nenhuma regra de negócio entra aqui.
class AurumApp extends StatefulWidget {
  const AurumApp({super.key});

  @override
  State<AurumApp> createState() => _AurumAppState();
}

class _AurumAppState extends State<AurumApp> {
  // Criado uma vez só: o router guarda a pilha de telas.
  final GoRouter _router = AppRouter.create(
    isSignedIn: () => AuthService.instance.isSignedIn,
    authChanges: AuthService.instance,
  );

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    title: AppStrings.appName,
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    routerConfig: _router,
    // Calendário, botões padrão e textos do Material em português.
    locale: const Locale('pt', 'BR'),
    supportedLocales: const [Locale('pt', 'BR')],
    localizationsDelegates: GlobalMaterialLocalizations.delegates,
  );
}
