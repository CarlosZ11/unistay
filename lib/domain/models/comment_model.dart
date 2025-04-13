class CommentModel {
  final String idComentario;
  final String idUsuario; // Este campo es la clave foránea en `comments`
  final String idAlojamiento;
  final String descripcion;
  final int puntuacion;
  final DateTime fechaCreacion;
  final String nombreUsuario;

  CommentModel({
    required this.idComentario,
    required this.idUsuario,
    required this.idAlojamiento,
    required this.descripcion,
    required this.puntuacion,
    required this.fechaCreacion,
    required this.nombreUsuario,
  });

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      idComentario: map['idComentario'] ?? '',
      idUsuario: map['idusuario'] ??
          '', // Asegúrate de que este es el campo correcto en la tabla `comments`
      idAlojamiento:
          map['idalojamiento'] ?? '', // Campo correcto para el alojamiento
      descripcion: map['descripcion'] ?? '',
      puntuacion: map['puntuacion'] ?? 0,
      fechaCreacion: DateTime.parse(map['fecha_creacion'] ?? ''),
      nombreUsuario:
          "${map['users']?['name'] ?? ''} ${map['users']?['lastname'] ?? ''}", // Relación con la tabla `users`
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idusuario':
          idUsuario, // Este es el idUsuario, clave foránea en `comments`
      'idalojamiento':
          idAlojamiento, // Asegúrate de que este sea el campo correcto
      'descripcion': descripcion,
      'puntuacion': puntuacion,
      'fecha_creacion': fechaCreacion.toIso8601String(),
    };
  }
}
