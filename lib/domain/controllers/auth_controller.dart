import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unistay/data/services/auth_service.dart';
import 'package:unistay/domain/controllers/profile_controller.dart';
import 'package:unistay/domain/controllers/utils/validation.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  final profileController = Get.put(ProfileController());
  final validation = Validation();

  var isLoading = false.obs;
  var nombreCompleto = ''.obs;

  // Registro de usuario
  Future<bool> registerUser({
    required String name,
    required String lastname,
    required String email,
    required String password,
    required String phone,
    required String identification,
    required String role,
  }) async {
    name = validation.normalizeText(name);
    lastname = validation.normalizeText(lastname);
    email = email.trim().toLowerCase();

    if (name.isEmpty ||
        lastname.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        phone.isEmpty ||
        identification.isEmpty ||
        role.isEmpty) {
      Get.snackbar('Error', 'Todos los campos son obligatorios');
      return false;
    }
    if (!validation.isValidName(name) || !validation.isValidName(lastname)) {
      Get.snackbar('Error',
          'Nombre y apellido deben ser válidos (solo letras y espacios)');
      return false;
    }
    if (!validation.isValidEmail(email)) {
      Get.snackbar('Error', 'Correo electrónico no válido');
      return false;
    }
    if (!validation.isValidPassword(password)) {
      Get.snackbar('Error',
          'La contraseña debe tener al menos 8 caracteres, una mayúscula, una minúscula, un número y un carácter especial.');
      return false;
    }
    if (!validation.isValidPhone(phone)) {
      Get.snackbar('Error',
          'El teléfono debe contener exactamente 10 dígitos numéricos');
      return false;
    }
    if (!validation.isValidIdentification(identification)) {
      Get.snackbar(
          'Error', 'La cédula debe tener entre 8 y 10 dígitos numéricos');
      return false;
    }
    if (role.isEmpty) {
      Get.snackbar('Error', 'Debe seleccionar un rol');
      return false;
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
        Get.back();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      Get.snackbar('Error',
          'No se pudo registrar: ${e.toString().replaceAll('Exception: ', '')}');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Inicio de sesión

  Future<String?> signIn(String email, String password) async {
    isLoading.value = true;

    try {
      // Intentar iniciar sesión con el servicio de autenticación
      final response = await _authService.signIn(email, password);

      final userId = response?.user?.id;

      // Si el inicio de sesión fue exitoso y hay un ID de usuario válido
      if (userId != null) {
        await profileController.loadUserProfile(); // Cargar datos del perfil
        return userId;
      } else {
        Get.snackbar('Error', 'Credenciales inválidas');
        return null;
      }
    } on AuthException catch (e) {
      // Captura de errores específicos de autenticación
      Get.snackbar('Error de autenticación', e.message);
      return null;
    } catch (e) {
      // Captura de errores no esperados
      Get.snackbar('Error', 'Ocurrió un error inesperado');
      return null;
    } finally {
      // Detener el estado de carga
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

    if (!validation.isValidEmail(email)) {
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
    if (!validation.isValidPassword(newPassword)) {
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

  // Método para obtener el número de teléfono del arrendador
  Future<String?> obtenerNumeroArrendador(String idPropietario) async {
    // Comprobamos si el ID del propietario está vacío
    if (idPropietario.isEmpty) {
      Get.snackbar('Error', 'El ID del propietario no puede estar vacío');
      return null; // Retorna null si no se puede proceder
    }

    isLoading.value = true;
    try {
      // Llamamos al servicio que retorna el número de teléfono
      final phone = await _authService.obtenerNumeroArrendador(idPropietario);

      if (phone != null) {
        print('Número de teléfono obtenido' 'Número de teléfono: $phone');

        return phone; // Retorna el número de teléfono obtenido
      } else {
        print('Error' 'No se pudo obtener el número de teléfono');
        return null; // Retorna null si no se obtiene el número
      }
    } catch (e) {
      Get.snackbar(
          'Error', 'Ocurrió un error al obtener el número: ${e.toString()}');
      return null; // Retorna null en caso de error
    } finally {
      isLoading.value = false;
    }
  }

  Future<String?> getUserById(String idPropietario) async {
    if (idPropietario.isEmpty) {
      Get.snackbar('Error', 'El ID del propietario no puede estar vacío');
      return null;
    }

    isLoading.value = true;
    try {
      final nombrePropietario = await _authService.getUserById(idPropietario);

      if (nombrePropietario != null) {
        return nombrePropietario;
      } else {
        Get.snackbar('Error', 'No se pudo obtener el nombre del propietario');
        return null;
      }
    } catch (e) {
      Get.snackbar(
          'Error', 'Ocurrió un error al obtener el nombre: ${e.toString()}');
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<String> cargarNombrePropietario(String id) async {
    final nombre =
        await getUserById(id); // Llamamos al servicio para obtener el nombre

    if (nombre != null) {
      nombreCompleto.value =
          nombre; // Actualizamos el valor de nombreCompleto si es exitoso
      return nombre; // Retornamos el nombre completo
    } else {
      nombreCompleto.value =
          'No disponible'; // Si no se encuentra el nombre, actualizamos a 'No disponible'
      return 'No disponible'; // Retornamos un valor predeterminado si el nombre no está disponible
    }
  }
}
