import 'dart:convert';

class Alojamiento {
  String id;
  String nombre;
  String ubicacion;
  double precio;
  bool disponible;
  String? descripcion;
  DateTime createdAt;

  Alojamiento({
    required this.id,
    required this.nombre,
    required this.ubicacion,
    required this.precio,
    required this.disponible,
    this.descripcion,
    required this.createdAt,
  });

  // Convertir de JSON a objeto Dart
  factory Alojamiento.fromJson(Map<String, dynamic> json) {
    return Alojamiento(
      id: json['id'],
      nombre: json['nombre'],
      ubicacion: json['ubicacion'],
      precio: json['precio'].toDouble(),
      disponible: json['disponible'],
      descripcion: json['descripcion'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  // Convertir de objeto Dart a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'ubicacion': ubicacion,
      'precio': precio,
      'disponible': disponible,
      'descripcion': descripcion,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
