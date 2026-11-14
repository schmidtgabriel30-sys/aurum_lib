import 'package:flutter/material.dart';
import '../core/theme.dart';

class Eyebrow extends StatelessWidget {
  final String text;
  final Color color;
  const Eyebrow(this.text, {super.key, this.color = C.gold});

  @override
  Widget build(BuildContext context) => Row(children: [
        Container(width: 16, height: 1, color: color),
        const SizedBox(width: 8),
        Text(text.toUpperCase(),
            style: TextStyle(fontSize: 8, letterSpacing: 1, fontWeight: FontWeight.w600, color: color)),
      ]);
}

class H2 extends StatelessWidget {
  final String text;
  final Color color;
  const H2(this.text, {super.key, this.color = C.ink});

  @override
  Widget build(BuildContext context) => Text(text,
      style: TextStyle(fontSize: 22, height: 1.2, fontWeight: FontWeight.w700, color: color));
}

class GoldButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  const GoldButton(this.label, {super.key, this.icon = Icons.north_east, this.onPressed});

  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        height: 44,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: C.gold,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            if (icon != null) Icon(icon, size: 14),
          ]),
        ),
      );
}

class Section extends StatelessWidget {
  final Widget child;
  final Color? bg;
  const Section({super.key, required this.child, this.bg});

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        color: bg,
        padding: const EdgeInsets.fromLTRB(20, 32, 20, 32),
        child: child,
      );
}

class AurumLogo extends StatelessWidget {
  final double height;
  const AurumLogo({super.key, this.height = 36});

  @override
  Widget build(BuildContext context) => Image.asset('assets/images/logo.png',
      height: height,
      errorBuilder: (_, __, ___) => Text('AURUM',
          style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 2, fontSize: height / 2.4)));
}
