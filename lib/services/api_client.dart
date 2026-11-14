import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/constants/app_strings.dart';

/// Erro de comunicação com a API, já com a mensagem pronta para a tela.
class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  bool get isUnauthorized => statusCode == 401;

  @override
  String toString() => message;
}

/// Cliente HTTP da API Laravel.
///
/// Concentra o que é igual em todas as requisições: endereço base, cabeçalhos,
/// token Bearer (Sanctum), tempo limite e tradução dos erros. Os outros
/// services (auth, agendamentos) usam este cliente e nunca chamam `http`
/// diretamente.
class ApiClient {
  ApiClient._();

  static final ApiClient instance = ApiClient._();

  /// Endereço da API. Pode ser trocado sem mexer no código:
  /// `flutter run --dart-define=API_URL=http://10.0.2.2:8000/api`
  ///
  /// - Navegador ou Windows: `http://localhost:8000/api`
  /// - Emulador Android:     `http://10.0.2.2:8000/api`
  static const String baseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://localhost:8000/api',
  );

  static const Duration _timeout = Duration(seconds: 15);

  /// Token recebido no login. Fica `null` quando ninguém está logado.
  String? token;

  Map<String, String> get _headers => <String, String>{
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    if (token != null) 'Authorization': 'Bearer $token',
  };

  Uri _uri(String path) => Uri.parse('$baseUrl$path');

  Future<dynamic> get(String path) =>
      _send(() => http.get(_uri(path), headers: _headers));

  Future<dynamic> post(String path, [Map<String, dynamic>? body]) => _send(
    () => http.post(_uri(path), headers: _headers, body: jsonEncode(body)),
  );

  Future<dynamic> put(String path, Map<String, dynamic> body) => _send(
    () => http.put(_uri(path), headers: _headers, body: jsonEncode(body)),
  );

  Future<dynamic> delete(String path) =>
      _send(() => http.delete(_uri(path), headers: _headers));

  Future<dynamic> _send(Future<http.Response> Function() request) async {
    final http.Response response;
    try {
      response = await request().timeout(_timeout);
    } on TimeoutException {
      throw const ApiException(AppStrings.errorNoConnection);
    } on http.ClientException {
      throw const ApiException(AppStrings.errorNoConnection);
    }

    final dynamic data = _decode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) return data;

    throw ApiException(
      _errorMessage(response.statusCode, data),
      statusCode: response.statusCode,
    );
  }

  dynamic _decode(String body) {
    if (body.isEmpty) return null;
    try {
      return jsonDecode(body);
    } on FormatException {
      return null; // por exemplo, uma página HTML de erro
    }
  }

  /// Traduz a resposta de erro do Laravel em uma mensagem para o usuário.
  String _errorMessage(int status, dynamic data) {
    if (status == 401) return AppStrings.errorUnauthorized;
    if (status == 404) return AppStrings.errorNotFound;

    if (data is Map) {
      // 422: erros de validação → {"errors": {"campo": ["mensagem"]}}
      final dynamic errors = data['errors'];
      if (errors is Map && errors.isNotEmpty) {
        final dynamic first = errors.values.first;
        if (first is List && first.isNotEmpty) return '${first.first}';
      }
      final dynamic message = data['message'];
      if (message is String && message.isNotEmpty) return message;
    }
    return AppStrings.errorGeneric;
  }

  /// Respostas do Laravel podem vir "embrulhadas" em `{"data": ...}`
  /// (API Resources) ou não. Estes dois métodos aceitam as duas formas.
  static Map<String, dynamic> asMap(dynamic data) {
    if (data is Map<String, dynamic>) {
      final dynamic inner = data['data'];
      return inner is Map<String, dynamic> ? inner : data;
    }
    throw const ApiException(AppStrings.errorUnexpectedResponse);
  }

  static List<Map<String, dynamic>> asList(dynamic data) {
    final dynamic list = data is Map<String, dynamic> ? data['data'] : data;
    if (list is List) return list.whereType<Map<String, dynamic>>().toList();
    throw const ApiException(AppStrings.errorUnexpectedResponse);
  }
}
