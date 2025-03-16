import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Registro de usuario con correo y contraseña
  Future<AuthResponse?> signUp(String email, String password) async {
    try {
      final response =
          await _supabase.auth.signUp(email: email, password: password);
      return response;
    } catch (e) {
      print('Error en el registro: $e');
      return null;
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
