import 'package:get/get.dart';
import 'package:unistay/data/services/tenant_service.dart';
import 'package:unistay/domain/models/accommodation_model.dart';

class TenantController extends GetxController {
  final selectedAccommodation = Rxn<AccommodationModel>();

  final TenantService tenantService = TenantService();
  // Lista para almacenar los alojamientos (reactiva)
  var accommodations = <AccommodationModel>[].obs;

  // Estado de carga (reactivo)
  var isLoading = false.obs;

  void setSelectAccommodation(AccommodationModel accommodation) {
    selectedAccommodation.value = accommodation;
  }

  void updateAccommodationInList(AccommodationModel updatedAccommodation) {
    final index = accommodations.indexWhere(
        (a) => a.idAlojamiento == updatedAccommodation.idAlojamiento);
    if (index != -1) {
      accommodations[index] = updatedAccommodation;
      accommodations.refresh(); // Notifica a la UI que la lista cambió
    }
  }

  Future<void> getAccommodationById(String idAccommodation) async {
    try {
      isLoading.value = true;
      AccommodationModel accommodation =
          await tenantService.getAccommodationById(idAccommodation);
      setSelectAccommodation(accommodation);
      updateAccommodationInList(accommodation);
    } catch (e) {
      print("Error fetching comments: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Método para obtener todos los alojamientos
  Future<void> fetchAccommodations() async {
    isLoading.value = true;

    try {
      accommodations.value = await tenantService.fetchAllAccommodations();
    } catch (e) {
      accommodations.clear(); // Limpiar lista si hay error
      print("Error fetching accommodations: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Método para obtener alojamientos filtrados por búsqueda o categoría
  Future<void> fetchFilteredAccommodations(
      {String? query, String? category}) async {
    isLoading.value = true;

    try {
      accommodations.value = await tenantService.fetchFilteredAccommodations(
          query: query, category: category);
    } catch (e) {
      accommodations.clear(); // Limpiar lista si hay error
      print("Error fetching filtered accommodations: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Método para realizar una búsqueda de alojamientos
  Future<void> searchAccommodations(String query) async {
    await fetchFilteredAccommodations(query: query);
  }

  /// Método para filtrar por categoría
  Future<void> filterByCategory(String category) async {
    await fetchFilteredAccommodations(category: category);
  }

  /// Método para buscar alojamientos por categoría
  Future<void> fetchAccommodationsByCategory(String category) async {
    isLoading.value = true;

    try {
      accommodations.value =
          await tenantService.fetchAccommodationsByCategory(category);
    } catch (e) {
      accommodations.clear(); // Limpiar lista si hay error
      print("Error fetching accommodations by category: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Método para buscar alojamientos por texto
  Future<void> searchAccommodationByText(String query) async {
    isLoading.value = true;

    try {
      accommodations.value = await tenantService.searchAccommodations(query);
    } catch (e) {
      accommodations.clear(); // Limpiar lista si hay error
      print("Error searching accommodations: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
