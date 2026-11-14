import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';

/// Título grande de seção.
class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key, this.color = AppColors.ink});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) =>
      Text(text, style: AppTextStyles.sectionTitle.copyWith(color: color));
}
