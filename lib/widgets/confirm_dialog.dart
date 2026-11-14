import 'package:flutter/material.dart';

import '../core/constants/app_strings.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';

/// Diálogo de confirmação (ex.: antes de excluir).
///
/// Use `await ConfirmDialog.show(...)`: devolve `true` se o usuário confirmou.
class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    required this.confirmLabel,
  });

  final String title;
  final String message;
  final String confirmLabel;

  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmLabel,
  }) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => ConfirmDialog(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
      ),
    );
    return confirmed ?? false;
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    backgroundColor: AppColors.white,
    title: Text(title, style: AppTextStyles.appBarTitle),
    content: Text(message, style: AppTextStyles.body),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(false),
        child: Text(
          AppStrings.cancel,
          style: AppTextStyles.link.copyWith(color: AppColors.muted),
        ),
      ),
      TextButton(
        onPressed: () => Navigator.of(context).pop(true),
        child: Text(
          confirmLabel,
          style: AppTextStyles.link.copyWith(color: AppColors.danger),
        ),
      ),
    ],
  );
}
