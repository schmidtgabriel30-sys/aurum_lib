import 'package:flutter/material.dart';
import '../core/api.dart';
import '../core/theme.dart';
import '../widgets/common.dart';
import '../widgets/password_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nome = TextEditingController();
  final _email = TextEditingController();
  final _senha = TextEditingController();
  final _confirma = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    for (final c in [_nome, _email, _senha, _confirma]) {
      c.dispose();
    }
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

  Widget _label(String t) => Padding(
        padding: const EdgeInsets.only(top: 14, bottom: 6),
        child: Text(t, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600)),
      );

  void _msg(String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  void _back() => Navigator.canPop(context)
      ? Navigator.pop(context)
      : Navigator.pushReplacementNamed(context, '/');

  Future<void> _register() async {
    if (_nome.text.trim().isEmpty || _email.text.trim().isEmpty || _senha.text.isEmpty) {
      return _msg('Preencha todos os campos.');
    }
    if (_senha.text.length < 8) return _msg('A senha deve ter no mínimo 8 caracteres.');
    if (_senha.text != _confirma.text) return _msg('As senhas não conferem.');

    setState(() => _loading = true);
    final error = await Api.register(
      name: _nome.text.trim(),
      email: _email.text.trim(),
      password: _senha.text,
      confirmation: _confirma.text,
    );
    if (!mounted) return;
    setState(() => _loading = false);

    if (error == null) {
      Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
    } else {
      _msg(error);
    }
  }

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
                  const Text('Criar conta',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  const Text('Cadastre-se para agendar sua revisão',
                      textAlign: TextAlign.center, style: TextStyle(fontSize: 9, color: C.muted)),
                  const SizedBox(height: 10),
                  _label('Nome completo'),
                  TextField(controller: _nome, decoration: _dec('Como podemos chamar você?')),
                  _label('E-mail'),
                  TextField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: _dec('seuemail@exemplo.com')),
                  _label('Senha'),
                  PasswordField(controller: _senha, hint: 'Mínimo de 8 caracteres'),
                  _label('Confirmar senha'),
                  PasswordField(controller: _confirma, hint: 'Repita a senha'),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 44,
                    child: ElevatedButton(
                      onPressed: _loading ? null : _register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: C.ink,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(_loading ? 'Criando conta...' : 'Criar conta',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(height: 18),
                  InkWell(
                    onTap: () => Navigator.pushReplacementNamed(context, '/login'),
                    child: const Text('Já tem conta? Entrar',
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