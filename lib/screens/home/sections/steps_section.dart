import 'package:flutter/material.dart';

import '../../../core/constants/home_content.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../widgets/eyebrow.dart';
import '../../../widgets/page_section.dart';
import '../../../widgets/section_title.dart';

/// Os três passos para agendar.
class StepsSection extends StatelessWidget {
  const StepsSection({super.key});

  @override
  Widget build(BuildContext context) => PageSection(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Eyebrow(HomeContent.stepsEyebrow),
        const SizedBox(height: AppSpacing.md),
        const SectionTitle(HomeContent.stepsTitle),
        const SizedBox(height: AppSpacing.lg),
        for (final (number, title, text) in HomeContent.steps)
          Container(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.line)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: AppSizes.numberColumn,
                  child: Text(number, style: AppTextStyles.stepNumber),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: AppTextStyles.cardTitle),
                      const SizedBox(height: AppSpacing.xs),
                      Text(text, style: AppTextStyles.bodySmall),
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
