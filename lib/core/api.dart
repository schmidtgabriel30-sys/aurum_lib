import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const String kBaseUrl = 'http://localhost:8000/api'; // emulador Android: http://10.0.2.2:8000/api

class Api {
  static Future<Map<String, String>> _headers() async {
    final p = await SharedPreferences.getInstance();
    final t = p.getString('token');
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (t != null) 'Authorization': 'Bearer $t',
    };
  }

  static Future<void> _saveToken(String token) async {
    final p = await SharedPreferences.getInstance();
    await p.setString('token', token);
  }

  static Future<bool> login(String email, String password) async {
    try {
      final r = await http.post(Uri.parse('$kBaseUrl/login'),
          headers: await _headers(),
          body: jsonEncode({'email': email, 'password': password}));
      if (r.statusCode != 200) return false;
      await _saveToken(jsonDecode(r.body)['token']);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Retorna null em caso de sucesso, ou a mensagem de erro.
  static Future<String?> register({
    required String name,
    required String email,
    required String password,
    required String confirmation,
  }) async {
    try {
      final r = await http.post(Uri.parse('$kBaseUrl/register'),
          headers: await _headers(),
          body: jsonEncode({
            'name': name,
            'email': email,
            'password': password,
            'password_confirmation': confirmation,
          }));
      final data = jsonDecode(r.body);
      if (r.statusCode == 200 || r.statusCode == 201) {
        await _saveToken(data['token']);
        return null;
      }
      if (r.statusCode == 422 && data['errors'] is Map) {
        return (data['errors'] as Map).values.first[0].toString();
      }
      return data['message']?.toString() ?? 'Erro ao cadastrar.';
    } catch (_) {
      return 'Sem conexão com o servidor.';
    }
  }

  static Future<Map<String, dynamic>?> me() async {
    try {
      final r = await http.get(Uri.parse('$kBaseUrl/user'), headers: await _headers());
      return r.statusCode == 200 ? jsonDecode(r.body) : null;
    } catch (_) {
      return null;
    }
  }

  static Future<void> logout() async {
    try {
      await http.post(Uri.parse('$kBaseUrl/logout'), headers: await _headers());
    } catch (_) {}
    final p = await SharedPreferences.getInstance();
    await p.remove('token');
  }

  static Future<bool> agendar(Map<String, dynamic> body) async {
    try {
      final r = await http.post(Uri.parse('$kBaseUrl/agendamentos'),
          headers: await _headers(), body: jsonEncode(body));
      return r.statusCode == 200 || r.statusCode == 201;
    } catch (_) {
      return false;
    }
  }
}