import 'package:flutter/material.dart';

import '../../../core/constants/home_content.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../widgets/eyebrow.dart';
import '../../../widgets/page_section.dart';
import '../../../widgets/section_title.dart';

/// Perguntas frequentes em acordeão.
class FaqSection extends StatelessWidget {
  const FaqSection({super.key});

  @override
  Widget build(BuildContext context) => PageSection(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Eyebrow(HomeContent.faqEyebrow),
        const SizedBox(height: AppSpacing.md),
        const SectionTitle(HomeContent.faqTitle),
        const SizedBox(height: AppSpacing.md),
        for (final (index, (question, answer)) in HomeContent.faq.indexed)
          Container(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.line)),
            ),
            child: ExpansionTile(
              initiallyExpanded: index == 0,
              tilePadding: EdgeInsets.zero,
              shape: const Border(),
              collapsedShape: const Border(),
              childrenPadding: const EdgeInsets.only(bottom: AppSpacing.md),
              expandedAlignment: Alignment.centerLeft,
              iconColor: AppColors.gold,
              collapsedIconColor: AppColors.muted,
              title: Text(
                question,
                style: AppTextStyles.itemTitle.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              children: [Text(answer, style: AppTextStyles.bodySmall)],
            ),
          ),
      ],
    ),
  );
}
