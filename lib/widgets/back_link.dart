import 'package:flutter/material.dart';

import '../core/constants/app_strings.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';

/// Link discreto "← Voltar".
class BackLink extends StatelessWidget {
  const BackLink({
    super.key,
    required this.onTap,
    this.label = AppStrings.back,
  });

  final VoidCallback onTap;
  final String label;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.arrow_back,
            size: AppSizes.iconXs,
            color: AppColors.muted,
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(label, style: AppTextStyles.bodySmall),
        ],
      ),
    ),
  );
}
