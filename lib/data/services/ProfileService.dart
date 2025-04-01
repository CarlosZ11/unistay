import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unistay/domain/models/user_model.dart';

class ProfileService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// 🔹 Obtiene los datos del usuario autenticado desde Supabase
  Future<UserModel?> getUserData() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception("Usuario no autenticado");

      final response =
          await _supabase.from('users').select().eq('id', userId).single();

      return UserModel.fromMap(response);
    } catch (e) {
      print("Error al obtener datos del usuario: $e");
      return null;
    }
  }

  /// 🔹 Actualiza los datos del usuario en Supabase
  Future<bool> updateUserData(UserModel user) async {
    try {
      await _supabase.from('users').update(user.toMap()).eq('id', user.id);
      return true;
    } catch (e) {
      print("Error al actualizar perfil: $e");
      return false;
    }
  }
}
