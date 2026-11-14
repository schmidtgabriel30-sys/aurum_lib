import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';

/// Botão vermelho para ações destrutivas (sair, excluir).
class DangerButton extends StatelessWidget {
  const DangerButton(this.label, {super.key, this.onPressed, this.icon});

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => OutlinedButton.icon(
    onPressed: onPressed,
    icon: icon == null ? null : Icon(icon, size: AppSizes.iconMd),
    label: Text(label, style: AppTextStyles.button),
    style: OutlinedButton.styleFrom(
      backgroundColor: AppColors.dangerSoft,
      foregroundColor: AppColors.danger,
      side: const BorderSide(color: AppColors.dangerBorder),
    ),
  );
}
