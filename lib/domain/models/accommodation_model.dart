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
  });

  /// Método copyWith para actualizar campos específicos sin cambiar los demás
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
    );
  }

  /// Método para convertir el modelo a un mapa para Supabase
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
    };
  }

  /// Método para crear un modelo desde un mapa (respuesta de Supabase)
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
    );
  }
}
