import 'package:flutter/material.dart';

import '../../../core/constants/home_content.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../widgets/eyebrow.dart';
import '../../../widgets/page_section.dart';
import '../../../widgets/primary_button.dart';
import '../../../widgets/section_title.dart';

/// Card com o preço da revisão.
class OfferSection extends StatelessWidget {
  const OfferSection({super.key, required this.onSchedule});

  final VoidCallback onSchedule;

  @override
  Widget build(BuildContext context) => PageSection(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Eyebrow(HomeContent.offerEyebrow),
        const SizedBox(height: AppSpacing.md),
        const SectionTitle(HomeContent.offerTitle),
        const SizedBox(height: AppSpacing.lg),
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.beige,
            border: Border.all(color: AppColors.line),
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(HomeContent.offerTag, style: AppTextStyles.tag),
                  Icon(
                    Icons.auto_awesome,
                    size: AppSizes.iconSm,
                    color: AppColors.gold,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                HomeContent.offerOldPrice,
                style: AppTextStyles.bodySmall.copyWith(
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                    child: Text(
                      HomeContent.offerCurrency,
                      style: AppTextStyles.cardTitle.copyWith(
                        color: AppColors.gold,
                      ),
                    ),
                  ),
                  const Text(
                    HomeContent.offerPrice,
                    style: AppTextStyles.price,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text.rich(
                TextSpan(
                  style: AppTextStyles.bodySmall,
                  children: [
                    TextSpan(
                      text: HomeContent.offerCash,
                      style: AppTextStyles.label.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const TextSpan(text: HomeContent.offerInstallments),
                  ],
                ),
              ),
              const Divider(height: AppSpacing.xxl),
              const Text(HomeContent.offerText, style: AppTextStyles.body),
              const SizedBox(height: AppSpacing.md),
              PrimaryButton(
                HomeContent.heroButton,
                icon: Icons.north_east,
                onPressed: onSchedule,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
