import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../widgets/common.dart';

class FaqSection extends StatelessWidget {
  const FaqSection({super.key});

  static const _faqs = [
    ('O que está incluído na revisão?',
        'Troca de óleo e filtro, check-up completo de 40 itens (freios, suspensão, fluidos e correias) e diagnóstico eletrônico computadorizado.'),
    ('Posso parcelar a revisão?', 'Sim, em até 3x sem juros.'),
    ('O pacote é adequado ao meu veículo?', 'Nossa equipe confirma a compatibilidade ao entrar em contato.'),
    ('E se o carro precisar de outro serviço?', 'Você recebe a orientação e decide se deseja realizar.'),
    ('Enviar o formulário garante meu horário?',
        'Não. O envio é uma solicitação; o dia e o horário dependem da confirmação da equipe.'),
  ];

  @override
  Widget build(BuildContext context) => Section(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Eyebrow('Antes de agendar'),
          const SizedBox(height: 12),
          const H2('Suas dúvidas,\ncom clareza.'),
          const SizedBox(height: 12),
          for (var i = 0; i < _faqs.length; i++)
            Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: Container(
                decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: C.line))),
                child: ExpansionTile(
                  initiallyExpanded: i == 0,
                  tilePadding: EdgeInsets.zero,
                  childrenPadding: const EdgeInsets.only(bottom: 12),
                  expandedAlignment: Alignment.centerLeft,
                  iconColor: C.gold,
                  collapsedIconColor: C.muted,
                  title: Text(_faqs[i].$1,
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
                  children: [
                    Text(_faqs[i].$2,
                        style: const TextStyle(fontSize: 9, color: C.muted, height: 1.5)),
                  ],
                ),
              ),
            ),
        ]),
      );
}
