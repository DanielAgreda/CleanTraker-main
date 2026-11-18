import 'dart:convert';

class UserModel {
  final String id;
  final String name;
  final String email;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
  });

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts[0].isEmpty) return 'US';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  /// El registro solo pide correo y contraseña; el nombre visible se deriva del correo.
  factory UserModel.fromAuth({required String id, required String email}) =>
      UserModel(id: id, name: email.split('@').first, email: email);

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'email': email,
      };

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
        id: map['id'] ?? '',
        name: map['name'] ?? '',
        email: map['email'] ?? '',
      );

  String toJson() => json.encode(toMap());
  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));
}
