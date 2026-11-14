import 'package:flutter/material.dart';

import '../../../core/constants/home_content.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../widgets/eyebrow.dart';
import '../../../widgets/page_section.dart';
import '../../../widgets/section_title.dart';

/// Lista dos três serviços incluídos no pacote.
class IncludesSection extends StatelessWidget {
  const IncludesSection({super.key});

  @override
  Widget build(BuildContext context) => PageSection(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Eyebrow(HomeContent.includesEyebrow),
        const SizedBox(height: AppSpacing.md),
        const SectionTitle(HomeContent.includesTitle),
        const SizedBox(height: AppSpacing.sm),
        const Text(HomeContent.includesText, style: AppTextStyles.body),
        const SizedBox(height: AppSpacing.lg),
        for (final (icon, title, text, tag) in HomeContent.includes)
          Container(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.line)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: AppSizes.iconBox,
                  height: AppSizes.iconBox,
                  decoration: BoxDecoration(
                    color: AppColors.iconBackground,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Icon(
                    icon,
                    size: AppSizes.iconMd,
                    color: AppColors.gold,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: AppTextStyles.cardTitle),
                      const SizedBox(height: AppSpacing.xs),
                      Text(text, style: AppTextStyles.bodySmall),
                      const SizedBox(height: AppSpacing.sm),
                      Text(tag, style: AppTextStyles.tag),
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
