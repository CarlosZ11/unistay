import 'package:flutter/material.dart' show Center, CircularProgressIndicator;
import 'package:get/get.dart';
import 'package:unistay/data/services/landlord_service.dart';
import 'package:unistay/domain/models/accommodation_model.dart';

class LandlordController extends GetxController {
  final LandlordService _landlordService = LandlordService();
  RxList<AccommodationModel> accommodations = <AccommodationModel>[].obs;

  @override
  void onInit() {
    fetchAccommodations();
    super.onInit();
  }

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
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

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

      Get.back(); // Cierra el diálogo de carga

      if (success) {
        Get.snackbar("Éxito", "Alojamiento registrado correctamente.");
        await fetchAccommodations();
      }
      return success;
    } catch (e) {
      Get.back(); // Cierra el diálogo si hay un error
      Get.snackbar("Error", "No se pudo registrar el alojamiento: $e");
      return false;
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

  /// Obtiene la lista de alojamientos del usuario autenticado.
  Future<void> fetchAccommodations() async {
    try {
      final results = await _landlordService.getLandlordAccommodations();
      accommodations.assignAll(results);
    } catch (error) {
      Get.snackbar("Error", "No se pudieron obtener los alojamientos.");
    }
  }

  /// Actualiza un alojamiento si pertenece al usuario autenticado
  Future<bool> updateAccommodation(
      String idAlojamiento, Map<String, dynamic> updates) async {
    if (idAlojamiento.trim().isEmpty) {
      Get.snackbar("Error", "ID de alojamiento inválido.");
      return false;
    }
    if (updates.isEmpty) {
      Get.snackbar("Error", "No se proporcionaron datos para actualizar.");
      return false;
    }
    final success =
        await _landlordService.updateAccommodation(idAlojamiento, updates);
    if (success) {
      Get.snackbar("Éxito", "Alojamiento actualizado correctamente.");
    }
    return success;
  }

  /// Elimina un alojamiento y actualiza la lista.
  Future<void> deleteAccommodation(String idAlojamiento) async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      bool success = await _landlordService.deleteAccommodation(idAlojamiento);
      Get.back();

      if (success) {
        accommodations
            .removeWhere((item) => item.idAlojamiento == idAlojamiento);
        accommodations.refresh();
        Get.snackbar("Éxito", "Alojamiento eliminado correctamente.");
      } else {
        Get.snackbar("Error", "No se pudo eliminar el alojamiento.");
      }
    } catch (e) {
      Get.back();
      Get.snackbar("Error", "Hubo un problema al eliminar el alojamiento: $e");
    }
  }
}
