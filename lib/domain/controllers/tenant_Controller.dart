import 'package:get/get.dart';
import 'package:unistay/data/services/tenant_service.dart';
import 'package:unistay/domain/models/accommodation_model.dart';

class TenantController extends GetxController {
  final TenantService _tenantService = TenantService();
  var accommodations = <AccommodationModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getAccommodations(); 
  }

  /// Obtiene todos los alojamientos desde la base de datos
  Future<void> getAccommodations() async {
    try {
      isLoading.value = true;
      final data = await _tenantService.getAllAccommodations();
      accommodations.assignAll(data);
    } catch (e) {
      Get.snackbar("Error", "No se pudieron obtener los alojamientos: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Filtra alojamientos por dirección o categoría
  Future<void> filterAccommodations(String query) async {
    if (query.isEmpty) {
      getAccommodations(); // Si no hay búsqueda, cargar todos
      return;
    }
    try {
      isLoading.value = true;
      final data = await _tenantService.filterAccommodations(query);
      accommodations.assignAll(data);
    } catch (e) {
      Get.snackbar("Error", "No se pudieron filtrar los alojamientos: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
