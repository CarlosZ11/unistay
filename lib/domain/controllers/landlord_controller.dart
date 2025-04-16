import 'dart:io';
import 'package:get/get.dart';
import 'package:unistay/data/services/landlord_service.dart';
import 'package:unistay/domain/models/accommodation_model.dart';

class LandlordController extends GetxController {
  final LandlordService _landlordService = LandlordService();
  var accommodations = <AccommodationModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Cargar todos los alojamientos del propietario al inicio
    loadLandlordAccommodations();
  }

  /// Cargar todos los alojamientos del propietario sin paginación.
  Future<void> loadLandlordAccommodations() async {
    try {
      accommodations.value = await _landlordService.getLandlordAccommodations();
    } catch (e) {
      Get.snackbar("Error", "Hubo un problema al cargar los alojamientos: $e");
    }
  }

  /// Crear un nuevo alojamiento, incluye la subida de imágenes.
  Future<void> createAccommodationWithImage({
    required String nombre,
    required String direccion,
    required List<File> imageFiles,
    required List<String> ventajas,
    required int price,
    required String descripcion,
    required int numeroHabitaciones,
    required bool disponible,
    required String categoria,
  }) async {
    try {
      List<String> imageUrls = [];

      //Subir las imágenes
      for (var imageFile in imageFiles) {
        try {
          final imageUrl = await _landlordService.uploadImage(imageFile);
          imageUrls.add(imageUrl);
        } catch (e) {
          Get.snackbar("Advertencia", "Una imagen no pudo subirse: $e");
        }
      }

      //Verificar si alguna URL de imagen es inválida
      if (imageUrls.isEmpty || imageUrls.any((url) => url.isEmpty)) {
        Get.snackbar("Error",
            "No se pudo generar ninguna URL válida para las imágenes.");
        return; // Detenemos el proceso si no hay imágenes válidas
      }

      //Crear el alojamiento con las imágenes subidas
      bool success = await _landlordService.createAccommodation(
        nombre: nombre,
        direccion: direccion,
        fotos: imageUrls,
        ventajas: ventajas,
        price: price,
        descripcion: descripcion,
        numeroHabitaciones: numeroHabitaciones,
        disponible: disponible,
        categoria: categoria,
      );

      if (success) {
        loadLandlordAccommodations();
        Get.snackbar("Éxito", "Alojamiento creado exitosamente.");
      }
    } catch (e) {
      Get.snackbar("Error", "Hubo un problema al crear el alojamiento: $e");
    }
  }

  //Actualiza los datos de un alojamiento.
  Future<void> updateAccommodation(
      String idAlojamiento, Map<String, dynamic> updates) async {
    try {
      bool success =
          await _landlordService.updateAccommodation(idAlojamiento, updates);
      if (success) {
        //Refrescar la lista de alojamientos después de actualizar
        loadLandlordAccommodations();
        Get.snackbar("Éxito", "Alojamiento actualizado exitosamente.");
      }
    } catch (e) {
      Get.snackbar(
          "Error", "Hubo un problema al actualizar el alojamiento: $e");
    }
  }

  //Elimina un alojamiento.
  Future<void> deleteAccommodation(String idAlojamiento) async {
    try {
      bool success = await _landlordService.deleteAccommodation(idAlojamiento);
      if (success) {
        await loadLandlordAccommodations();
        accommodations.refresh();
        Get.snackbar("Éxito", "Alojamiento eliminado exitosamente.");
      } else {
        Get.snackbar("Error", "No se pudo eliminar el alojamiento.");
      }
    } catch (e) {
      Get.snackbar("Error", "Hubo un problema al eliminar el alojamiento: $e");
    }
  }
}
