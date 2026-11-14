import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'pages/home/home_page.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/account_page.dart';

void main() => runApp(const AurumApp());

class AurumApp extends StatelessWidget {
  const AurumApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Aurum Automotive',
        theme: buildTheme(),
        routes: {
          '/': (_) => const HomePage(),
          '/login': (_) => const LoginPage(),
          '/cadastro': (_) => const RegisterPage(),
          '/conta': (_) => const AccountPage(),
        },
      );
}