import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../models/appointment.dart';

/// Item da lista de agendamentos.
class AppointmentCard extends StatelessWidget {
  const AppointmentCard({
    super.key,
    required this.appointment,
    required this.onTap,
  });

  final Appointment appointment;
  final VoidCallback onTap;

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
              child: const Icon(
                Icons.directions_car_outlined,
                size: AppSizes.iconLg,
                color: AppColors.gold,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appointment.vehicle,
                    style: AppTextStyles.cardTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '${Formatters.fullDate(appointment.preferredDate)} • '
                    '${appointment.period.label}',
                    style: AppTextStyles.bodySmall,
                  ),
                  Text(appointment.name, style: AppTextStyles.caption),
                ],
              ),
            ),
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
