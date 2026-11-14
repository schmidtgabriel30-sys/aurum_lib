import 'package:aurum/models/appointment.dart';
import 'package:aurum/models/service_item.dart';
import 'package:aurum/models/vehicle.dart';
import 'package:flutter_test/flutter_test.dart';

/// JSON no formato devolvido pela API Laravel (GET /agendamentos/{id}).
Map<String, dynamic> apiJson({String status = 'pendente'}) => {
  'id': 7,
  'user_id': 2,
  'veiculo_id': 3,
  'servico_id': 4,
  'mecanico_id': null,
  'data_agendamento': '2026-12-01',
  'periodo': 'tarde',
  'status': status,
  'observacoes': 'Barulho no freio',
  'veiculo': {
    'id': 3,
    'marca': 'Volkswagen',
    'modelo': 'Gol',
    'placa': 'ABC1D23',
    'ano': 2015,
  },
  'servico': {
    'id': 4,
    'nome': 'Revisão preventiva completa',
    'preco': '249.90',
    'duracao_minutos': 120,
  },
  'mecanico': null,
};

void main() {
  group('Appointment', () {
    test('fromJson lê os campos e as relações da API', () {
      final Appointment a = Appointment.fromJson(apiJson());

      expect(a.id, 7);
      expect(a.date, DateTime(2026, 12, 1));
      expect(a.period, AppointmentPeriod.afternoon);
      expect(a.status, AppointmentStatus.pending);
      expect(a.vehicle!.plate, 'ABC1D23');
      expect(a.service!.price, 249.90);
      expect(a.mechanicName, isNull);
    });

    test('lê data ISO sem mudar o dia por causa do fuso', () {
      expect(
        Appointment.parseApiDate('2026-12-01T00:00:00.000000Z'),
        DateTime(2026, 12, 1),
      );
    });

    test('ações permitidas dependem do status', () {
      final Appointment pending = Appointment.fromJson(apiJson());
      final Appointment confirmed = Appointment.fromJson(
        apiJson(status: 'confirmado'),
      );
      final Appointment done = Appointment.fromJson(
        apiJson(status: 'concluido'),
      );

      expect(pending.canEdit && pending.canCancel && pending.canDelete, isTrue);
      expect(confirmed.canEdit, isFalse);
      expect(confirmed.canCancel, isTrue);
      expect(done.canCancel || done.canDelete, isFalse);
    });

    test('toJson (criação) e toUpdateJson (edição) seguem a API', () {
      final Appointment a = Appointment(
        id: 7,
        vehicleId: 3,
        serviceId: 4,
        date: DateTime(2026, 12, 1),
        period: AppointmentPeriod.morning,
      );

      expect(a.toJson(), <String, dynamic>{
        'veiculo_id': 3,
        'servico_id': 4,
        'data_agendamento': '2026-12-01',
        'periodo': 'manha',
        'observacoes': '',
      });
      // Na edição a API proíbe enviar veículo e serviço.
      expect(a.toUpdateJson().containsKey('veiculo_id'), isFalse);
      expect(a.toUpdateJson().containsKey('servico_id'), isFalse);
    });
  });

  test('Vehicle converte de/para JSON', () {
    final Vehicle v = Vehicle.fromJson({
      'id': 1,
      'marca': 'Fiat',
      'modelo': 'Uno',
      'placa': 'ABC1234',
      'ano': '2010',
    });
    expect(v.year, 2010);
    expect(v.toJson(), {
      'marca': 'Fiat',
      'modelo': 'Uno',
      'placa': 'ABC1234',
      'ano': 2010,
    });
  });

  test('ServiceItem lê preço enviado como texto pelo Laravel', () {
    final ServiceItem s = ServiceItem.fromJson({
      'id': 1,
      'nome': 'Troca de óleo',
      'preco': '149.90',
      'duracao_minutos': 45,
    });
    expect(s.price, 149.90);
  });
}
