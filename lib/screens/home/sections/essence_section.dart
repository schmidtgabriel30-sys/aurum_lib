import 'package:flutter/material.dart';

import '../../../core/constants/home_content.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../widgets/app_logo.dart';
import '../../../widgets/eyebrow.dart';
import '../../../widgets/page_section.dart';
import '../../../widgets/section_title.dart';

/// Texto institucional sobre a marca.
class EssenceSection extends StatelessWidget {
  const EssenceSection({super.key, required this.onSchedule});

  final VoidCallback onSchedule;

  @override
  Widget build(BuildContext context) => PageSection(
    background: AppColors.beige,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Eyebrow(HomeContent.essenceEyebrow),
            AppLogo(height: AppSizes.logoSm),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        const SectionTitle(HomeContent.essenceTitle),
        const SizedBox(height: AppSpacing.md),
        const Text(HomeContent.essenceText, style: AppTextStyles.body),
        const SizedBox(height: AppSpacing.md),
        InkWell(
          onTap: onSchedule,
          child: const Row(
            children: [
              Text(HomeContent.essenceLink, style: AppTextStyles.link),
              SizedBox(width: AppSpacing.sm),
              Icon(
                Icons.north_east,
                size: AppSizes.iconXs,
                color: AppColors.gold,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
