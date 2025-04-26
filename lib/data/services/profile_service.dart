import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unistay/domain/models/accommodation_model.dart';
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

  Future<bool> setFavorite(String userId, String accommodationId) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      print(userId);
      print(accommodationId);
      if (userId == null) throw Exception("Usuario no autenticado");

      await _supabase.from('favorites').insert({
        'idusuario': userId,
        'idalojamiento': accommodationId,
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> removeFavorite(String userId, String accommodationId) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception("Usuario no autenticado");

      await _supabase
          .from('favorites')
          .delete()
          .eq('idusuario', userId)
          .eq('idalojamiento', accommodationId);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<List<AccommodationModel>> getFavorites(String userId) async {
    try {
      final response = await _supabase
          .from('favorites')
          .select('accommodation:idalojamiento ( * )') // alias y join
          .eq('idusuario', userId);

      final data = response as List;

      return data
          .map((item) => AccommodationModel.fromMap(item['accommodation']))
          .toList();
    } catch (e) {
      print("Error al obtener favoritos: $e");
      return [];
    }
  }
}
