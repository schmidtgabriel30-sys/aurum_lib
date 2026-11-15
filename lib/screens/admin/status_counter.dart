import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/appointment.dart';

/// Cartão do painel com a quantidade de agendamentos de uma situação.
/// Tocar filtra a lista por essa situação.
class StatusCounter extends StatelessWidget {
  const StatusCounter({
    super.key,
    required this.status,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  final AppointmentStatus status;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: AppColors.adminSurface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      side: BorderSide(color: selected ? AppColors.gold : AppColors.adminLine),
    ),
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.md,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$count',
              style: AppTextStyles.sectionTitle.copyWith(color: AppColors.gold),
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              status.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.adminMuted,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
