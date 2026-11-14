import 'package:flutter/services.dart';

import 'formatters.dart';

/// Aplica a máscara `(00) 00000-0000` enquanto o usuário digita.
class PhoneInputFormatter extends TextInputFormatter {
  static const int _maxDigits = 11;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.length > _maxDigits) digits = digits.substring(0, _maxDigits);

    final String masked = Formatters.phone(digits);
    return TextEditingValue(
      text: masked,
      selection: TextSelection.collapsed(offset: masked.length),
    );
  }
}
