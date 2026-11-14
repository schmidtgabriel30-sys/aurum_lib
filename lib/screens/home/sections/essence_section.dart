import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../widgets/common.dart';

class EssenceSection extends StatelessWidget {
  final VoidCallback onSchedule;
  const EssenceSection({super.key, required this.onSchedule});

  @override
  Widget build(BuildContext context) => Section(
        bg: C.beige,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Eyebrow('Essência Aurum'),
            AurumLogo(height: 26),
          ]),
          const SizedBox(height: 12),
          const H2('Cuidado com o carro.\nRespeito por você.'),
          const SizedBox(height: 12),
          const Text(
            'Na Aurum Automotive, acreditamos que cuidar do seu carro também é cuidar da sua rotina. Nossa proposta une manutenção preventiva, diagnóstico e informação clara para orientar suas escolhas.',
            style: TextStyle(fontSize: 10, color: C.muted, height: 1.6),
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: onSchedule,
            child: const Row(children: [
              Text('Vamos cuidar do seu carro?',
                  style: TextStyle(fontSize: 10, color: C.gold, fontWeight: FontWeight.w600)),
              SizedBox(width: 6),
              Icon(Icons.north_east, size: 11, color: C.gold),
            ]),
          ),
        ]),
      );
}
