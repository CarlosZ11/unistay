import 'package:get/get.dart';
import 'package:unistay/data/services/auth_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  var isLoading = false.obs;

  // Método para registrarse
  Future<void> registerUser(String email, String password) async {
    isLoading.value = true;
    final response = await _authService.signUp(email, password);

    if (response != null && response.user != null) {
      Get.snackbar('Registro exitoso', 'Bienvenido a UniStay');
      Get.offNamed('/HomePage'); // Redirigir al login
    } else {
      Get.snackbar('Error', 'No se pudo registrar el usuario');
    }
    isLoading.value = false;
  }

  // Método para iniciar sesión
  Future<void> loginUser(String email, String password) async {
    isLoading.value = true;
    final response = await _authService.signIn(email, password);

    if (response != null && response.user != null) {
      Get.snackbar('Inicio de sesión', 'Bienvenido de nuevo');
      Get.offNamed('/HomePage'); // Redirigir a la pantalla principal
    } else {
      Get.snackbar('Error', 'Credenciales incorrectas');
    }
    isLoading.value = false;
  }
}
