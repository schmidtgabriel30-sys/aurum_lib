import 'package:aurum/core/utils/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Validators', () {
    test('required recusa vazio e aceita texto', () {
      expect(Validators.required(''), isNotNull);
      expect(Validators.required('   '), isNotNull);
      expect(Validators.required('Gol'), isNull);
    });

    test('email', () {
      expect(Validators.email('joao@'), isNotNull);
      expect(Validators.email('joao@email.com'), isNull);
    });

    test('password exige 8 caracteres', () {
      expect(Validators.password('1234567'), isNotNull);
      expect(Validators.password('12345678'), isNull);
    });

    test('fullName exige nome e sobrenome', () {
      expect(Validators.fullName('João'), isNotNull);
      expect(Validators.fullName('João Silva'), isNull);
    });

    test('plate aceita padrão antigo e Mercosul, com hífen ou minúsculas', () {
      expect(Validators.plate('ABC1234'), isNull);
      expect(Validators.plate('abc-1d23'), isNull);
      expect(Validators.plate('AB12345'), isNotNull);
      expect(Validators.plate(''), isNotNull);
    });

    test('year aceita de 1950 até o próximo ano', () {
      final DateTime today = DateTime(2026, 11, 14);
      expect(Validators.year('1949', today: today), isNotNull);
      expect(Validators.year('2015', today: today), isNull);
      expect(Validators.year('2027', today: today), isNull);
      expect(Validators.year('2028', today: today), isNotNull);
      expect(Validators.year('abc', today: today), isNotNull);
    });

    test('futureDate recusa datas passadas', () {
      final DateTime today = DateTime(2026, 11, 14);
      expect(Validators.futureDate(null, today: today), isNotNull);
      expect(
        Validators.futureDate(DateTime(2026, 11, 13), today: today),
        isNotNull,
      );
      expect(
        Validators.futureDate(DateTime(2026, 11, 14), today: today),
        isNull,
      );
    });
  });
}
