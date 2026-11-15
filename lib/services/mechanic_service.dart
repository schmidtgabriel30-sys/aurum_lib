import '../models/mechanic.dart';
import 'api_client.dart';
import 'json_parser.dart';

/// Mecânicos ativos da oficina (`GET /mecanicos`), usados pelo admin ao
/// aceitar um agendamento.
class MechanicService {
  MechanicService._();

  static final MechanicService instance = MechanicService._();

  final ApiClient _api = ApiClient.instance;

  Future<List<Mechanic>> fetchAll() async {
    final dynamic data = await _api.get('/mecanicos');
    return JsonParser.parse(
      () => ApiClient.asList(data).map(Mechanic.fromJson).toList(),
    );
  }
}
