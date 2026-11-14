import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/app_strings.dart';
import '../models/app_user.dart';
import 'api_client.dart';

/// Autenticação na API Laravel (Sanctum).
///
/// É um [ChangeNotifier]: quando alguém entra ou sai, avisa quem estiver
/// escutando — o `go_router` usa isso para proteger as rotas.
class AuthService extends ChangeNotifier {
  AuthService._();

  static final AuthService instance = AuthService._();

  static const String _tokenKey = 'token';

  final ApiClient _api = ApiClient.instance;

  AppUser? _currentUser;

  AppUser? get currentUser => _currentUser;

  bool get isSignedIn => _api.token != null;

  /// Chamado no `main.dart`: recupera o token salvo no aparelho.
  Future<void> restoreSession() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _api.token = prefs.getString(_tokenKey);
    if (_api.token == null) return;

    try {
      await fetchCurrentUser();
    } on ApiException catch (e) {
      // Token vencido: limpa. Sem internet: mantém e tenta depois.
      if (e.isUnauthorized) await _clearSession();
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    try {
      final dynamic data = await _api.post('/login', <String, dynamic>{
        'email': email.trim(),
        'password': password,
      });
      await _saveSession(data);
    } on ApiException catch (e) {
      if (e.statusCode == 401 || e.statusCode == 422) {
        throw const ApiException(AppStrings.errorInvalidCredentials);
      }
      rethrow;
    }
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    final dynamic data = await _api.post('/register', <String, dynamic>{
      'name': name.trim(),
      'email': email.trim(),
      'password': password,
      'password_confirmation': passwordConfirmation,
    });
    await _saveSession(data);
  }

  Future<AppUser> fetchCurrentUser() async {
    final dynamic data = await _api.get('/user');
    final AppUser user = AppUser.fromJson(ApiClient.asMap(data));
    _currentUser = user;
    notifyListeners();
    return user;
  }

  Future<void> signOut() async {
    try {
      await _api.post('/logout');
    } on ApiException {
      // Mesmo se a API falhar, o usuário sai do app.
    }
    await _clearSession();
  }

  Future<void> _saveSession(dynamic data) async {
    final dynamic token = data is Map ? data['token'] : null;
    if (token is! String || token.isEmpty) {
      throw const ApiException(AppStrings.errorUnexpectedResponse);
    }

    _api.token = token;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);

    final dynamic user = (data as Map)['user'];
    if (user is Map<String, dynamic>) {
      _currentUser = AppUser.fromJson(user);
      notifyListeners();
    } else {
      try {
        await fetchCurrentUser();
      } on ApiException {
        notifyListeners(); // logado, só sem os dados do perfil ainda
      }
    }
  }

  Future<void> _clearSession() async {
    _api.token = null;
    _currentUser = null;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    notifyListeners();
  }
}
