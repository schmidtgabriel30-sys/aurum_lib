import 'package:flutter/material.dart';

import '../../../core/constants/home_content.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../widgets/eyebrow.dart';
import '../../../widgets/primary_button.dart';

/// Primeira dobra: título, chamada e imagem.
class HeroSection extends StatelessWidget {
  const HeroSection({super.key, required this.onSchedule});

  final VoidCallback onSchedule;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenPadding,
          AppSpacing.xxl,
          AppSpacing.screenPadding,
          AppSpacing.xl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Eyebrow(HomeContent.heroEyebrow),
            const SizedBox(height: AppSpacing.md),
            Text.rich(
              TextSpan(
                style: AppTextStyles.heroTitle,
                children: [
                  const TextSpan(text: HomeContent.heroTitleStart),
                  TextSpan(
                    text: HomeContent.heroTitleHighlight,
                    style: AppTextStyles.heroTitle.copyWith(
                      color: AppColors.gold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            const Text(HomeContent.heroText, style: AppTextStyles.bodyLarge),
            const SizedBox(height: AppSpacing.lg),
            PrimaryButton(
              HomeContent.heroButton,
              icon: Icons.north_east,
              onPressed: onSchedule,
            ),
            const SizedBox(height: AppSpacing.sm),
            const Center(
              child: Text(HomeContent.heroNote, style: AppTextStyles.caption),
            ),
          ],
        ),
      ),
      Image.asset(
        HomeContent.heroImage,
        width: double.infinity,
        height: AppSizes.heroImageHeight,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) =>
            Container(height: AppSizes.heroImageHeight, color: AppColors.beige),
      ),
      Container(
        color: AppColors.beige,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPadding,
          vertical: AppSpacing.sm,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(HomeContent.heroStrip, style: AppTextStyles.micro),
            Icon(Icons.south, size: AppSizes.iconXs, color: AppColors.muted),
          ],
        ),
      ),
    ],
  );
}
