/// Mecânico da oficina (`/mecanicos` na API). Usado pelo admin para
/// escolher quem vai atender o agendamento.
class Mechanic {
  const Mechanic({required this.id, required this.name, this.specialty = ''});

  final int id;
  final String name;
  final String specialty;

  factory Mechanic.fromJson(Map<String, dynamic> json) {
    return Mechanic(
      id: int.tryParse('${json['id']}') ?? 0,
      name: json['nome'] as String? ?? '',
      specialty: json['especialidade'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'nome': name,
    'especialidade': specialty,
  };
}
