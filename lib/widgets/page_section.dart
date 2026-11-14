import 'package:flutter/material.dart';

import '../core/theme/app_spacing.dart';

/// Bloco de conteúdo com o espaçamento padrão das seções.
class PageSection extends StatelessWidget {
  const PageSection({super.key, required this.child, this.background});

  final Widget child;
  final Color? background;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    color: background,
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.screenPadding,
      vertical: AppSpacing.xxxl,
    ),
    child: child,
  );
}
