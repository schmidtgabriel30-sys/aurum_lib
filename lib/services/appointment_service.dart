import 'package:flutter/foundation.dart';

import '../models/appointment.dart';
import 'api_client.dart';
import 'json_parser.dart';

/// CRUD de agendamentos na API Laravel (`apiResource /agendamentos`).
///
/// | Ação      | Método | Rota                  |
/// |-----------|--------|-----------------------|
/// | listar    | GET    | /agendamentos         |
/// | detalhar  | GET    | /agendamentos/{id}    |
/// | criar     | POST   | /agendamentos         |
/// | editar    | PUT    | /agendamentos/{id}    |
/// | cancelar  | PUT    | /agendamentos/{id}    |
/// | status    | PUT    | /agendamentos/{id}    | (admin)
/// | excluir   | DELETE | /agendamentos/{id}    |
///
/// As telas nunca chamam a API: sempre passam por aqui e recebem models.
/// As regras (período lotado, status etc.) são validadas pela API, e as
/// mensagens de erro chegam às telas como [ApiException].
class AppointmentService {
  AppointmentService._();

  static final AppointmentService instance = AppointmentService._();

  static const String _path = '/agendamentos';

  final ApiClient _api = ApiClient.instance;

  /// Muda a cada criação, edição ou exclusão. As telas de lista e de
  /// detalhes escutam este contador para recarregar os dados.
  final ValueNotifier<int> changes = ValueNotifier<int>(0);

  /// A API pagina a lista (`{"data": [...], "total": ...}`). O app pede a
  /// primeira página; o admin pede mais itens com [perPage].
  Future<List<Appointment>> fetchAll({int? perPage}) async {
    final String query = perPage == null ? '' : '?per_page=$perPage';
    final dynamic data = await _api.get('$_path$query');
    return JsonParser.parse(
      () => ApiClient.asList(data).map(Appointment.fromJson).toList(),
    );
  }

  Future<Appointment> fetchById(int id) async {
    final dynamic data = await _api.get('$_path/$id');
    return JsonParser.parse(() => Appointment.fromJson(ApiClient.asMap(data)));
  }

  Future<void> create(Appointment appointment) async {
    await _api.post(_path, appointment.toJson());
    changes.value++;
  }

  Future<void> update(Appointment appointment) async {
    await _api.put('$_path/${appointment.id}', appointment.toUpdateJson());
    changes.value++;
  }

  Future<void> cancel(int id) async {
    await _api.put('$_path/$id', <String, dynamic>{
      'status': AppointmentStatus.canceled.apiValue,
    });
    changes.value++;
  }

  /// Admin: muda a situação e, opcionalmente, define o mecânico.
  Future<void> updateStatus(
    int id,
    AppointmentStatus status, {
    int? mechanicId,
  }) async {
    await _api.put('$_path/$id', <String, dynamic>{
      'status': status.apiValue,
      // O "?" só inclui a chave quando mechanicId não é nulo.
      'mecanico_id': ?mechanicId,
    });
    changes.value++;
  }

  Future<void> delete(int id) async {
    await _api.delete('$_path/$id');
    changes.value++;
  }
}
