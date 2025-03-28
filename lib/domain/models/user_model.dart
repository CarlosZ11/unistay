class UserModel {
  final String id; // Ahora es la PRIMARY KEY
  final String identification; // Ahora solo es UNIQUE
  final String name;
  final String lastname;
  final String email;
  final String phone;
  final String role;
  final String createdAt;

  UserModel({
    required this.id, // Ahora es la PRIMARY KEY
    required this.identification, // Ahora solo es UNIQUE
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
      'id': id, // Ahora PRIMARY KEY
      'identification': identification, // Ahora solo es UNIQUE
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
      id: map['id'] ?? '', // Ahora PRIMARY KEY
      identification: map['identification'] ?? '', // Ahora solo es UNIQUE
      name: map['name'] ?? '',
      lastname: map['lastname'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      role: map['role'] ?? '',
      createdAt: map['created_at'] ?? '',
    );
  }
}
