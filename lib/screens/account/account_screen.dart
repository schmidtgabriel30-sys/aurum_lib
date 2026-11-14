import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_strings.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../models/app_user.dart';
import '../../services/auth_service.dart';
import '../../widgets/back_link.dart';
import '../../widgets/danger_button.dart';
import '../../widgets/error_state.dart';
import '../../widgets/loading_state.dart';
import '../../widgets/narrow_page.dart';

/// Perfil do usuário logado, buscado em `GET /user`.
class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late Future<AppUser> _future = AuthService.instance.fetchCurrentUser();

  void _reload() =>
      setState(() => _future = AuthService.instance.fetchCurrentUser());

  Future<void> _signOut() async {
    await AuthService.instance.signOut();
    if (mounted) context.goNamed(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) => NarrowPage(
    child: FutureBuilder<AppUser>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const LoadingState();
        }
        if (snapshot.hasError) {
          return ErrorState(message: '${snapshot.error}', onRetry: _reload);
        }

        final AppUser user = snapshot.data!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              AppStrings.accountTitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.pageTitle,
            ),
            const SizedBox(height: AppSpacing.xs),
            const Text(
              AppStrings.accountSubtitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall,
            ),
            const SizedBox(height: AppSpacing.xl),
            Center(
              child: CircleAvatar(
                radius: AppSizes.avatarRadius,
                backgroundColor: AppColors.iconBackground,
                child: Text(
                  Formatters.initials(user.name),
                  style: AppTextStyles.cardTitle.copyWith(
                    color: AppColors.gold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              user.name,
              textAlign: TextAlign.center,
              style: AppTextStyles.cardTitle,
            ),
            Text(
              user.email,
              textAlign: TextAlign.center,
              style: AppTextStyles.caption,
            ),
            const SizedBox(height: AppSpacing.xl),
            OutlinedButton.icon(
              onPressed: () => context.goNamed(AppRoutes.appointments),
              icon: const Icon(
                Icons.event_note_outlined,
                size: AppSizes.iconMd,
              ),
              label: const Text(AppStrings.menuAppointments),
            ),
            const SizedBox(height: AppSpacing.sm),
            OutlinedButton.icon(
              onPressed: () => context.goNamed(AppRoutes.vehicles),
              icon: const Icon(
                Icons.directions_car_outlined,
                size: AppSizes.iconMd,
              ),
              label: const Text(AppStrings.menuVehicles),
            ),
            const SizedBox(height: AppSpacing.sm),
            DangerButton(
              AppStrings.accountSignOut,
              icon: Icons.logout,
              onPressed: _signOut,
            ),
            const SizedBox(height: AppSpacing.md),
            BackLink(
              label: AppStrings.backHome,
              onTap: () => context.goNamed(AppRoutes.home),
            ),
          ],
        );
      },
    ),
  );
}
