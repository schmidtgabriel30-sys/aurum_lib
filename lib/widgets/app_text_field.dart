import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/theme/app_text_styles.dart';
import 'field_label.dart';

/// Campo de texto com rótulo e validação.
///
/// A aparência (bordas, cores, espaçamento) vem do `inputDecorationTheme`.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.validator,
    this.keyboardType,
    this.inputFormatters,
    this.maxLines = 1,
    this.readOnly = false,
    this.onTap,
    this.suffixIcon,
    this.required = false,
    this.textInputAction,
  });

  final String label;
  final TextEditingController controller;
  final String? hint;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;
  final bool readOnly;
  final VoidCallback? onTap;
  final Widget? suffixIcon;
  final bool required;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      FieldLabel(label, required: required),
      TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        maxLines: maxLines,
        readOnly: readOnly,
        onTap: onTap,
        textInputAction: textInputAction,
        style: AppTextStyles.input,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(hintText: hint, suffixIcon: suffixIcon),
      ),
    ],
  );
}
