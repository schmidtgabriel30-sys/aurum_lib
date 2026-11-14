import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';

/// Cartão clicável das listas (agendamentos e veículos): ícone à esquerda,
/// título, linhas de texto e um elemento opcional à direita.
class ListTileCard extends StatelessWidget {
  const ListTileCard({
    super.key,
    required this.icon,
    required this.title,
    required this.lines,
    required this.onTap,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final List<String> lines;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Material(
    color: AppColors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      side: const BorderSide(color: AppColors.line),
    ),
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            Container(
              width: AppSizes.iconBox + AppSpacing.md,
              height: AppSizes.iconBox + AppSpacing.md,
              decoration: BoxDecoration(
                color: AppColors.iconBackground,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(icon, size: AppSizes.iconLg, color: AppColors.gold),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.cardTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  for (final (index, line) in lines.indexed) ...[
                    if (index == 0) const SizedBox(height: AppSpacing.xs),
                    Text(
                      line,
                      style: index == 0
                          ? AppTextStyles.bodySmall
                          : AppTextStyles.caption,
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: AppSpacing.sm),
              trailing!,
            ],
            const Icon(
              Icons.chevron_right,
              size: AppSizes.iconLg,
              color: AppColors.muted,
            ),
          ],
        ),
      ),
    ),
  );
}
