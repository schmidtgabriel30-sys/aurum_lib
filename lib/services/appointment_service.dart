import 'package:flutter/foundation.dart';

import '../core/constants/app_strings.dart';
import '../models/appointment.dart';
import 'api_client.dart';

/// CRUD de agendamentos na API Laravel.
///
/// Rotas usadas (padrão `Route::apiResource('agendamentos', ...)`):
///
/// | Ação      | Método | Rota                  |
/// |-----------|--------|-----------------------|
/// | listar    | GET    | /agendamentos         |
/// | detalhar  | GET    | /agendamentos/{id}    |
/// | criar     | POST   | /agendamentos         |
/// | editar    | PUT    | /agendamentos/{id}    |
/// | excluir   | DELETE | /agendamentos/{id}    |
///
/// As telas nunca chamam a API: sempre passam por aqui e recebem models.
class AppointmentService {
  AppointmentService._();

  static final AppointmentService instance = AppointmentService._();

  static const String _path = '/agendamentos';

  final ApiClient _api = ApiClient.instance;

  /// Muda de valor a cada criação, edição ou exclusão. As telas de lista e
  /// de detalhes escutam este contador para recarregar os dados.
  final ValueNotifier<int> changes = ValueNotifier<int>(0);

  Future<List<Appointment>> fetchAll() async {
    final dynamic data = await _api.get(_path);
    return _parse(
      () => ApiClient.asList(data).map(Appointment.fromJson).toList(),
    );
  }

  Future<Appointment> fetchById(int id) async {
    final dynamic data = await _api.get('$_path/$id');
    return _parse(() => Appointment.fromJson(ApiClient.asMap(data)));
  }

  Future<void> create(Appointment appointment) async {
    await _api.post(_path, appointment.toJson());
    changes.value++;
  }

  Future<void> update(Appointment appointment) async {
    await _api.put('$_path/${appointment.id}', appointment.toJson());
    changes.value++;
  }

  Future<void> delete(int id) async {
    await _api.delete('$_path/$id');
    changes.value++;
  }

  /// Transforma JSON fora do formato esperado em [ApiException].
  T _parse<T>(T Function() parse) {
    try {
      return parse();
    } on FormatException {
      throw const ApiException(AppStrings.errorUnexpectedResponse);
    } on TypeError {
      throw const ApiException(AppStrings.errorUnexpectedResponse);
    }
  }
}
