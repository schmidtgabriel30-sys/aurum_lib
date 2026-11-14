import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';

/// Botão principal (dourado, ou escuro com [dark]).
///
/// Com [loading] verdadeiro, fica desabilitado e mostra [loadingLabel].
class PrimaryButton extends StatelessWidget {
  const PrimaryButton(
    this.label, {
    super.key,
    this.onPressed,
    this.icon,
    this.loading = false,
    this.loadingLabel,
    this.dark = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool loading;
  final String? loadingLabel;
  final bool dark;

  @override
  Widget build(BuildContext context) => ElevatedButton(
    onPressed: loading ? null : onPressed,
    style: dark
        ? ElevatedButton.styleFrom(backgroundColor: AppColors.ink)
        : null,
    child: Row(
      mainAxisAlignment: icon == null
          ? MainAxisAlignment.center
          : MainAxisAlignment.spaceBetween,
      children: [
        Text(
          loading ? (loadingLabel ?? label) : label,
          style: AppTextStyles.button,
        ),
        if (icon != null) Icon(icon, size: AppSizes.iconMd),
      ],
    ),
  );
}
