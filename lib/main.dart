import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app.dart';
import 'services/auth_service.dart';

/// Ponto de entrada do app.
///
/// Tudo o que precisa acontecer **antes** da primeira tela aparecer mora
/// aqui. A árvore de widgets em si fica em `app.dart`.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Carrega nomes de dias e meses em português para o `DateFormat`.
  await initializeDateFormatting('pt_BR');

  // Recupera o login salvo no aparelho (token do Laravel Sanctum).
  await AuthService.instance.restoreSession();

  runApp(const AurumApp());
}
