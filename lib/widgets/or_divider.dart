import 'package:flutter/material.dart';

import '../core/constants/app_strings.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';

/// Linha divisória com "Ou" no meio.
class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) => const Row(
    children: [
      Expanded(child: Divider()),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        child: Text(AppStrings.or, style: AppTextStyles.caption),
      ),
      Expanded(child: Divider()),
    ],
  );
}
