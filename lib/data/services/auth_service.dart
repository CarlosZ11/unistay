import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Registro de usuario con correo y contraseña
  Future<AuthResponse?> signUp(String email, String password) async {
    try {
      // Realizamos el registro en Supabase
      final response =
          await _supabase.auth.signUp(email: email, password: password);

      // Si el usuario se registra correctamente, guardamos su email y la fecha de registro en la tabla `users`
      if (response.user != null) {
        await _saveUserEmailAndRegistrationTime(response.user!.id, email);
      }

      return response;
    } catch (e) {
      print('Error en el registro: $e');
      return null;
    }
  }

  // Función para guardar el correo y la fecha de registro en la tabla personalizada `users`
  Future<void> _saveUserEmailAndRegistrationTime(
      String userId, String email) async {
    try {
      final response = await _supabase.from('users').upsert({
        'id': userId, // ID del usuario (viene de la tabla auth.users)
        'email': email, // Correo electrónico del usuario
        'created_at': DateTime.now().toIso8601String(), // Fecha de registro
      });

      if (response.error != null) {
        print(
            'Error al guardar el correo y la fecha de registro: ${response.error!.message}');
      } else {
        print('Correo y fecha de registro guardados correctamente');
      }
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
    } catch (e) {
      print('Error en el inicio de sesión: $e');
      return null;
    }
  }

  // Cerrar sesión
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // Obtener el usuario actual
  User? getCurrentUser() {
    return _supabase.auth.currentUser;
  }
}
