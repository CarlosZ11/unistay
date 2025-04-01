class UserModel {
  final String id;
  final String identification;
  final String name;
  final String lastname;
  final String email;
  final String phone;
  final String role;
  final String createdAt;

  UserModel({
    required this.id,
    required this.identification,
    required this.name,
    required this.lastname,
    required this.email,
    required this.phone,
    required this.role,
    required this.createdAt,
  });

  /// 🔹 Convierte el modelo a un mapa para Supabase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'identification': identification,
      'name': name,
      'lastname': lastname,
      'email': email,
      'phone': phone,
      'role': role,
      'created_at': createdAt,
    };
  }

  /// 🔹 Crea un modelo a partir de un mapa (desde Supabase)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      identification: map['identification'] ?? '',
      name: map['name'] ?? '',
      lastname: map['lastname'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      role: map['role'] ?? '',
      createdAt: map['created_at'] ?? '',
    );
  }

  /// 🔹 Copia el usuario con nuevos valores (para actualizar datos sin modificar el objeto original)
  UserModel copyWith({
    String? identification,
    String? name,
    String? lastname,
    String? phone,
  }) {
    return UserModel(
      id: id,
      identification: identification ?? this.identification,
      name: name ?? this.name,
      lastname: lastname ?? this.lastname,
      email: email,
      phone: phone ?? this.phone,
      role: role,
      createdAt: createdAt,
    );
  }
}
