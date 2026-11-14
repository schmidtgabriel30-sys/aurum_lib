import 'package:aurum/models/appointment.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Appointment', () {
    test('fromJson lê os campos da API Laravel', () {
      final Appointment a = Appointment.fromJson(<String, dynamic>{
        'id': 7,
        'nome': 'João Silva',
        'celular': '11987654321',
        'veiculo': 'Gol 2015',
        'data_preferencia': '2026-12-01',
        'periodo': 'Tarde',
        'observacoes': 'Barulho no freio',
        'aceite_contato': 1,
      });

      expect(a.id, 7);
      expect(a.name, 'João Silva');
      expect(a.preferredDate, DateTime(2026, 12, 1));
      expect(a.period, AppointmentPeriod.afternoon);
      expect(a.contactConsent, isTrue);
    });

    test('aceita data no formato brasileiro e ISO com horário', () {
      expect(Appointment.parseApiDate('01/12/2026'), DateTime(2026, 12, 1));
      expect(
        Appointment.parseApiDate('2026-12-01T00:00:00'),
        DateTime(2026, 12, 1),
      );
    });

    test('toJson gera o corpo enviado para a API', () {
      final Appointment a = Appointment(
        name: 'João Silva',
        phone: '11987654321',
        vehicle: 'Gol 2015',
        preferredDate: DateTime(2026, 12, 1),
        period: AppointmentPeriod.morning,
        contactConsent: true,
      );

      expect(a.toJson(), <String, dynamic>{
        'nome': 'João Silva',
        'celular': '11987654321',
        'veiculo': 'Gol 2015',
        'data_preferencia': '01/12/2026',
        'periodo': 'Manhã',
        'observacoes': '',
        'aceite_contato': true,
      });
    });
  });
}
