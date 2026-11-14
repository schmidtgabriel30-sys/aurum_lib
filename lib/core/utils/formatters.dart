import 'package:intl/intl.dart';

/// Formatação de datas, valores e textos no padrão brasileiro.
///
/// Concentrar isso aqui garante que nenhuma tela invente um formato próprio.
abstract final class Formatters {
  static final DateFormat _fullDate = DateFormat('dd/MM/yyyy', 'pt_BR');
  static final DateFormat _longDate = DateFormat("EEEE, d 'de' MMMM", 'pt_BR');
  static final NumberFormat _currency = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: r'R$',
    decimalDigits: 2,
  );

  /// `DateTime(2026, 9, 15)` → `15/09/2026`
  static String fullDate(DateTime date) => _fullDate.format(date);

  /// `DateTime(2026, 9, 15)` → `Terça-feira, 15 de setembro`
  static String longDate(DateTime date) {
    final String text = _longDate.format(date);
    return text[0].toUpperCase() + text.substring(1);
  }

  /// `249.9` → `R$ 249,90`
  static String currency(num value) => _currency.format(value);

  /// `abc-1d23` → `ABC1D23`
  static String plate(String value) =>
      value.toUpperCase().replaceAll(RegExp(r'[\s-]'), '');

  /// `João da Silva` → `JS`
  static String initials(String name) {
    final List<String> parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '';
    final String first = parts.first[0];
    final String last = parts.length > 1 ? parts.last[0] : '';
    return (first + last).toUpperCase();
  }
}
