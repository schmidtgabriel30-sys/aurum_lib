import 'package:flutter/material.dart';

/// Paleta da Aurum Automotive.
///
/// Nenhuma cor deve ser escrita "na mão" dentro das telas: sempre use uma
/// constante daqui. Assim a identidade visual muda em um lugar só.
abstract final class AppColors {
  // Marca
  static const Color gold = Color(0xFF86622B);
  static const Color sand = Color(0xFFD8C7A0);
  static const Color promoText = Color(0xFFE5D3AE);

  // Superfícies
  static const Color white = Color(0xFFFFFFFF);
  static const Color dark = Color(0xFF2B241C);
  static const Color beige = Color(0xFFF6F4EF);
  static const Color iconBackground = Color(0xFFF1E8D8);
  static const Color pageBackground = Color(0xFFF7F8FA);
  static const Color line = Color(0xFFE8E4DC);

  // Texto
  static const Color ink = Color(0xFF111827);
  static const Color muted = Color(0xFF6B6B6B);
  static const Color hint = Color(0xFF9CA3AF);
  static const Color mutedOnDark = Color(0xFFB9B2A6);

  // Situação do agendamento
  static const Color warning = Color(0xFFB45309);
  static const Color warningSoft = Color(0xFFFDF0D5);
  static const Color info = Color(0xFF1D4ED8);
  static const Color infoSoft = Color(0xFFDBEAFE);
  static const Color success = Color(0xFF15803D);
  static const Color successSoft = Color(0xFFDCFCE7);

  // Estados
  static const Color danger = Color(0xFFDC2626);
  static const Color dangerSoft = Color(0xFFFFEFEF);
  static const Color dangerBorder = Color(0xFFFCA5A5);
  static const Color transparent = Color(0x00000000);
}
