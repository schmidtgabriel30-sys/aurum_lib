import '../constants/app_strings.dart';

/// Validações reaproveitáveis dos formulários.
///
/// Cada função devolve `null` quando o valor é válido e uma mensagem de erro
/// quando não é — exatamente o contrato que o `validator:` do
/// `TextFormField` espera. As regras espelham as da API Laravel, para o
/// usuário ver o erro antes mesmo de enviar.
abstract final class Validators {
  static final RegExp _emailPattern = RegExp(r'^[\w.\-+]+@[\w\-]+\.[\w\-.]+$');

  /// Placa antiga (ABC1234) ou Mercosul (ABC1D23).
  static final RegExp _platePattern = RegExp(
    r'^[A-Z]{3}[0-9][A-Z0-9][0-9]{2}$',
  );

  static const int passwordMinLength = 8;
  static const int minVehicleYear = 1950;

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

  /// Aceita com ou sem hífen e em minúsculas: `abc-1d23` é válida.
  static String? plate(String? value) {
    final String? empty = required(value, field: AppStrings.fieldPlate);
    if (empty != null) return empty;

    final String normalized = value!.toUpperCase().replaceAll(
      RegExp(r'[\s-]'),
      '',
    );
    if (!_platePattern.hasMatch(normalized)) return AppStrings.validationPlate;
    return null;
  }

  /// Ano entre 1950 e o próximo ano (mesma regra da API).
  static String? year(String? value, {DateTime? today}) {
    final String? empty = required(value, field: AppStrings.fieldYear);
    if (empty != null) return empty;

    final int max = (today ?? DateTime.now()).year + 1;
    final int? year = int.tryParse(value!.trim());
    if (year == null || year < minVehicleYear || year > max) {
      return '${AppStrings.validationYear} $minVehicleYear '
          '${AppStrings.validationYearAnd} $max.';
    }
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
}
