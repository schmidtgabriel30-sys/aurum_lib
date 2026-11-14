import 'package:flutter/material.dart';

import '../core/constants/app_strings.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import 'field_label.dart';

/// Campo de senha com rótulo e botão para mostrar/ocultar.
class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    required this.controller,
    this.label = AppStrings.fieldPassword,
    this.hint = AppStrings.hintPassword,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final FormFieldValidator<String>? validator;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _hidden = true;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      FieldLabel(widget.label),
      TextFormField(
        controller: widget.controller,
        obscureText: _hidden,
        validator: widget.validator,
        style: AppTextStyles.input,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          hintText: widget.hint,
          suffixIcon: IconButton(
            icon: Icon(
              _hidden
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              size: AppSizes.iconLg,
              color: AppColors.muted,
            ),
            onPressed: () => setState(() => _hidden = !_hidden),
          ),
        ),
      ),
    ],
  );
}
