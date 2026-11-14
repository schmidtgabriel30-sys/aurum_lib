import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';

/// Layout das telas curtas e centralizadas (login, cadastro, conta).
class NarrowPage extends StatelessWidget {
  const NarrowPage({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.pageBackground,
    body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppSizes.maxNarrowWidth,
            ),
            child: child,
          ),
        ),
      ),
    ),
  );
}
