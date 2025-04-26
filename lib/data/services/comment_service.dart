// lib/data/services/comment_service.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unistay/domain/models/comment_model.dart';

class CommentService {
  final supabase = Supabase.instance.client;

  /// 🔹 Agrega un nuevo comentario
  Future<void> addComment(CommentModel comment) async {
    final response =
        await supabase.from('comments').insert(comment.toMap()).select();

    if (response.isEmpty) {
      throw Exception('Error al insertar el comentario');
    }
  }

  /// 🔹 Obtiene comentarios por alojamiento con datos del usuario
  Future<List<CommentModel>> getCommentsByAlojamiento(
      String idAlojamiento) async {
    final response = await supabase
        .from('comments')
        .select(
            '*, users(name, lastname)') // Asegúrate de que la relación de usuarios esté bien definida
        .eq("idalojamiento",
            idAlojamiento) // ✅ Esto sí coincide con la columna real

        .order('fecha_creacion', ascending: false);

    return (response as List).map((e) => CommentModel.fromMap(e)).toList();
  }
}
