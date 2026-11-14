import 'package:flutter/material.dart';

import '../../../core/constants/home_content.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../widgets/app_logo.dart';

/// Rodapé da página inicial.
class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(AppSpacing.screenPadding),
    decoration: const BoxDecoration(
      border: Border(top: BorderSide(color: AppColors.line)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            AppLogo(height: AppSizes.logoXl),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                HomeContent.footerTagline,
                style: AppTextStyles.bodySmall,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Wrap(
          runSpacing: AppSpacing.md,
          children: [
            for (final link in HomeContent.footerLinks)
              FractionallySizedBox(
                widthFactor: .5,
                child: Text(
                  link,
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.ink),
                ),
              ),
          ],
        ),
        const Divider(height: AppSpacing.xxl + AppSpacing.xs),
        const Text(HomeContent.footerCopyright, style: AppTextStyles.caption),
      ],
    ),
  );
}
