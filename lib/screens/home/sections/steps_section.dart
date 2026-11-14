import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../widgets/common.dart';

class StepsSection extends StatelessWidget {
  const StepsSection({super.key});

  static const _items = [
    ('01', 'Conte sobre o seu carro', 'Preencha seus dados de contato e as informações do veículo.'),
    ('02', 'Indique sua preferência', 'Escolha o dia e o período em que gostaria de fazer a revisão.'),
    ('03', 'Aguarde a confirmação',
        'Nossa equipe entra em contato para combinar os detalhes e confirmar a disponibilidade.'),
  ];

  @override
  Widget build(BuildContext context) => Section(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Eyebrow('Do seu jeito, sem complicação'),
          const SizedBox(height: 12),
          const H2('Seu próximo cuidado em\ntrês passos.'),
          const SizedBox(height: 16),
          for (final s in _items)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: C.line))),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                SizedBox(
                    width: 34,
                    child: Text(s.$1, style: const TextStyle(fontSize: 14, color: C.gold))),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(s.$2, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text(s.$3, style: const TextStyle(fontSize: 9, color: C.muted, height: 1.5)),
                  ]),
                ),
              ]),
            ),
        ]),
      );
}
