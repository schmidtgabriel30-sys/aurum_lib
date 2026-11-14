import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../widgets/common.dart';

class WhySection extends StatelessWidget {
  const WhySection({super.key});

  static const _items = [
    (Icons.shield_outlined, 'Mais atenção à segurança',
        'Acompanhe as condições de componentes importantes para dirigir.'),
    (Icons.search, 'Menos surpresas no caminho',
        'Identifique sinais de desgaste antes que se tornem problemas maiores.'),
    (Icons.event_note_outlined, 'Manutenção com planejamento',
        'Entenda as necessidades do carro e organize os próximos cuidados.'),
  ];

  @override
  Widget build(BuildContext context) => Section(
        bg: C.dark,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Eyebrow('Por que prevenir', color: C.sand),
          const SizedBox(height: 12),
          const H2('O melhor cuidado começa\nantes.', color: Colors.white),
          const SizedBox(height: 20),
          for (final i in _items)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Icon(i.$1, size: 14, color: C.sand),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(i.$2,
                        style: const TextStyle(
                            fontSize: 11, color: Colors.white, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text(i.$3,
                        style: const TextStyle(fontSize: 9, color: Color(0xFFB9B2A6), height: 1.5)),
                  ]),
                ),
              ]),
            ),
        ]),
      );
}
