import 'package:flutter/material.dart';

import '../../../core/constants/home_content.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../widgets/eyebrow.dart';
import '../../../widgets/page_section.dart';
import '../../../widgets/section_title.dart';

/// Seção escura com os benefícios da prevenção.
class WhySection extends StatelessWidget {
  const WhySection({super.key});

  @override
  Widget build(BuildContext context) => PageSection(
    background: AppColors.dark,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Eyebrow(HomeContent.whyEyebrow, color: AppColors.sand),
        const SizedBox(height: AppSpacing.md),
        const SectionTitle(HomeContent.whyTitle, color: AppColors.white),
        const SizedBox(height: AppSpacing.xl),
        for (final (icon, title, text) in HomeContent.why)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.lg),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: AppSizes.iconMd, color: AppColors.sand),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.itemTitle.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        text,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.mutedOnDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    ),
  );
}
