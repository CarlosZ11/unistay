import 'package:get/get.dart';
import 'package:unistay/domain/controllers/tenant_controller.dart';
import 'package:unistay/domain/models/accommodation_model.dart';
import 'package:unistay/domain/models/user_model.dart';
import 'package:unistay/data/services/profile_service.dart';

class ProfileController extends GetxController {
  final ProfileService _profileService = ProfileService();
  final TenantController _tenantcontroller = Get.put(TenantController());
  var user = Rx<UserModel?>(null);
  var favorites = <AccommodationModel>[].obs;
  var isLoading = false.obs;

  /// 🔹 Obtener los datos del usuario autenticado
  Future<void> loadUserProfile() async {
    isLoading.value = true;
    user.value = await _profileService.getUserData();
    isLoading.value = false;
  }

  /// 🔹 Validaciones antes de actualizar el perfil
  Future<void> updateProfile({
    required String name,
    required String lastname,
    required String phone,
    required String identification,
  }) async {
    if (!_validateInputs(name, lastname, phone, identification)) return;

    isLoading.value = true;

    final updatedUser = user.value!.copyWith(
      name: _normalizeText(name),
      lastname: _normalizeText(lastname),
      phone: phone,
      identification: identification,
    );

    final success = await _profileService.updateUserData(updatedUser);
    if (success) {
      user.value = updatedUser;
      Get.snackbar('Éxito', 'Perfil actualizado correctamente');
    } else {
      Get.snackbar('Error', 'No se pudo actualizar el perfil');
    }

    isLoading.value = false;
  }

  Future<void> setFavorite(String userID, String accommdationID) async {
    isLoading.value = true;
    final success = await _profileService.setFavorite(userID, accommdationID);
    if (success) {
      await getFavorites(userID);
    } else {
      Get.snackbar('Error', 'No se pudo agregar el favorito');
    }
    isLoading.value = false;
  }

  /// 🔹 Eliminar un favorito
  Future<void> removeFavorite(String userID, String accommdationID) async {
    isLoading.value = true;
    final success =
        await _profileService.removeFavorite(userID, accommdationID);
    if (success) {
      Get.snackbar('Éxito', 'Favorito eliminado correctamente');
      await getFavorites(userID);
      final index = _tenantcontroller.accommodations.indexWhere(
        (a) => a.idAlojamiento == accommdationID,
      );
      if (index != -1) {
        _tenantcontroller.accommodations[index].isFavorite.value = false;
      }
      favorites.refresh();
    } else {
      Get.snackbar('Error', 'No se pudo eliminar el favorito');
    }
    isLoading.value = false;
  }

  // / 🔹 Obtener los favoritos del usuario
  Future<void> getFavorites(String userID) async {
    isLoading.value = true;
    favorites.value = await _profileService.getFavorites(userID);
    isLoading.value = false;
  }

  /// 🔹 Validaciones de los datos del perfil
  bool _validateInputs(
      String name, String lastname, String phone, String identification) {
    if (name.isEmpty ||
        lastname.isEmpty ||
        phone.isEmpty ||
        identification.isEmpty) {
      Get.snackbar('Error', 'Todos los campos son obligatorios');
      return false;
    }
    if (!RegExp(r"^[a-zA-ZÀ-ÿ\s]{2,50}$").hasMatch(name)) {
      Get.snackbar('Error', 'Nombre inválido');
      return false;
    }
    if (!RegExp(r"^\d{10}$").hasMatch(phone)) {
      Get.snackbar('Error', 'El teléfono debe tener 10 dígitos');
      return false;
    }
    if (!RegExp(r"^\d{8,10}$").hasMatch(identification)) {
      Get.snackbar('Error', 'Identificación inválida');
      return false;
    }
    return true;
  }

  /// 🔹 Normalización de texto (elimina espacios innecesarios)
  String _normalizeText(String text) {
    return text.trim().replaceAll(RegExp(r'\s+'), ' ');
  }
}
