import 'service_item.dart';
import 'vehicle.dart';

/// Período do dia escolhido para o atendimento.
///
/// [apiValue] é o valor gravado pela API; [label] é o texto exibido.
enum AppointmentPeriod {
  morning('manha', 'Manhã'),
  afternoon('tarde', 'Tarde'),
  evening('noite', 'Noite');

  const AppointmentPeriod(this.apiValue, this.label);

  final String apiValue;
  final String label;

  static AppointmentPeriod fromApi(String? value) {
    return AppointmentPeriod.values.firstWhere(
      (AppointmentPeriod p) => p.apiValue == value,
      orElse: () => AppointmentPeriod.morning,
    );
  }
}

/// Situação do agendamento. O fluxo é decidido pela API:
/// pendente → confirmado → concluído (ou cancelado).
enum AppointmentStatus {
  pending('pendente', 'Pendente'),
  confirmed('confirmado', 'Confirmado'),
  completed('concluido', 'Concluído'),
  canceled('cancelado', 'Cancelado');

  const AppointmentStatus(this.apiValue, this.label);

  final String apiValue;
  final String label;

  static AppointmentStatus fromApi(String? value) {
    return AppointmentStatus.values.firstWhere(
      (AppointmentStatus s) => s.apiValue == value,
      orElse: () => AppointmentStatus.pending,
    );
  }
}

/// Agendamento de um serviço para um veículo — a entidade principal do CRUD.
///
/// Um model só descreve dados: não importa Flutter e não sabe nada de telas
/// ou de HTTP. Os nomes dos campos JSON são os da tabela `agendamentos`.
class Appointment {
  const Appointment({
    this.id,
    required this.vehicleId,
    required this.serviceId,
    required this.date,
    required this.period,
    this.status = AppointmentStatus.pending,
    this.notes = '',
    this.vehicle,
    this.service,
    this.mechanicName,
  });

  /// `null` enquanto o agendamento ainda não foi salvo na API.
  final int? id;
  final int vehicleId;
  final int serviceId;
  final DateTime date;
  final AppointmentPeriod period;
  final AppointmentStatus status;
  final String notes;

  /// Dados relacionados que a API devolve junto (`veiculo`, `servico`,
  /// `mecanico`). Podem faltar, por isso são opcionais.
  final Vehicle? vehicle;
  final ServiceItem? service;
  final String? mechanicName;

  /// O cliente só pode reagendar enquanto está pendente.
  bool get canEdit => status == AppointmentStatus.pending;

  bool get canCancel =>
      status == AppointmentStatus.pending ||
      status == AppointmentStatus.confirmed;

  /// A API não deixa excluir um agendamento concluído.
  bool get canDelete => status != AppointmentStatus.completed;

  factory Appointment.fromJson(Map<String, dynamic> json) {
    final Object? vehicle = json['veiculo'];
    final Object? service = json['servico'];
    final Object? mechanic = json['mecanico'];

    return Appointment(
      id: int.tryParse('${json['id']}'),
      vehicleId: int.tryParse('${json['veiculo_id']}') ?? 0,
      serviceId: int.tryParse('${json['servico_id']}') ?? 0,
      date: parseApiDate(json['data_agendamento']),
      period: AppointmentPeriod.fromApi(json['periodo'] as String?),
      status: AppointmentStatus.fromApi(json['status'] as String?),
      notes: json['observacoes'] as String? ?? '',
      vehicle: vehicle is Map<String, dynamic>
          ? Vehicle.fromJson(vehicle)
          : null,
      service: service is Map<String, dynamic>
          ? ServiceItem.fromJson(service)
          : null,
      mechanicName: mechanic is Map<String, dynamic>
          ? mechanic['nome'] as String?
          : null,
    );
  }

  /// Corpo do `POST /agendamentos`.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'veiculo_id': vehicleId,
    'servico_id': serviceId,
    'data_agendamento': formatApiDate(date),
    'periodo': period.apiValue,
    'observacoes': notes,
  };

  /// Corpo do `PUT /agendamentos/{id}`. Veículo e serviço não podem mudar
  /// depois de criado (a API recusa), então só vão data, período e notas.
  Map<String, dynamic> toUpdateJson() => <String, dynamic>{
    'data_agendamento': formatApiDate(date),
    'periodo': period.apiValue,
    'observacoes': notes,
  };

  /// `DateTime(2026, 11, 20)` → `2026-11-20`
  static String formatApiDate(DateTime date) {
    final String month = date.month.toString().padLeft(2, '0');
    final String day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  /// Lê `2026-11-20` (ou `2026-11-20T00:00:00Z`) considerando só o dia,
  /// sem converter fuso horário — senão o dia poderia "voltar" um.
  static DateTime parseApiDate(Object? value) {
    final RegExpMatch? match = RegExp(
      r'^(\d{4})-(\d{2})-(\d{2})',
    ).firstMatch('${value ?? ''}'.trim());
    if (match == null) {
      throw FormatException('Data inválida vinda da API: $value');
    }
    return DateTime(
      int.parse(match.group(1)!),
      int.parse(match.group(2)!),
      int.parse(match.group(3)!),
    );
  }
}
