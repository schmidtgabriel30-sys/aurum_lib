import 'package:aurum/core/utils/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Validators', () {
    test('required recusa vazio e aceita texto', () {
      expect(Validators.required(''), isNotNull);
      expect(Validators.required('   '), isNotNull);
      expect(Validators.required('Gol 2015'), isNull);
    });

    test('email', () {
      expect(Validators.email('joao@'), isNotNull);
      expect(Validators.email('joao@email.com'), isNull);
    });

    test('password exige 8 caracteres', () {
      expect(Validators.password('1234567'), isNotNull);
      expect(Validators.password('12345678'), isNull);
    });

    test('phone aceita 10 ou 11 dígitos com máscara', () {
      expect(Validators.phone('(11) 9876'), isNotNull);
      expect(Validators.phone('(11) 98765-4321'), isNull);
      expect(Validators.phone('(11) 3456-7890'), isNull);
    });

    test('fullName exige nome e sobrenome', () {
      expect(Validators.fullName('João'), isNotNull);
      expect(Validators.fullName('João Silva'), isNull);
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

    test('consent exige marcação', () {
      expect(Validators.consent(false), isNotNull);
      expect(Validators.consent(true), isNull);
    });
  });
}
