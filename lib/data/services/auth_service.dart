import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Registro de usuario con correo y contraseña
  Future<AuthResponse?> signUp(String email, String password) async {
    try {
      final response =
          await _supabase.auth.signUp(email: email, password: password);

      if (response.user != null) {
        await _saveUserEmailAndRegistrationTime(response.user!.id, email);
      }

      return response;
    } on AuthException catch (e) {
      if (e.message.contains("already registered")) {
        throw Exception("El correo ya está registrado.");
      } else {
        throw Exception("Error en el registro: ${e.message}");
      }
    } catch (e) {
      throw Exception("Error inesperado en el registro.");
    }
  }

  // Guardar correo y fecha de registro en la tabla `users`
  Future<void> _saveUserEmailAndRegistrationTime(
      String userId, String email) async {
    try {
      await _supabase.from('users').upsert({
        'id': userId,
        'email': email,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Error al guardar los datos del usuario: $e');
    }
  }

  // Inicio de sesión con correo y contraseña
  Future<AuthResponse?> signIn(String email, String password) async {
    try {
      final response = await _supabase.auth
          .signInWithPassword(email: email, password: password);
      return response;
    } on AuthException catch (_) {
      throw Exception("Credenciales incorrectas.");
    } catch (e) {
      throw Exception("Error inesperado en el inicio de sesión.");
    }
  }

  // Restablecer contraseña con correo
  Future<void> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(
        email,
        redirectTo: 'unistay://password-reset', 
      );
    } on AuthException catch (e) {
      throw Exception("Error al enviar correo de recuperación: ${e.message}");
    } catch (e) {
      throw Exception("Error inesperado al restablecer contraseña.");
    }
  }

  // Método para cambiar la contraseña después de recibir el deep link
  Future<void> updatePassword(String newPassword) async {
    try {
      await _supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );
    } on AuthException catch (e) {
      throw Exception("Error al actualizar contraseña: ${e.message}");
    } catch (e) {
      throw Exception("Error inesperado al actualizar la contraseña.");
    }
  }

}
