import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unistay/domain/models/accommodation_model.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';

class LandlordService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Obtiene el ID del usuario autenticado desde Supabase.
  String? getAuthenticatedUserId() {
    return _supabase.auth.currentUser?.id;
  }

  /// Sube una imagen a Supabase Storage y retorna la URL pública.
  Future<String> uploadImage(File imageFile) async {
    try {
      final userId = getAuthenticatedUserId();
      if (userId == null) throw Exception("User not authenticated");

      final fileExt = imageFile.path.split('.').last;
      final String imageName = '${const Uuid().v4()}.$fileExt';

      print("Subiendo la imagen: $imageName");

      final storageResponse = await _supabase.storage
          .from('alojamientos')
          .upload('fotos/$userId/$imageName', imageFile);

      if (storageResponse.error != null) {
        throw Exception(
            "Error al subir la imagen: ${storageResponse.error!.message}");
      }

      print("Imagen subida con éxito, generando URL...");

      final publicUrl = _supabase.storage
          .from('alojamientos')
          .getPublicUrl('fotos/$userId/$imageName');

      return publicUrl;
    } catch (e) {
      print("Error al subir la imagen: $e"); // Para depuración
      throw Exception("Failed to upload image: $e");
    }
  }

  /// Registra un nuevo alojamiento en la base de datos.
  Future<bool> createAccommodation({
    required String nombre,
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
        'nombre': nombre,
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

  /// Obtiene todos los alojamientos del propietario (sin paginación).
  Future<List<AccommodationModel>> getLandlordAccommodations() async {
    try {
      final userId = getAuthenticatedUserId();
      if (userId == null) return [];

      final response = await _supabase
          .from('accommodations')
          .select()
          .eq('idPropietario', userId);

      return response.map((e) => AccommodationModel.fromMap(e)).toList();
    } catch (error) {
      throw Exception('Error al obtener alojamientos del propietario: $error');
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
    try {
      final userId = getAuthenticatedUserId();
      if (userId == null) return false;

      await _supabase
          .from('accommodations')
          .delete()
          .eq('idAlojamiento', idAlojamiento)
          .eq('idPropietario', userId);

      return true;
    } catch (error) {
      throw Exception('Error al eliminar alojamiento: $error');
    }
  }
}

extension on String {
  get error => null;
}
