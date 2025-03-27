class UserModel {
  final String identification; // PRIMARY KEY
  final String id; // UUID de Supabase, pero ya no es la clave primaria
  final String name;
  final String lastname;
  final String email;
  final String phone;
  final String role;
  final String createdAt;

  UserModel({
    required this.identification, // PRIMARY KEY
    required this.id, // UNIQUE pero no PRIMARY
    required this.name,
    required this.lastname,
    required this.email,
    required this.phone,
    required this.role,
    required this.createdAt,
  });

  // Convertir el modelo a un mapa para guardar en Supabase
  Map<String, dynamic> toMap() {
    return {
      'identification': identification, // PRIMARY KEY
      'id': id, // UUID de Supabase
      'name': name,
      'lastname': lastname,
      'email': email,
      'phone': phone,
      'role': role,
      'created_at': createdAt,
    };
  }

  // Crear una instancia de UserModel a partir de un mapa
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      identification: map['identification'] ?? '',
      id: map['id'] ?? '', // UUID de Supabase
      name: map['name'] ?? '',
      lastname: map['lastname'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      role: map['role'] ?? '',
      createdAt: map['created_at'] ?? '',
    );
  }
}
