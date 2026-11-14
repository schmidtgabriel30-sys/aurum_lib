/// Usuário autenticado, como devolvido por `GET /user` na API Laravel.
class AppUser {
  const AppUser({required this.id, required this.name, required this.email});

  final int id;
  final String name;
  final String email;

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: int.tryParse('${json['id']}') ?? 0,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'name': name,
    'email': email,
  };
}
