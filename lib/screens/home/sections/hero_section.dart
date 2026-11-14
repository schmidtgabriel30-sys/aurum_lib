import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme.dart';
import '../../../widgets/common.dart';

class HeroSection extends StatelessWidget {
  final VoidCallback onSchedule;
  const HeroSection({super.key, required this.onSchedule});

  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Eyebrow('Cuidado automotivo • Aurum'),
            const SizedBox(height: 12),
            RichText(
              text: TextSpan(
                style: GoogleFonts.inter(
                    fontSize: 30, height: 1.15, fontWeight: FontWeight.w700, color: C.dark),
                children: const [
                  TextSpan(text: 'Seu carro merece\n'),
                  TextSpan(text: 'cuidado em\ncada detalhe.', style: TextStyle(color: C.gold)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Cuide do seu carro antes que ele cuide do seu bolso. Conheça nossa revisão preventiva completa.',
              style: TextStyle(fontSize: 11, color: C.muted, height: 1.5),
            ),
            const SizedBox(height: 16),
            GoldButton('Agendar revisão agora', onPressed: onSchedule),
            const SizedBox(height: 8),
            const Center(
              child: Text('Solicite online. Nossa equipe confirmará com você.',
                  style: TextStyle(fontSize: 8, color: C.muted)),
            ),
          ]),
        ),
        Image.asset('assets/images/hero.jpg',
            width: double.infinity,
            height: 190,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(height: 190, color: C.beige)),
        Container(
          color: C.beige,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('PREVENÇÃO EM PRIMEIRO LUGAR', style: TextStyle(fontSize: 7, color: C.muted)),
            Icon(Icons.south, size: 10, color: C.muted),
          ]),
        ),
      ]);
}
