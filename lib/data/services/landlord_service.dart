import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unistay/domain/models/accommodation_model.dart';

class LandlordService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Obtiene el ID del usuario autenticado desde Supabase.
  String? getAuthenticatedUserId() {
    return _supabase.auth.currentUser?.id;
  }

  /// Registra un nuevo alojamiento en la base de datos.

  Future<bool> createAccommodation({
    required String direccion,
    required List<String> fotos,
    required List<String> ventajas,
    required int price,
    required String descripcion,
    required int numeroHabitaciones,
    required bool disponible,
    required String categoria,
  }) async {
    try {
      final userId = getAuthenticatedUserId();
      if (userId == null) {
        throw Exception("Usuario no autenticado.");
      }

      final accommodation = {
        'direccion': direccion,
        'fotos': fotos,
        'ventajas': ventajas,
        'price': price,
        'descripcion': descripcion,
        'numeroHabitaciones': numeroHabitaciones,
        'disponible': disponible,
        'categoria': categoria,
        'idPropietario': userId,
      };

      final response =
          await _supabase.from('accommodations').insert(accommodation).select();

      if (response.isEmpty) {
        throw Exception("No se pudo registrar el alojamiento.");
      }

      return true;
    } on PostgrestException catch (e) {
      throw Exception("Error en la base de datos: ${e.message}");
    } catch (e) {
      throw Exception("Error inesperado al registrar alojamiento: $e");
    }
  }

  /// Obtiene un alojamiento específico si pertenece al usuario autenticado.
  Future<AccommodationModel?> getAccommodationById(String idAlojamiento) async {
    try {
      final userId = getAuthenticatedUserId();
      if (userId == null) return null;

      final response = await _supabase
          .from('accommodations')
          .select()
          .eq('idAlojamiento', idAlojamiento)
          .eq('idPropietario', userId)
          .single();

      return AccommodationModel.fromMap(response);
    } catch (error) {
      throw Exception('Error al obtener el alojamiento: $error');
    }
  }

  /// Obtiene los alojamientos del usuario autenticado.
  Future<List<AccommodationModel>> getLandlordAccommodations(
      {String? query}) async {
    try {
      final userId = getAuthenticatedUserId();
      if (userId == null) return [];

      var queryBuilder =
          _supabase.from('accommodations').select().eq('idPropietario', userId);

      if (query != null && query.isNotEmpty) {
        queryBuilder = queryBuilder
            .or('direccion.ilike.%$query%, categoria.ilike.%$query%');
      }

      final data = await queryBuilder;
      return data.map((e) => AccommodationModel.fromMap(e)).toList();
    } catch (error) {
      throw Exception('Error al obtener alojamientos: $error');
    }
  }

  /// Actualiza los datos de un alojamiento si pertenece al usuario autenticado.
  Future<bool> updateAccommodation(
      String idAlojamiento, Map<String, dynamic> updates) async {
    try {
      final userId = getAuthenticatedUserId();
      if (userId == null) return false;

      await _supabase
          .from('accommodations')
          .update(updates)
          .eq('idAlojamiento', idAlojamiento)
          .eq('idPropietario', userId);

      return true;
    } catch (error) {
      throw Exception('Error al actualizar alojamiento: $error');
    }
  }

  /// Elimina un alojamiento si pertenece al usuario autenticado.
  Future<bool> deleteAccommodation(String idAlojamiento) async {
    final response = await Supabase.instance.client
        .from('accommodations')
        .delete()
        .match({'idAlojamiento': idAlojamiento});

    if (response == null) {
      return true; //
    }

    return false;
  }
}
