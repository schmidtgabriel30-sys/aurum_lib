import '../models/service_item.dart';
import 'api_client.dart';
import 'json_parser.dart';

/// Catálogo de serviços da oficina (`GET /servicos`).
///
/// Só leitura: quem cadastra serviços é o administrador, direto na API.
class ServiceItemService {
  ServiceItemService._();

  static final ServiceItemService instance = ServiceItemService._();

  final ApiClient _api = ApiClient.instance;

  Future<List<ServiceItem>> fetchAll() async {
    final dynamic data = await _api.get('/servicos');
    return JsonParser.parse(
      () => ApiClient.asList(data).map(ServiceItem.fromJson).toList(),
    );
  }
}
