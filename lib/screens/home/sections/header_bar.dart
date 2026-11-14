import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/app_user.dart';
import '../../../widgets/app_logo.dart';

enum _MenuAction { appointments, vehicles, account, signOut }

/// Cabeçalho da página inicial: logo, botão "Agendar" e menu do usuário.
class HeaderBar extends StatelessWidget {
  const HeaderBar({
    super.key,
    required this.signedIn,
    required this.onSchedule,
    required this.onSignOut,
    this.user,
  });

  final bool signedIn;
  final AppUser? user;
  final VoidCallback onSchedule;
  final VoidCallback onSignOut;

  Widget _menuIcon() => Container(
    padding: const EdgeInsets.all(AppSpacing.sm),
    decoration: BoxDecoration(
      border: Border.all(color: AppColors.line),
      borderRadius: BorderRadius.circular(AppRadius.sm),
    ),
    child: const Icon(Icons.menu, size: AppSizes.iconLg),
  );

  PopupMenuItem<_MenuAction> _item(
    _MenuAction value,
    IconData icon,
    String text, {
    Color color = AppColors.ink,
  }) => PopupMenuItem<_MenuAction>(
    value: value,
    child: Row(
      children: [
        Icon(icon, size: AppSizes.iconMd, color: color),
        const SizedBox(width: AppSpacing.sm),
        Text(text, style: AppTextStyles.input.copyWith(color: color)),
      ],
    ),
  );

  Widget _userMenu(BuildContext context) => PopupMenuButton<_MenuAction>(
    tooltip: AppStrings.menuAccount,
    color: AppColors.white,
    elevation: 2,
    offset: const Offset(0, AppSpacing.xxxl + AppSpacing.md),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
      side: const BorderSide(color: AppColors.line),
    ),
    onSelected: (action) {
      switch (action) {
        case _MenuAction.appointments:
          context.goNamed(AppRoutes.appointments);
        case _MenuAction.vehicles:
          context.goNamed(AppRoutes.vehicles);
        case _MenuAction.account:
          context.goNamed(AppRoutes.account);
        case _MenuAction.signOut:
          onSignOut();
      }
    },
    itemBuilder: (_) => [
      if (user != null)
        PopupMenuItem<_MenuAction>(
          enabled: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user!.name, style: AppTextStyles.itemTitle),
              const SizedBox(height: AppSpacing.xxs),
              Text(user!.email, style: AppTextStyles.bodySmall),
            ],
          ),
        ),
      if (user != null) const PopupMenuDivider(),
      _item(
        _MenuAction.appointments,
        Icons.event_note_outlined,
        AppStrings.menuAppointments,
      ),
      _item(
        _MenuAction.vehicles,
        Icons.directions_car_outlined,
        AppStrings.menuVehicles,
      ),
      _item(_MenuAction.account, Icons.person_outline, AppStrings.menuAccount),
      _item(
        _MenuAction.signOut,
        Icons.logout,
        AppStrings.menuSignOut,
        color: AppColors.danger,
      ),
    ],
    child: _menuIcon(),
  );

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.screenPadding,
      vertical: AppSpacing.md,
    ),
    decoration: const BoxDecoration(
      border: Border(bottom: BorderSide(color: AppColors.line)),
    ),
    child: Row(
      children: [
        const AppLogo(),
        const Spacer(),
        TextButton(
          onPressed: onSchedule,
          child: const Text(AppStrings.menuSchedule),
        ),
        const SizedBox(width: AppSpacing.xs),
        if (signedIn)
          _userMenu(context)
        else
          InkWell(
            onTap: () => context.goNamed(AppRoutes.signIn),
            child: Tooltip(message: AppStrings.menuSignIn, child: _menuIcon()),
          ),
      ],
    ),
  );
}
