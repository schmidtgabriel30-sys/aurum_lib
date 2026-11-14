import '../constants/app_strings.dart';

/// Validações reaproveitáveis dos formulários.
///
/// Cada função devolve `null` quando o valor é válido e uma mensagem de erro
/// quando não é — exatamente o contrato que o `validator:` do
/// `TextFormField` espera.
abstract final class Validators {
  static final RegExp _emailPattern = RegExp(r'^[\w.\-+]+@[\w\-]+\.[\w\-.]+$');

  static const int passwordMinLength = 8;

  static String? required(String? value, {String field = 'Este campo'}) {
    if (value == null || value.trim().isEmpty) {
      return '$field ${AppStrings.validationRequired}';
    }
    return null;
  }

  /// Para dropdowns e outros campos que não são texto.
  static String? requiredSelection(
    Object? value, {
    String field = 'Este campo',
  }) {
    return value == null ? '$field ${AppStrings.validationRequired}' : null;
  }

  static String? fullName(String? value) {
    final String? empty = required(value, field: AppStrings.fieldName);
    if (empty != null) return empty;

    if (value!.trim().split(RegExp(r'\s+')).length < 2) {
      return AppStrings.validationName;
    }
    return null;
  }

  static String? email(String? value) {
    final String? empty = required(value, field: AppStrings.fieldEmail);
    if (empty != null) return empty;

    if (!_emailPattern.hasMatch(value!.trim())) {
      return AppStrings.validationEmail;
    }
    return null;
  }

  static String? password(String? value) {
    final String? empty = required(value, field: AppStrings.fieldPassword);
    if (empty != null) return empty;

    if (value!.length < passwordMinLength) {
      return '${AppStrings.validationPasswordMin} $passwordMinLength '
          '${AppStrings.validationPasswordChars}';
    }
    return null;
  }

  static String? passwordConfirmation(String? value, String original) {
    if (value != original) return AppStrings.validationPasswordMatch;
    return null;
  }

  /// Aceita celular com DDD: 10 ou 11 dígitos, com ou sem máscara.
  static String? phone(String? value) {
    final String? empty = required(value, field: AppStrings.fieldPhone);
    if (empty != null) return empty;

    final int digits = value!.replaceAll(RegExp(r'\D'), '').length;
    if (digits < 10 || digits > 11) return AppStrings.validationPhone;
    return null;
  }

  /// A data não pode ser anterior a hoje.
  static String? futureDate(DateTime? value, {DateTime? today}) {
    if (value == null) {
      return '${AppStrings.fieldDate} ${AppStrings.validationRequired}';
    }
    final DateTime now = today ?? DateTime.now();
    final DateTime start = DateTime(now.year, now.month, now.day);
    if (value.isBefore(start)) return AppStrings.validationPastDate;
    return null;
  }

  static String? consent(bool? value) {
    return value == true ? null : AppStrings.validationConsent;
  }
}
