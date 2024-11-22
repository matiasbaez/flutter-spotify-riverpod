import 'dart:convert';

class UserModel {
  String? id;
  String email;
  String name;

  UserModel({
    required this.email,
    required this.name,
    this.id,
  });

  factory UserModel.fromMap(Map<String, dynamic> json) {
    return UserModel(
      id: (json['id'] ?? '') as String,
      email: (json['email'] ?? '') as String,
      name: (json['name'] ?? '') as String,
    );
  }

  factory UserModel.fromJson(String data) =>
      UserModel.fromMap(json.decode(data) as Map<String, dynamic>);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'name': name,
    };
  }

  String toJson() => json.encode(toMap());

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? token,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
    );
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.email == email && other.name == name;
  }

  @override
  int get hashCode => name.hashCode ^ email.hashCode ^ id.hashCode;
}