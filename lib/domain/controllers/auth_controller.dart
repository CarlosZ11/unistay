import 'package:get/get.dart';
import 'package:unistay/data/services/auth_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  var isLoading = false.obs;

  bool isValidEmail(String email) {
    return RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
        .hasMatch(email);
  }

  bool isValidPassword(String password) {
    return password.length >= 6;
  }

  Future<void> registerUser(String email, String password) async {
    if (!isValidEmail(email)) {
      Get.snackbar('Error', 'Correo electrónico no válido');
      return;
    }
    if (!isValidPassword(password)) {
      Get.snackbar('Error', 'La contraseña debe tener al menos 6 caracteres');
      return;
    }

    isLoading.value = true;
    try {
      final response = await _authService.signUp(email, password);
      if (response != null && response.user != null) {
        Get.snackbar('Registro exitoso', 'Bienvenido a UniStay');
        Get.offNamed('/HomePage');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString().replaceAll('Exception: ', ''));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginUser(String email, String password) async {
    if (!isValidEmail(email)) {
      Get.snackbar('Error', 'Correo electrónico no válido');
      return;
    }
    if (!isValidPassword(password)) {
      Get.snackbar('Error', 'La contraseña debe tener al menos 6 caracteres');
      return;
    }

    isLoading.value = true;
    try {
      final response = await _authService.signIn(email, password);
      if (response != null && response.user != null) {
        Get.snackbar('Inicio de sesión', 'Bienvenido de nuevo');
        Get.offNamed('/HomePage');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString().replaceAll('Exception: ', ''));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> forgotPassword(String email) async {
    if (!isValidEmail(email)) {
      Get.snackbar('Error', 'Correo electrónico no válido');
      return;
    }

    isLoading.value = true;
    try {
      await _authService.resetPassword(email);
      Get.snackbar('Correo enviado', 'Revisa tu correo para restablecer tu contraseña.');
    } catch (e) {
      Get.snackbar('Error', e.toString().replaceAll('Exception: ', ''));
    } finally {
      isLoading.value = false;
    }
  }

}
