class AccommodationModel {
  final String idAlojamiento; // Ahora es la PRIMARY KEY
  final String direccion; // Ahora solo es UNIQUE
  final List<String> fotos;
  final List<String> ventajas;
  final int price;
  final String descripcion;
  final int numeroHabitaciones;
  final bool disponible;
  final String categoria;
  final String idPropietario;

  AccommodationModel({
    required this.idAlojamiento, // Ahora es la PRIMARY KEY
    required this.direccion, // Ahora solo es UNIQUE
    required this.fotos,
    required this.ventajas,
    required this.price,
    required this.descripcion,
    required this.numeroHabitaciones,
    required this.disponible,
    required this.categoria,
    required this.idPropietario,
  });
  // Convertir el modelo a un mapa para guardar en Supabase
  Map<String, dynamic> toMap() {
    return {
      'idAlojamiento': idAlojamiento,
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

  // Crear una instancia de UserModel a partir de un mapa
  factory AccommodationModel.fromMap(Map<String, dynamic> map) {
    return AccommodationModel(
      idAlojamiento: map['idAlojamiento'] ?? '',
      direccion: map['direccion'] ?? '', // Ahora solo es UNIQUE
      fotos: List<String>.from(map['fotos'] ?? []),
      ventajas: List<String>.from(map['ventajas'] ?? []),
      price: map['price'] ?? 0,
      descripcion: map['descripcion'] ?? '',
      numeroHabitaciones: map['numeroHabitaciones'] ?? 0,
      disponible: map['disponible'] ?? false,
      categoria: map['categoria'] ?? '',
      idPropietario: map['idPropietario'] ?? '', // Ahora es la PRIMARY KEY
    );
  }
}
