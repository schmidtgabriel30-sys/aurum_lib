/// Usuário autenticado, como devolvido por `GET /user` na API Laravel.
class AppUser {
  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    this.username,
    this.isAdmin = false,
  });

  final int id;
  final String name;
  final String email;

  /// Só o administrador tem (ex.: `AdminA`).
  final String? username;

  /// Administrador da oficina: usa o painel em vez das telas de cliente.
  final bool isAdmin;

  factory AppUser.fromJson(Map<String, dynamic> json) {
    final Object? admin = json['is_admin'];
    return AppUser(
      id: int.tryParse('${json['id']}') ?? 0,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      username: json['username'] as String?,
      // O Laravel pode mandar true/false ou 1/0.
      isAdmin: admin == true || admin == 1 || admin == '1',
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'name': name,
    'email': email,
    'username': username,
    'is_admin': isAdmin,
  };
}
