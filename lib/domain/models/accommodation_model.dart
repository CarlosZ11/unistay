class AccommodationModel {
  final String idAlojamiento;
  final String nombre;
  final String direccion;
  final int price;
  final List<String> ventajas;
  final List<String> fotos;
  final String descripcion;
  final int numeroHabitaciones;
  final bool disponible;
  final String categoria;
  final String idPropietario;
  final double promedioPuntuacion; // 👈 NUEVO CAMPO
  final int cantidadComentarios; // 👈 NUEVO CAMPO

  AccommodationModel({
    required this.idAlojamiento,
    required this.nombre,
    required this.direccion,
    required this.price,
    required this.fotos,
    required this.ventajas,
    required this.descripcion,
    required this.numeroHabitaciones,
    required this.disponible,
    required this.categoria,
    required this.idPropietario,
    required this.promedioPuntuacion,
    required this.cantidadComentarios,
  });

  AccommodationModel copyWith({
    String? idAlojamiento,
    String? nombre,
    String? direccion,
    int? price,
    List<String>? fotos,
    List<String>? ventajas,
    String? descripcion,
    int? numeroHabitaciones,
    bool? disponible,
    String? categoria,
    String? idPropietario,
    double? promedioPuntuacion,
    int? cantidadComentarios, // 👈 También aquí
  }) {
    return AccommodationModel(
      idAlojamiento: idAlojamiento ?? this.idAlojamiento,
      nombre: nombre ?? this.nombre,
      direccion: direccion ?? this.direccion,
      price: price ?? this.price,
      fotos: fotos ?? this.fotos,
      ventajas: ventajas ?? this.ventajas,
      descripcion: descripcion ?? this.descripcion,
      numeroHabitaciones: numeroHabitaciones ?? this.numeroHabitaciones,
      disponible: disponible ?? this.disponible,
      categoria: categoria ?? this.categoria,
      idPropietario: idPropietario ?? this.idPropietario,
      promedioPuntuacion: promedioPuntuacion ?? this.promedioPuntuacion,
      cantidadComentarios:
          cantidadComentarios ?? this.cantidadComentarios, // 👈
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idAlojamiento': idAlojamiento,
      'nombre': nombre,
      'direccion': direccion,
      'fotos': fotos,
      'ventajas': ventajas,
      'price': price,
      'descripcion': descripcion,
      'numeroHabitaciones': numeroHabitaciones,
      'disponible': disponible,
      'categoria': categoria,
      'idPropietario': idPropietario,
      'promedio_puntuacion': promedioPuntuacion,
      'cantidad_comentarios': cantidadComentarios, // 👈
    };
  }

  factory AccommodationModel.fromMap(Map<String, dynamic> map) {
    return AccommodationModel(
      idAlojamiento: map['idAlojamiento'] ?? '',
      nombre: map['nombre'] ?? '',
      direccion: map['direccion'] ?? '',
      fotos: List<String>.from(map['fotos'] ?? []),
      ventajas: List<String>.from(map['ventajas'] ?? []),
      price: map['price'] ?? 0,
      descripcion: map['descripcion'] ?? '',
      numeroHabitaciones: map['numeroHabitaciones'] ?? 0,
      disponible: map['disponible'] ?? true,
      categoria: map['categoria'] ?? '',
      idPropietario: map['idPropietario'] ?? '',
      promedioPuntuacion: (map['promedio_puntuacion'] as num?)?.toDouble() ??
          0.0, // 👈 transformación segura
      cantidadComentarios:
          map['cantidad_comentarios'] ?? 0, // 👈 transformación segura
    );
  }
}
