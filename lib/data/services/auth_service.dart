import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unistay/domain/models/user_model.dart';
import 'package:unistay/domain/models/user_role.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Registro de usuario con todos los campos
  Future<AuthResponse?> signUp(
    String name,
    String lastname,
    String email,
    String password,
    String phone,
    String identification,
    String role,
  ) async {
    try {
      final response =
          await _supabase.auth.signUp(email: email, password: password);

      if (response.user != null) {
        final user = UserModel(
          identification: identification, // PRIMARY KEY
          id: response.user!.id, // UUID de Supabase (ya no es PRIMARY)
          name: name,
          lastname: lastname,
          email: email,
          phone: phone,
          role: role,
          createdAt: DateTime.now().toIso8601String(),
        );

        await _saveUserData(user);
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

  // Guardar usuario en la tabla `users`
  Future<void> _saveUserData(UserModel user) async {
    try {
      await _supabase.from('users').upsert({
        // PRIMARY KEY
        'id': user.id, // UUID de Supabase
        'identification': user.identification,
        'name': user.name,
        'lastname': user.lastname,
        'email': user.email,
        'phone': user.phone,
        'role': user.role,
        'created_at': user.createdAt,
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

  // Cierre de sesión
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      throw Exception("Error al cerrar sesión: $e");
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

  Future<UserRole?> getUserRole(String userId) async {
    final response = await _supabase
        .from('users')
        .select('role')
        .eq('id', userId)
        .single(); // Obtener solo un resultado

    // ignore: unnecessary_null_comparison
    if (response == null) {
      return null; // No encontró el usuario
    }

    // Convertir el rol de String a enum
    return UserRole.values.firstWhere(
      (role) => role.toString().split('.').last == response['role'],
      orElse: () => UserRole.inquilino, // Valor por defecto si no coincide
    );
  }

  Future<String?> obtenerNumeroArrendador(String idPropietario) async {
    try {
      final response = await _supabase
          .from('users')
          .select('phone')
          .eq('id', idPropietario)
          .single();

      return response['phone'] as String?;
    } catch (e) {
      return null;
    }
  }

  Future<String?> getUserById(String idPropietario) async {
    try {
      final response = await _supabase
          .from('users')
          .select('name, lastname')
          .eq('id', idPropietario)
          .single();

      return '${response['name']} ${response['lastname']}';
    } catch (e) {
      return null;
    }
  }
}
