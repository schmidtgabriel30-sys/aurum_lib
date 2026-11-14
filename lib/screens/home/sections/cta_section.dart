import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/constants/home_content.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../widgets/eyebrow.dart';
import '../../../widgets/page_section.dart';
import '../../../widgets/primary_button.dart';
import '../../../widgets/section_title.dart';

/// Chamada final que leva ao formulário de agendamento.
class CtaSection extends StatelessWidget {
  const CtaSection({
    super.key,
    required this.onSchedule,
    required this.onSeeAppointments,
  });

  final VoidCallback onSchedule;
  final VoidCallback onSeeAppointments;

  @override
  Widget build(BuildContext context) => PageSection(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Eyebrow(HomeContent.ctaEyebrow),
        const SizedBox(height: AppSpacing.md),
        const SectionTitle(HomeContent.ctaTitle),
        const SizedBox(height: AppSpacing.sm),
        const Text(HomeContent.ctaText, style: AppTextStyles.body),
        const SizedBox(height: AppSpacing.lg),
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.beige,
            border: Border.all(color: AppColors.line),
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: const Row(
            children: [
              Icon(
                Icons.inventory_2_outlined,
                size: AppSizes.iconMd,
                color: AppColors.gold,
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppStrings.packageName, style: AppTextStyles.label),
                    SizedBox(height: AppSpacing.xxs),
                    Text(AppStrings.packagePrice, style: AppTextStyles.caption),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        PrimaryButton(HomeContent.ctaButton, onPressed: onSchedule),
        const SizedBox(height: AppSpacing.sm),
        OutlinedButton(
          onPressed: onSeeAppointments,
          child: const Text(HomeContent.ctaSecondary),
        ),
      ],
    ),
  );
}
