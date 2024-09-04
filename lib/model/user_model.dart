import 'dart:convert';

class LocalUser {
  final String role;
  final String id;

  LocalUser({required this.role, required this.id});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'role': role,
      'id': id,
    };
  }

  factory LocalUser.fromMap(Map<String, dynamic> map) {
    return LocalUser(
      role: map['role'] as String,
      id: map['id'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory LocalUser.fromJson(String source) =>
      LocalUser.fromMap(json.decode(source) as Map<String, dynamic>);
}
