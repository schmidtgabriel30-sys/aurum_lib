/// Item do catálogo de serviços da oficina (`/servicos` na API),
/// como "Troca de óleo" ou "Revisão preventiva completa".
///
/// Chama-se `ServiceItem` para não confundir com a camada `services/`.
class ServiceItem {
  const ServiceItem({
    required this.id,
    required this.name,
    required this.price,
    required this.durationMinutes,
    this.description = '',
  });

  final int id;
  final String name;
  final String description;
  final double price;
  final int durationMinutes;

  factory ServiceItem.fromJson(Map<String, dynamic> json) {
    return ServiceItem(
      id: int.tryParse('${json['id']}') ?? 0,
      name: json['nome'] as String? ?? '',
      description: json['descricao'] as String? ?? '',
      // O Laravel envia decimais como texto: "249.90".
      price: double.tryParse('${json['preco']}') ?? 0,
      durationMinutes: int.tryParse('${json['duracao_minutos']}') ?? 0,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'nome': name,
    'descricao': description,
    'preco': price,
    'duracao_minutos': durationMinutes,
  };
}
