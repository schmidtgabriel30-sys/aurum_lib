import 'package:flutter/material.dart';

import '../../../core/constants/home_content.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

/// Faixa escura de promoção abaixo do cabeçalho.
class PromoBar extends StatelessWidget {
  const PromoBar({super.key});

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    color: AppColors.dark,
    padding: const EdgeInsets.symmetric(
      vertical: AppSpacing.md,
      horizontal: AppSpacing.screenPadding,
    ),
    child: Row(
      children: [
        const Icon(
          Icons.sell_outlined,
          size: AppSizes.iconSm,
          color: AppColors.promoText,
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          HomeContent.promo,
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.promoText),
        ),
      ],
    ),
  );
}
