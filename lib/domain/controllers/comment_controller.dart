import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unistay/data/services/comment_service.dart';
import 'package:unistay/domain/models/comment_model.dart';
import 'package:unistay/domain/models/user_model.dart';

class CommentController extends GetxController {
  final CommentService _service = CommentService();

  var comments = <CommentModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  final currentUser = Rxn<UserModel>();

  /// 🔹 Carga los datos del usuario autenticado
  Future<void> loadCurrentUser() async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) {
        errorMessage.value = 'Usuario no autenticado';
        return;
      }

      final response = await Supabase.instance.client
          .from('users')
          .select()
          .eq('id', userId)
          .single();

      currentUser.value = UserModel.fromMap(response);
    } catch (e) {
      errorMessage.value = 'Error cargando usuario: $e';
    }
  }

  /// 🔹 Carga los comentarios de un alojamiento
  Future<void> loadComments(String idAlojamiento) async {
    try {
      isLoading.value = true;
      final data = await _service.getCommentsByAlojamiento(idAlojamiento);
      comments.assignAll(data);
    } catch (e) {
      errorMessage.value = 'Error cargando comentarios: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// 🔹 Agrega un nuevo comentario
  Future<void> addComment({
    required String idAlojamiento,
    required String descripcion,
    required int puntuacion,
  }) async {
    if (currentUser.value == null) {
      errorMessage.value = 'Usuario no autenticado';
      return;
    }

    final nuevoComentario = CommentModel(
      idComentario: '', // Será generado por Supabase
      idUsuario: currentUser.value!.id,
      idAlojamiento: idAlojamiento, // Usa "idalojamiento" correctamente
      descripcion: descripcion,
      puntuacion: puntuacion,
      fechaCreacion: DateTime.now(),
      nombreUsuario:
          "${currentUser.value!.name} ${currentUser.value!.lastname}",
    );

    try {
      await _service.addComment(nuevoComentario);
      await loadComments(idAlojamiento);
    } catch (e) {
      errorMessage.value = 'Error agregando comentario: $e';
      rethrow;
    }
  }
}
