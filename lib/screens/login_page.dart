import 'package:flutter/material.dart';
import '../core/api.dart';
import '../core/theme.dart';
import '../widgets/common.dart';
import '../widgets/password_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _email = TextEditingController();
  final _senha = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _email.dispose();
    _senha.dispose();
    super.dispose();
  }

  InputDecoration _dec(String h) => InputDecoration(
        hintText: h,
        hintStyle: const TextStyle(fontSize: 10, color: Color(0xFF9CA3AF)),
        filled: true,
        fillColor: Colors.white,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: C.line)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: C.ink)),
      );

  Future<void> _login() async {
    setState(() => _loading = true);
    final ok = await Api.login(_email.text.trim(), _senha.text);
    if (!mounted) return;
    setState(() => _loading = false);
    if (ok) {
      Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('E-mail ou senha inválidos.')));
    }
  }

  void _back() => Navigator.canPop(context)
      ? Navigator.pop(context)
      : Navigator.pushReplacementNamed(context, '/');

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: C.pageBg,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 360),
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  const Align(alignment: Alignment.centerLeft, child: AurumLogo(height: 28)),
                  const SizedBox(height: 16),
                  const Text('Entrar',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  const Text('Acesse sua conta para continuar',
                      textAlign: TextAlign.center, style: TextStyle(fontSize: 9, color: C.muted)),
                  const SizedBox(height: 24),
                  const Text('E-mail', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  TextField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: _dec('seuemail@exemplo.com')),
                  const SizedBox(height: 14),
                  const Text('Senha', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  PasswordField(controller: _senha),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 44,
                    child: ElevatedButton(
                      onPressed: _loading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: C.ink,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(_loading ? 'Entrando...' : 'Entrar',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text('Esqueceu sua senha?',
                      textAlign: TextAlign.center, style: TextStyle(fontSize: 9, color: C.muted)),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () => Navigator.pushReplacementNamed(context, '/cadastro'),
                    child: const Text('Não tem conta? Criar conta',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 9, color: C.gold, fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(height: 12),
                  const Row(children: [
                    Expanded(child: Divider()),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text('Ou', style: TextStyle(fontSize: 8, color: C.muted))),
                    Expanded(child: Divider()),
                  ]),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: _back,
                    child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(Icons.arrow_back, size: 11, color: C.muted),
                      SizedBox(width: 6),
                      Text('Voltar à página anterior',
                          style: TextStyle(fontSize: 9, color: C.muted)),
                    ]),
                  ),
                ]),
              ),
            ),
          ),
        ),
      );
}