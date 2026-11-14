import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_strings.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/validators.dart';
import '../../services/api_client.dart';
import '../../services/auth_service.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/back_link.dart';
import '../../widgets/narrow_page.dart';
import '../../widgets/or_divider.dart';
import '../../widgets/password_field.dart';
import '../../widgets/primary_button.dart';

/// Tela de login.
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    try {
      await AuthService.instance.signIn(
        email: _email.text,
        password: _password.text,
      );
      if (mounted) context.goNamed(AppRoutes.home);
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) => NarrowPage(
    child: Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: AppLogo(height: AppSizes.logoMd),
          ),
          const SizedBox(height: AppSpacing.lg),
          const Text(
            AppStrings.signInTitle,
            textAlign: TextAlign.center,
            style: AppTextStyles.pageTitle,
          ),
          const SizedBox(height: AppSpacing.xs),
          const Text(
            AppStrings.signInSubtitle,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            label: AppStrings.fieldEmail,
            controller: _email,
            hint: AppStrings.hintEmail,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: Validators.email,
          ),
          PasswordField(
            controller: _password,
            validator: (v) =>
                Validators.required(v, field: AppStrings.fieldPassword),
          ),
          const SizedBox(height: AppSpacing.lg),
          PrimaryButton(
            AppStrings.signInButton,
            dark: true,
            loading: _loading,
            loadingLabel: AppStrings.signInLoading,
            onPressed: _submit,
          ),
          const SizedBox(height: AppSpacing.lg),
          const Text(
            AppStrings.forgotPassword,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall,
          ),
          TextButton(
            onPressed: () => context.goNamed(AppRoutes.signUp),
            child: const Text(AppStrings.goToSignUp),
          ),
          const OrDivider(),
          const SizedBox(height: AppSpacing.md),
          BackLink(onTap: () => context.goNamed(AppRoutes.home)),
        ],
      ),
    ),
  );
}
