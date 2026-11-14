import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class C {
  static const gold = Color(0xFF86622B);
  static const dark = Color(0xFF2B241C);
  static const ink = Color(0xFF111827);
  static const beige = Color(0xFFF6F4EF);
  static const iconBg = Color(0xFFF1E8D8);
  static const line = Color(0xFFE8E4DC);
  static const muted = Color(0xFF6B6B6B);
  static const sand = Color(0xFFD8C7A0);
  static const pageBg = Color(0xFFF7F8FA);
}

ThemeData buildTheme() => ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.white,
      colorScheme: ColorScheme.fromSeed(seedColor: C.gold),
      textTheme: GoogleFonts.interTextTheme(),
      dividerColor: C.line,
    );
