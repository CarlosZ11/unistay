import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unistay/data/services/locationAddress_service.dart';
import 'package:unistay/domain/models/accommodation_model.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';

class OwnerService {
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

  String completarDireccion(String direccion) {
    if (!direccion.toLowerCase().contains('valledupar')) {
      direccion += ', Valledupar';
    }
    if (!direccion.toLowerCase().contains('cesar')) {
      direccion += ', Cesar';
    }
    if (!direccion.toLowerCase().contains('colombia')) {
      direccion += ', Colombia';
    }
    return direccion;
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

      // Completar dirección con ciudad y departamento
      final direccionCompleta = completarDireccion(direccion);

      // Obtener coordenadas desde la dirección completa
      final coordinates = await getCoordinatesFromGoogleMaps(direccionCompleta);

      if (coordinates['latitude'] == null || coordinates['longitude'] == null) {
        throw Exception(
            "No se pudieron obtener las coordenadas para la dirección.");
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
        'latitud': coordinates['latitude'],
        'longitud': coordinates['longitude'],
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

  // Método para eliminar imagen
  Future<void> deleteImage(String imageUrl) async {
    try {
      final userId = getAuthenticatedUserId();
      if (userId == null) {
        throw Exception("Usuario no autenticado.");
      }

      // Extraemos el nombre del archivo desde la URL (asumiendo que la imagen está en 'fotos/$userId')
      final fileName = imageUrl.split('/').last;

      // Intentamos eliminar la imagen del almacenamiento
      final response = await _supabase.storage
          .from('alojamientos') // El nombre del bucket
          .remove([
        'fotos/$userId/$fileName'
      ]); // La ruta completa al archivo a eliminar

      if (response.error != null) {
        throw Exception(
            "Error al eliminar la imagen: ${response.error!.message}");
      }

      print("Imagen eliminada exitosamente");
    } catch (e) {
      print("Error al eliminar la imagen: $e"); // Para depuración
      throw Exception("No se pudo eliminar la imagen: $e");
    }
  }

  Future<bool> updateAccommodation(
      String idAlojamiento, Map<String, dynamic> updates) async {
    try {
      final userId = getAuthenticatedUserId();
      if (userId == null) return false;

      // Verificar si la dirección ha cambiado
      if (updates.containsKey('direccion')) {
        final direccionCompleta = completarDireccion(updates['direccion']);
        final coordinates =
            await getCoordinatesFromGoogleMaps(direccionCompleta);
        updates['latitud'] = coordinates['latitude'];
        updates['longitud'] = coordinates['longitude'];
      }

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

  /// Obtiene alojamientos con información del propietario (nombre, email).
  Future<List<Map<String, dynamic>>> getAccommodationsWithOwnerInfo() async {
    try {
      final response = await _supabase
          .from('accommodations')
          .select('*, users(nombre, email)');

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Error al obtener alojamientos con propietario: $e');
    }
  }
}

extension on List<FileObject> {
  get error => null;
}

extension on String {
  get error => null;
}
