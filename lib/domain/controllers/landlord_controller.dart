import 'package:get/get.dart';
import 'package:unistay/data/services/landlord_service.dart';
import 'package:unistay/domain/models/accommodation_model.dart';


class LandlordController extends GetxController {
  final LandlordService _landlordService = LandlordService();

  /// URL de la imagen por defecto
  static const String defaultImageUrl =
      "https://th.bing.com/th/id/R.752a118fa0183c370fe39671b3b72219?rik=I307Oo5cKCRfzA&pid=ImgRaw&r=0";

  /// Registra un nuevo alojamiento en la base de datos
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
      // Si no hay imágenes, asignamos la imagen por defecto
      final List<String> finalFotos = fotos.isEmpty ? [defaultImageUrl] : fotos;

      final success = await _landlordService.createAccommodation(
        direccion: direccion,
        fotos: finalFotos,
        ventajas: ventajas,
        price: price,
        descripcion: descripcion,
        numeroHabitaciones: numeroHabitaciones,
        disponible: disponible,
        categoria: categoria,
      );

      if (success) {
        Get.snackbar("Éxito", "Alojamiento registrado correctamente.");
      }
      return success;
    } catch (e) {
      Get.snackbar("Error", "No se pudo registrar el alojamiento: $e");
      return false;
    }
  }

  /// Obtiene alojamientos con filtro opcional por dirección o categoría
  Future<List<AccommodationModel>> getLandlordAccommodations({String? query}) async {
    try {
      return await _landlordService.getLandlordAccommodations(query: query);
    } catch (error) {
      Get.snackbar("Error", "No se pudieron obtener los alojamientos.");
      return [];
    }
  }

  /// Obtiene un alojamiento específico por ID
  Future<AccommodationModel?> getAccommodationById(String idAlojamiento) async {
    if (idAlojamiento.trim().isEmpty) {
      Get.snackbar("Error", "ID de alojamiento inválido.");
      return null;
    }
    try {
      return await _landlordService.getAccommodationById(idAlojamiento);
    } catch (error) {
      Get.snackbar("Error", "No se pudo obtener el alojamiento.");
      return null;
    }
  }

  /// Actualiza un alojamiento si pertenece al usuario autenticado
  Future<bool> updateAccommodation(String idAlojamiento, Map<String, dynamic> updates) async {
    if (idAlojamiento.trim().isEmpty) {
      Get.snackbar("Error", "ID de alojamiento inválido.");
      return false;
    }
    if (updates.isEmpty) {
      Get.snackbar("Error", "No se proporcionaron datos para actualizar.");
      return false;
    }
    final success = await _landlordService.updateAccommodation(idAlojamiento, updates);
    if (success) {
      Get.snackbar("Éxito", "Alojamiento actualizado correctamente.");
    }
    return success;
  }

  /// Elimina un alojamiento si pertenece al usuario autenticado
  Future<bool> deleteAccommodation(String idAlojamiento) async {
    if (idAlojamiento.trim().isEmpty) {
      Get.snackbar("Error", "ID de alojamiento inválido.");
      return false;
    }
    final success = await _landlordService.deleteAccommodation(idAlojamiento);
    if (success) {
      Get.snackbar("Éxito", "Alojamiento eliminado correctamente.");
    }
    return success;
  }
}
