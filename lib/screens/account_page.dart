import 'package:flutter/material.dart';
import '../core/api.dart';
import '../core/theme.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  void _home(BuildContext context) =>
      Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: C.pageBg,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 360),
                child: FutureBuilder<Map<String, dynamic>?>(
                  future: Api.me(),
                  builder: (context, snap) {
                    if (snap.connectionState != ConnectionState.done) {
                      return const Center(child: CircularProgressIndicator(color: C.gold));
                    }
                    final u = snap.data ?? {'name': 'João Silva', 'email': 'joao.silva@email.com'};
                    return Column(mainAxisSize: MainAxisSize.min, children: [
                      const Text('Minha Conta',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      const Text('Você está conectado(a)',
                          style: TextStyle(fontSize: 9, color: C.muted)),
                      const SizedBox(height: 20),
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: C.line,
                        backgroundImage: u['avatar'] != null
                            ? NetworkImage(u['avatar'])
                            : const AssetImage('assets/images/avatar.jpg') as ImageProvider,
                      ),
                      const SizedBox(height: 8),
                      Text(u['name'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                      Text(u['email'], style: const TextStyle(fontSize: 8, color: C.muted)),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: OutlinedButton(
                          onPressed: () async {
                            await Api.logout();
                            if (context.mounted) _home(context);
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFEFEF),
                            foregroundColor: const Color(0xFFDC2626),
                            side: const BorderSide(color: Color(0xFFFCA5A5)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          ),
                          child: const Text('Sair da conta',
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
                        ),
                      ),
                      const SizedBox(height: 14),
                      InkWell(
                        onTap: () => _home(context),
                        child: const Row(children: [
                          Icon(Icons.arrow_back, size: 11, color: C.muted),
                          SizedBox(width: 6),
                          Text('Voltar à página anterior',
                              style: TextStyle(fontSize: 9, color: C.muted)),
                        ]),
                      ),
                    ]);
                  },
                ),
              ),
            ),
          ),
        ),
      );
}
