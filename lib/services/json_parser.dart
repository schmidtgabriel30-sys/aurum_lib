import '../core/constants/app_strings.dart';
import 'api_client.dart';

/// Converte JSON em models e transforma qualquer dado fora do formato
/// esperado em [ApiException]. Reaproveitado por todos os services.
abstract final class JsonParser {
  static T parse<T>(T Function() convert) {
    try {
      return convert();
    } on FormatException {
      throw const ApiException(AppStrings.errorUnexpectedResponse);
    } on TypeError {
      throw const ApiException(AppStrings.errorUnexpectedResponse);
    }
  }
}
