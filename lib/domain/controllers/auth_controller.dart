import 'package:get/get.dart';
import 'package:unistay/data/services/auth_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  var isLoading = false.obs;

  // Normaliza el texto eliminando espacios innecesarios
  String normalizeText(String text) {
    return text.trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  // Validar nombre y apellido (solo letras y espacios, mínimo 2 caracteres)
  bool isValidName(String name) {
    return RegExp(r"^[a-zA-ZÀ-ÿ\s]{2,50}$").hasMatch(name.trim());
  }

  // Validar email
  bool isValidEmail(String email) {
    return RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
        .hasMatch(email);
  }

  // Validar contraseña (mínimo 8 caracteres, al menos una mayúscula, una minúscula, un número y un carácter especial)
  bool isValidPassword(String password) {
    return RegExp(
            r'^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[!@#\$%\^&\*\-_]).{8,}$')
        .hasMatch(password);
  }

  // Validar teléfono (exactamente 10 dígitos numéricos)
  bool isValidPhone(String phone) {
    return RegExp(r"^\d{10}$").hasMatch(phone);
  }

  // Validar cédula (8-10 dígitos numéricos)
  bool isValidIdentification(String identification) {
    return RegExp(r"^\d{8,10}$").hasMatch(identification);
  }

  // Registro de usuario
  Future<void> registerUser({
    required String name,
    required String lastname,
    required String email,
    required String password,
    required String phone,
    required String identification, // Clave primaria en Supabase
    required String role,
  }) async {
    // Normalización de datos
    name = normalizeText(name);
    lastname = normalizeText(lastname);
    email = email.trim().toLowerCase();

    // Validaciones

    if (name.isEmpty ||
        lastname.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        phone.isEmpty ||
        identification.isEmpty ||
        role.isEmpty) {
      Get.snackbar('Error', 'Todos los campos son obligatorios');
      return;
    }
    if (!isValidName(name) || !isValidName(lastname)) {
      Get.snackbar('Error',
          'Nombre y apellido deben ser válidos (solo letras y espacios)');
      return;
    }
    if (!isValidEmail(email)) {
      Get.snackbar('Error', 'Correo electrónico no válido');
      return;
    }
    if (!isValidPassword(password)) {
      Get.snackbar('Error',
          'La contraseña debe tener al menos 8 caracteres, una mayúscula, una minúscula, un número y un carácter especial.');
      return;
    }
    if (!isValidPhone(phone)) {
      Get.snackbar('Error',
          'El teléfono debe contener exactamente 10 dígitos numéricos');
      return;
    }
    if (!isValidIdentification(identification)) {
      Get.snackbar(
          'Error', 'La cédula debe tener entre 8 y 10 dígitos numéricos');
      return;
    }
    if (role.isEmpty) {
      Get.snackbar('Error', 'Debe seleccionar un rol');
      return;
    }

    isLoading.value = true;
    try {
      final response = await _authService.signUp(
        name,
        lastname,
        email,
        password,
        phone,
        identification,
        role,
      );

      if (response != null && response.user != null) {
        Get.snackbar('Registro exitoso', 'Bienvenido a UniStay');
        Get.offNamed('/HomePage');
      }
    } catch (e) {
      Get.snackbar('Error',
          'No se pudo registrar: ${e.toString().replaceAll('Exception: ', '')}');
    } finally {
      isLoading.value = false;
    }
  }

  // Inicio de sesión
  Future<void> loginUser(String email, String password) async {
    email = email.trim().toLowerCase();

    if (!isValidEmail(email)) {
      Get.snackbar('Error', 'Correo electrónico no válido');
      return;
    }
    if (password.isEmpty) {
      Get.snackbar('Error', 'Debe ingresar una contraseña');
      return;
    }

    isLoading.value = true;
    try {
      final response = await _authService.signIn(email, password);
      if (response != null && response.user != null) {
        Get.snackbar('Inicio de sesión', 'Bienvenido de nuevo');
        if (response.user!.role == 'Propietario') {
          Get.offNamed('/LandlordPage');
        } else if (response.user!.role == 'Inquilino') {
          Get.offNamed('/HomePage');
        } else {
          Get.snackbar('Error', 'Rol no reconocido');
        }
      }
    } catch (e) {
      Get.snackbar('Error',
          'Error al iniciar sesión: ${e.toString().replaceAll('Exception: ', '')}');
    } finally {
      isLoading.value = false;
    }
  }



  // Cerrar sesión
  Future<void> logoutUser() async {
    isLoading.value = true;
    try {
      await _authService.signOut();
      Get.offAllNamed(
          '/SignInPage'); // Redirigir al login después de cerrar sesión
    } catch (e) {
      Get.snackbar('Error', 'No se pudo cerrar sesión.');
    } finally {
      isLoading.value = false;
    }
  }

  // Restablecer contraseña
  Future<void> forgotPassword(String email) async {
    email = email.trim().toLowerCase();

    if (!isValidEmail(email)) {
      Get.snackbar('Error', 'Correo electrónico no válido');
      return;
    }

    isLoading.value = true;
    try {
      await _authService.resetPassword(email);
      Get.snackbar(
          'Correo enviado', 'Revisa tu correo para restablecer tu contraseña.');
    } catch (e) {
      Get.snackbar('Error',
          'No se pudo enviar el correo: ${e.toString().replaceAll('Exception: ', '')}');
    } finally {
      isLoading.value = false;
    }
  }

  // Actualización de contraseña
  Future<void> updatePassword(
      String newPassword, String confirmPassword) async {
    if (!isValidPassword(newPassword)) {
      Get.snackbar('Error',
          'La contraseña debe tener al menos 8 caracteres, una mayúscula, una minúscula, un número y un carácter especial.');
      return;
    }
    if (newPassword != confirmPassword) {
      Get.snackbar('Error', 'Las contraseñas no coinciden');
      return;
    }

    isLoading.value = true;
    try {
      await _authService.updatePassword(newPassword);
      Get.snackbar('Éxito', 'Tu contraseña ha sido actualizada.');
      Get.offNamed('/SignInPage');
    } catch (e) {
      Get.snackbar('Error',
          'Error al actualizar la contraseña: ${e.toString().replaceAll('Exception: ', '')}');
    } finally {
      isLoading.value = false;
    }
  }
}
