import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Estilos de texto do app.
///
/// Nas telas, use sempre um destes estilos (combinando com `copyWith` quando
/// precisar trocar só a cor). A fonte (Inter) vem do tema em `app_theme.dart`.
abstract final class AppTextStyles {
  static const TextStyle heroTitle = TextStyle(
    fontSize: 30,
    height: 1.15,
    fontWeight: FontWeight.w700,
    color: AppColors.dark,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontSize: 22,
    height: 1.2,
    fontWeight: FontWeight.w700,
    color: AppColors.ink,
  );

  static const TextStyle pageTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.ink,
  );

  static const TextStyle appBarTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.ink,
  );

  static const TextStyle price = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w500,
    color: AppColors.gold,
  );

  static const TextStyle stepNumber = TextStyle(
    fontSize: 14,
    color: AppColors.gold,
  );

  static const TextStyle cardTitle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: AppColors.ink,
  );

  static const TextStyle itemTitle = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: AppColors.ink,
  );

  static const TextStyle button = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 11,
    height: 1.5,
    color: AppColors.muted,
  );

  static const TextStyle body = TextStyle(
    fontSize: 10,
    height: 1.5,
    color: AppColors.muted,
  );

  static const TextStyle input = TextStyle(fontSize: 10, color: AppColors.ink);

  static const TextStyle hint = TextStyle(fontSize: 10, color: AppColors.hint);

  static const TextStyle bodySmall = TextStyle(
    fontSize: 9,
    height: 1.5,
    color: AppColors.muted,
  );

  static const TextStyle label = TextStyle(
    fontSize: 9,
    fontWeight: FontWeight.w600,
    color: AppColors.ink,
  );

  static const TextStyle link = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    color: AppColors.gold,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 8,
    color: AppColors.muted,
  );

  static const TextStyle eyebrow = TextStyle(
    fontSize: 8,
    letterSpacing: 1,
    fontWeight: FontWeight.w600,
    color: AppColors.gold,
  );

  static const TextStyle tag = TextStyle(
    fontSize: 7,
    fontWeight: FontWeight.w700,
    color: AppColors.gold,
  );

  static const TextStyle micro = TextStyle(fontSize: 7, color: AppColors.muted);
}
