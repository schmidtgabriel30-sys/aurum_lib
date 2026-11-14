import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';

/// Pequeno título em caixa alta com um traço à esquerda.
class Eyebrow extends StatelessWidget {
  const Eyebrow(this.text, {super.key, this.color = AppColors.gold});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(width: AppSizes.eyebrowLine, height: 1, color: color),
      const SizedBox(width: AppSpacing.sm),
      Text(
        text.toUpperCase(),
        style: AppTextStyles.eyebrow.copyWith(color: color),
      ),
    ],
  );
}
