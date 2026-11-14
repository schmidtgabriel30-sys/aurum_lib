/// Período do dia em que o cliente prefere levar o carro.
///
/// O `label` é exatamente o valor que a API Laravel grava no campo `periodo`.
enum AppointmentPeriod {
  morning('Manhã'),
  afternoon('Tarde'),
  evening('Noite');

  const AppointmentPeriod(this.label);

  final String label;

  static AppointmentPeriod fromLabel(String? label) {
    return AppointmentPeriod.values.firstWhere(
      (AppointmentPeriod p) => p.label == label,
      orElse: () => AppointmentPeriod.morning,
    );
  }
}

/// Agendamento de revisão — a entidade do CRUD.
///
/// Um model só descreve dados: não importa Flutter e não sabe nada de telas
/// ou de HTTP. A conversão de/para JSON acontece em [fromJson] e [toJson],
/// usando os mesmos nomes de campo da tabela `agendamentos` do Laravel.
class Appointment {
  const Appointment({
    this.id,
    required this.name,
    required this.phone,
    required this.vehicle,
    required this.preferredDate,
    required this.period,
    this.notes = '',
    this.contactConsent = false,
  });

  /// `null` enquanto o registro ainda não foi salvo na API.
  final int? id;
  final String name;
  final String phone;
  final String vehicle;
  final DateTime preferredDate;
  final AppointmentPeriod period;
  final String notes;
  final bool contactConsent;

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: int.tryParse('${json['id']}'),
      name: json['nome'] as String? ?? '',
      phone: json['celular'] as String? ?? '',
      vehicle: json['veiculo'] as String? ?? '',
      preferredDate: parseApiDate(json['data_preferencia']),
      period: AppointmentPeriod.fromLabel(json['periodo'] as String?),
      notes: json['observacoes'] as String? ?? '',
      contactConsent: _parseBool(json['aceite_contato']),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'nome': name,
    'celular': phone,
    'veiculo': vehicle,
    'data_preferencia': formatApiDate(preferredDate),
    'periodo': period.label,
    'observacoes': notes,
    'aceite_contato': contactConsent,
  };

  /// Formato da data enviado para a API (`dd/mm/aaaa`, o mesmo usado
  /// desde a primeira versão do app).
  static String formatApiDate(DateTime date) {
    final String day = date.day.toString().padLeft(2, '0');
    final String month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  /// Lê a data vinda da API. Aceita `dd/mm/aaaa`, `aaaa-mm-dd` e ISO 8601,
  /// porque o Laravel pode devolver qualquer um deles dependendo da coluna.
  static DateTime parseApiDate(Object? value) {
    final String text = '${value ?? ''}'.trim();

    final RegExpMatch? br = RegExp(
      r'^(\d{2})/(\d{2})/(\d{4})$',
    ).firstMatch(text);
    if (br != null) {
      return DateTime(
        int.parse(br.group(3)!),
        int.parse(br.group(2)!),
        int.parse(br.group(1)!),
      );
    }

    final DateTime? iso = DateTime.tryParse(text);
    if (iso != null) {
      // Ignora o horário: interessa só o dia escolhido.
      final DateTime local = iso.isUtc ? iso.toLocal() : iso;
      return DateTime(local.year, local.month, local.day);
    }

    throw FormatException('Data inválida vinda da API: $value');
  }

  /// O Laravel pode mandar booleanos como `true`, `1` ou `"1"`.
  static bool _parseBool(Object? value) =>
      value == true || value == 1 || value == '1' || value == 'true';
}
