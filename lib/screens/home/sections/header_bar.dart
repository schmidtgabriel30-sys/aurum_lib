import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../widgets/common.dart';

class HeaderBar extends StatelessWidget {
  final VoidCallback onSchedule;
  final VoidCallback onLogout;
  final Map<String, dynamic>? user;

  const HeaderBar({
    super.key,
    required this.onSchedule,
    required this.onLogout,
    this.user,
  });

  Widget _menuButton() => Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
            border: Border.all(color: C.line), borderRadius: BorderRadius.circular(6)),
        child: const Icon(Icons.menu, size: 16),
      );

  Widget _userMenu(BuildContext context) => PopupMenuButton<String>(
        tooltip: '',
        padding: EdgeInsets.zero,
        color: Colors.white,
        elevation: 2,
        offset: const Offset(0, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: C.line),
        ),
        onSelected: (v) {
          if (v == 'conta') Navigator.pushNamed(context, '/conta');
          if (v == 'sair') onLogout();
        },
        itemBuilder: (_) => [
          PopupMenuItem<String>(
            enabled: false,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('${user?['name'] ?? ''}',
                  style: const TextStyle(
                      fontSize: 11, fontWeight: FontWeight.w700, color: C.ink)),
              const SizedBox(height: 2),
              Text('${user?['email'] ?? ''}',
                  style: const TextStyle(fontSize: 9, color: C.muted)),
            ]),
          ),
          const PopupMenuDivider(),
          const PopupMenuItem<String>(
            value: 'conta',
            child: Row(children: [
              Icon(Icons.person_outline, size: 14, color: C.ink),
              SizedBox(width: 8),
              Text('Minha conta', style: TextStyle(fontSize: 10, color: C.ink)),
            ]),
          ),
          const PopupMenuItem<String>(
            value: 'sair',
            child: Row(children: [
              Icon(Icons.logout, size: 14, color: Color(0xFFDC2626)),
              SizedBox(width: 8),
              Text('Sair', style: TextStyle(fontSize: 10, color: Color(0xFFDC2626))),
            ]),
          ),
        ],
        child: _menuButton(),
      );

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: C.line))),
        child: Row(children: [
          const AurumLogo(),
          const Spacer(),
          TextButton(
            onPressed: onSchedule,
            child: const Text('Agendar',
                style: TextStyle(fontSize: 10, color: C.gold, fontWeight: FontWeight.w600)),
          ),
          const SizedBox(width: 4),
          user == null
              ? InkWell(
                  onTap: () => Navigator.pushNamed(context, '/login'),
                  child: _menuButton(),
                )
              : _userMenu(context),
        ]),
      );
}

class PromoBar extends StatelessWidget {
  const PromoBar({super.key});

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        color: C.dark,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: const Row(children: [
          Icon(Icons.sell_outlined, size: 12, color: Color(0xFFE5D3AE)),
          SizedBox(width: 8),
          Text('Promoções diárias • até 40% de desconto',
              style: TextStyle(color: Color(0xFFE5D3AE), fontSize: 9)),
        ]),
      );
}