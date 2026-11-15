import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';

/// Estrutura visual do painel do administrador: barra escura com o selo
/// "ADMIN" em dourado, diferente das telas do cliente.
///
/// Usada pelas telas do painel (lista e atendimento).
class AdminScaffold extends StatelessWidget {
  const AdminScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions = const [],
  });

  static const String _badge = 'ADMIN';

  final String title;
  final Widget body;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.pageBackground,
    appBar: AppBar(
      backgroundColor: AppColors.adminBackground,
      foregroundColor: AppColors.adminText,
      shape: const Border(bottom: BorderSide(color: AppColors.gold)),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xxs,
            ),
            decoration: BoxDecoration(
              color: AppColors.gold,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Text(
              _badge,
              style: AppTextStyles.tag.copyWith(color: AppColors.white),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.appBarTitle.copyWith(
                color: AppColors.adminText,
              ),
            ),
          ),
        ],
      ),
      actions: actions,
    ),
    body: body,
  );
}
