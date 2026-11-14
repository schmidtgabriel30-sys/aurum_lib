import 'package:flutter/foundation.dart';

import '../models/vehicle.dart';
import 'api_client.dart';
import 'json_parser.dart';

/// CRUD dos veículos do cliente na API Laravel (`apiResource /veiculos`).
///
/// A API só devolve os veículos do usuário logado.
class VehicleService {
  VehicleService._();

  static final VehicleService instance = VehicleService._();

  static const String _path = '/veiculos';

  final ApiClient _api = ApiClient.instance;

  /// Muda a cada criação, edição ou exclusão; as telas escutam para
  /// recarregar a lista.
  final ValueNotifier<int> changes = ValueNotifier<int>(0);

  Future<List<Vehicle>> fetchAll() async {
    final dynamic data = await _api.get(_path);
    return JsonParser.parse(
      () => ApiClient.asList(data).map(Vehicle.fromJson).toList(),
    );
  }

  Future<Vehicle> fetchById(int id) async {
    final dynamic data = await _api.get('$_path/$id');
    return JsonParser.parse(() => Vehicle.fromJson(ApiClient.asMap(data)));
  }

  Future<void> create(Vehicle vehicle) async {
    await _api.post(_path, vehicle.toJson());
    changes.value++;
  }

  Future<void> update(Vehicle vehicle) async {
    await _api.put('$_path/${vehicle.id}', vehicle.toJson());
    changes.value++;
  }

  /// A API recusa (409) se o veículo tiver agendamento em aberto.
  Future<void> delete(int id) async {
    await _api.delete('$_path/$id');
    changes.value++;
  }
}
