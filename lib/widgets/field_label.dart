import 'package:flutter/material.dart';

import '../core/constants/app_strings.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';

/// Rótulo exibido acima de um campo de formulário.
class FieldLabel extends StatelessWidget {
  const FieldLabel(this.text, {super.key, this.required = false});

  final String text;
  final bool required;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: AppSpacing.md, bottom: AppSpacing.sm),
    child: Text(
      required ? '$text${AppStrings.requiredMark}' : text,
      style: AppTextStyles.label,
    ),
  );
}
