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

/// Tela de cadastro de nova conta.
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmation = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    for (final TextEditingController c in [
      _name,
      _email,
      _password,
      _confirmation,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    try {
      await AuthService.instance.signUp(
        name: _name.text,
        email: _email.text,
        password: _password.text,
        passwordConfirmation: _confirmation.text,
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
            AppStrings.signUpTitle,
            textAlign: TextAlign.center,
            style: AppTextStyles.pageTitle,
          ),
          const SizedBox(height: AppSpacing.xs),
          const Text(
            AppStrings.signUpSubtitle,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall,
          ),
          AppTextField(
            label: AppStrings.fieldName,
            controller: _name,
            hint: AppStrings.hintName,
            textInputAction: TextInputAction.next,
            validator: Validators.fullName,
          ),
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
            hint: AppStrings.hintNewPassword,
            validator: Validators.password,
          ),
          PasswordField(
            controller: _confirmation,
            label: AppStrings.fieldPasswordConfirmation,
            hint: AppStrings.hintRepeatPassword,
            validator: (v) =>
                Validators.passwordConfirmation(v, _password.text),
          ),
          const SizedBox(height: AppSpacing.xl),
          PrimaryButton(
            AppStrings.signUpButton,
            dark: true,
            loading: _loading,
            loadingLabel: AppStrings.signUpLoading,
            onPressed: _submit,
          ),
          const SizedBox(height: AppSpacing.md),
          TextButton(
            onPressed: () => context.goNamed(AppRoutes.signIn),
            child: const Text(AppStrings.goToSignIn),
          ),
          const OrDivider(),
          const SizedBox(height: AppSpacing.md),
          BackLink(onTap: () => context.goNamed(AppRoutes.home)),
        ],
      ),
    ),
  );
}
