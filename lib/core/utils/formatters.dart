import 'package:intl/intl.dart';

/// Formatação de datas e textos no padrão brasileiro.
///
/// Concentrar isso aqui garante que nenhuma tela invente um formato próprio.
abstract final class Formatters {
  static final DateFormat _fullDate = DateFormat('dd/MM/yyyy', 'pt_BR');
  static final DateFormat _longDate = DateFormat("EEEE, d 'de' MMMM", 'pt_BR');

  /// `DateTime(2026, 9, 15)` → `15/09/2026`
  static String fullDate(DateTime date) => _fullDate.format(date);

  /// `DateTime(2026, 9, 15)` → `Terça-feira, 15 de setembro`
  static String longDate(DateTime date) {
    final String text = _longDate.format(date);
    return text[0].toUpperCase() + text.substring(1);
  }

  /// `11987654321` → `(11) 98765-4321`
  static String phone(String value) {
    final String d = value.replaceAll(RegExp(r'\D'), '');
    if (d.length < 3) return d;
    final String ddd = d.substring(0, 2);
    final String rest = d.substring(2);
    final int split = rest.length > 8 ? 5 : 4;
    if (rest.length <= split) return '($ddd) $rest';
    return '($ddd) ${rest.substring(0, split)}-${rest.substring(split)}';
  }

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
