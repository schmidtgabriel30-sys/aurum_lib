import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import '../models/appointment.dart';

/// Etiqueta colorida com a situação do agendamento.
///
/// Usada na lista e nos detalhes, por isso fica em `widgets/`.
class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status});

  final AppointmentStatus status;

  (Color, Color) get _colors => switch (status) {
    AppointmentStatus.pending => (AppColors.warning, AppColors.warningSoft),
    AppointmentStatus.confirmed => (AppColors.info, AppColors.infoSoft),
    AppointmentStatus.completed => (AppColors.success, AppColors.successSoft),
    AppointmentStatus.canceled => (AppColors.muted, AppColors.line),
  };

  @override
  Widget build(BuildContext context) {
    final (Color text, Color background) = _colors;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Text(
        status.label.toUpperCase(),
        style: AppTextStyles.tag.copyWith(color: text),
      ),
    );
  }
}
