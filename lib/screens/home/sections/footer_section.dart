import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../widgets/common.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  static const _links = [
    'Início', 'Sobre a Aurum', 'Oferta da revisão',
    'Dúvidas frequentes', 'Serviços incluídos', 'Agendamento',
  ];

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(border: Border(top: BorderSide(color: C.line))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Row(children: [
            AurumLogo(height: 40),
            SizedBox(width: 12),
            Expanded(
              child: Text('Cuidado em cada detalhe.\nNo carro e no seu caminho.',
                  style: TextStyle(fontSize: 9, color: C.muted)),
            ),
          ]),
          const SizedBox(height: 16),
          Wrap(runSpacing: 10, children: [
            for (final l in _links)
              FractionallySizedBox(
                widthFactor: .5,
                child: Text(l, style: const TextStyle(fontSize: 9)),
              ),
          ]),
          const Divider(height: 28),
          const Text('© Aurum Automotive. Todos os direitos reservados.',
              style: TextStyle(fontSize: 8, color: C.muted)),
        ]),
      );
}
