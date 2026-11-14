import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../widgets/common.dart';

class OfferSection extends StatelessWidget {
  final VoidCallback onSchedule;
  const OfferSection({super.key, required this.onSchedule});

  @override
  Widget build(BuildContext context) => Section(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Eyebrow('A oferta em destaque'),
          const SizedBox(height: 12),
          const H2('Revisão preventiva\ncompleta'),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: C.beige,
              border: Border.all(color: C.line),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('PACOTE PROMOCIONAL',
                    style: TextStyle(fontSize: 7, color: C.gold, fontWeight: FontWeight.w700)),
                Icon(Icons.auto_awesome, size: 12, color: C.gold),
              ]),
              const SizedBox(height: 10),
              const Text('De R\$ 350,00',
                  style: TextStyle(
                      fontSize: 9, color: C.muted, decoration: TextDecoration.lineThrough)),
              const Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Text('R\$ ',
                      style: TextStyle(fontSize: 12, color: C.gold, fontWeight: FontWeight.w600)),
                ),
                Text('249,90',
                    style: TextStyle(fontSize: 30, color: C.gold, fontWeight: FontWeight.w500)),
              ]),
              const SizedBox(height: 4),
              RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 9, color: C.muted),
                  children: [
                    TextSpan(text: 'à vista', style: TextStyle(fontWeight: FontWeight.w700, color: C.ink)),
                    TextSpan(text: ' ou em até 3x sem juros'),
                  ],
                ),
              ),
              const Divider(height: 24),
              const Text('Óleo e filtro, check-up de 40 itens e diagnóstico eletrônico em um só pacote.',
                  style: TextStyle(fontSize: 10, color: C.muted, height: 1.5)),
              const SizedBox(height: 14),
              GoldButton('Agendar revisão agora', onPressed: onSchedule),
            ]),
          ),
        ]),
      );
}
