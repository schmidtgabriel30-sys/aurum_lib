/// Veículo do cliente (`/veiculos` na API).
class Vehicle {
  const Vehicle({
    this.id,
    required this.brand,
    required this.model,
    required this.plate,
    required this.year,
  });

  /// `null` enquanto o veículo ainda não foi salvo na API.
  final int? id;
  final String brand;
  final String model;
  final String plate;
  final int year;

  /// Ex.: `Volkswagen Gol 2015`.
  String get title => '$brand $model $year';

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: int.tryParse('${json['id']}'),
      brand: json['marca'] as String? ?? '',
      model: json['modelo'] as String? ?? '',
      plate: json['placa'] as String? ?? '',
      year: int.tryParse('${json['ano']}') ?? 0,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'marca': brand,
    'modelo': model,
    'placa': plate,
    'ano': year,
  };
}
