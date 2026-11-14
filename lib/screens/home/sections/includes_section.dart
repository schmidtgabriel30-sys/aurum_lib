import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../widgets/common.dart';

class IncludesSection extends StatelessWidget {
  const IncludesSection({super.key});

  static const _items = [
    (Icons.opacity, 'Troca de óleo e filtro de óleo',
        'Cuidado com a lubrificação para o bom funcionamento do motor.', 'PROTEÇÃO DO MOTOR'),
    (Icons.fact_check_outlined, 'Check-up completo de 40 itens',
        'Verificação de freios, suspensão, fluidos e correias para identificar pontos de atenção.',
        'VISÃO COMPLETA DO VEÍCULO'),
    (Icons.memory, 'Diagnóstico eletrônico computadorizado',
        'Leitura dos sistemas eletrônicos para apoiar a avaliação do seu carro.',
        'TECNOLOGIA NO DIAGNÓSTICO'),
  ];

  @override
  Widget build(BuildContext context) => Section(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Eyebrow('O que está incluído'),
          const SizedBox(height: 12),
          const H2('Três cuidados.\nUma revisão completa.'),
          const SizedBox(height: 8),
          const Text('Entenda cada serviço do pacote preventivo.',
              style: TextStyle(fontSize: 10, color: C.muted)),
          const SizedBox(height: 16),
          for (final i in _items)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: C.line))),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(color: C.iconBg, borderRadius: BorderRadius.circular(8)),
                  child: Icon(i.$1, size: 14, color: C.gold),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(i.$2, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text(i.$3, style: const TextStyle(fontSize: 9, color: C.muted, height: 1.5)),
                    const SizedBox(height: 6),
                    Text(i.$4,
                        style: const TextStyle(fontSize: 7, color: C.gold, fontWeight: FontWeight.w700)),
                  ]),
                ),
              ]),
            ),
        ]),
      );
}
