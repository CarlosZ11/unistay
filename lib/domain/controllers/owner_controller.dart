import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import 'package:unistay/data/services/owner_service.dart';
import 'package:unistay/domain/models/accommodation_model.dart';

class OwnerController extends GetxController {
  final OwnerService _OwnerService = OwnerService();
  var accommodations = <AccommodationModel>[].obs;
  var isLoading = false.obs;

  // Controladores de texto
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController direccionController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  dynamic selectedCategory;
  bool disponible = false;
  List<String> selectedVentajas = [];
  List<dynamic> _selectedImages = [];

  @override
  void onInit() {
    super.onInit();
    // Cargar todos los alojamientos del propietario al inicio
    loadLandlordAccommodations();
  }

  /// Cargar todos los alojamientos del propietario sin paginación.
  Future<void> loadLandlordAccommodations() async {
    try {
      accommodations.value = await _OwnerService.getLandlordAccommodations();
    } catch (e) {
      Get.snackbar("Error", "Hubo un problema al cargar los alojamientos: $e");
    }
  }

  void resetAddAccommodationForm() {
    nombreController.clear();
    direccionController.clear();
    descripcionController.clear();
    priceController.clear();
    selectedCategory = null;
    disponible = false;
    selectedVentajas.clear();
    _selectedImages.clear();
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
          final imageUrl = await _OwnerService.uploadImage(imageFile);
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
      bool success = await _OwnerService.createAccommodation(
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

  Future<void> updateAccommodationWithImage({
    required String idAlojamiento,
    required String nombre,
    required String direccion,
    required List<File> imageFiles,
    required List<String> imagenesAntiguas,
    required List<String> ventajas,
    required int price,
    required String descripcion,
    required int numeroHabitaciones,
    required bool disponible,
    required String categoria,
  }) async {
    try {
      isLoading.value = true;
      List<String> imageUrls = [];

      // Mantener las imágenes antiguas si las hay
      imageUrls.addAll(imagenesAntiguas);

      // Subir nuevas imágenes solo si se proporcionan
      if (imageFiles.isNotEmpty) {
        for (var imageFile in imageFiles) {
          try {
            final imageUrl = await _OwnerService.uploadImage(imageFile);
            imageUrls.add(imageUrl); // Agregar solo la nueva imagen
          } catch (e) {
            Get.snackbar("Advertencia", "Una imagen no pudo subirse: $e");
          }
        }
      }

      // Crear mapa de campos a actualizar
      Map<String, dynamic> updates = {
        'nombre': nombre,
        'direccion': direccion,
        'ventajas': ventajas,
        'price': price,
        'descripcion': descripcion,
        'numeroHabitaciones': numeroHabitaciones,
        'disponible': disponible,
        'categoria': categoria,
      };

      // Solo agregamos fotos si hay nuevas
      if (imageUrls.isNotEmpty) {
        updates['fotos'] = imageUrls;
      }

      bool success =
          await _OwnerService.updateAccommodation(idAlojamiento, updates);

      if (success) {
        await loadLandlordAccommodations();
        Get.snackbar("Éxito", "Alojamiento actualizado exitosamente.");
      }
    } catch (e) {
      Get.snackbar("Error", "No se pudo actualizar el alojamiento: $e");
    } finally {
      isLoading.value = false;
    }
  }

  //Elimina un alojamiento.
  Future<void> deleteAccommodation(String idAlojamiento) async {
    try {
      bool success = await _OwnerService.deleteAccommodation(idAlojamiento);
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

  String normalizePhoneNumber(String number) {
    number = number.replaceAll(
        RegExp(r'\D'), ''); // Elimina todo lo que no sea dígito

    if (number.startsWith('57')) {
      return number;
    } else if (number.startsWith('0')) {
      number = number.substring(1);
    }

    return '+57$number';
  }

  Future<void> openChat({
    required BuildContext context,
    required String phoneNumber,
    required String message,
  }) async {
    final normalizedNumber = normalizePhoneNumber(phoneNumber);

    // Solo dígitos
    final encodedMessage = Uri.encodeComponent(message);

    final whatsappUrl = 'https://wa.me/$normalizedNumber?text=$encodedMessage';
    final uri = Uri.parse(whatsappUrl);

    if (await canLaunchUrl(uri)) {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'No se pudo abrir WhatsApp. Asegúrate de que esté instalado.'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo lanzar la URL.'),
        ),
      );
    }
  }

  /// Método que obtiene alojamientos con la información del propietario
  Future<List<Map<String, dynamic>>> getAccommodationsWithOwnerInfo() async {
    try {
      var accommodations = await _OwnerService.getAccommodationsWithOwnerInfo();

      if (accommodations.isEmpty) {
        throw Exception('No hay alojamientos disponibles.');
      }

      // Si todo está bien, retorna los alojamientos
      return accommodations;
    } catch (e) {
      // Si ocurre un error, lanza una excepción para que la vista la maneje
      throw Exception('Error al obtener alojamientos: $e');
    }
  }
}
