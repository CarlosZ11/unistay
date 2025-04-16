import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unistay/domain/models/accommodation_model.dart';

class TenantService extends GetxService {
  final SupabaseClient supabase = Supabase.instance.client;

  /// Obtiene todos los alojamientos
  Future<List<AccommodationModel>> fetchAllAccommodations() async {
    try {
      final response = await supabase.from('accommodations').select();

      // Verificar si la respuesta tiene datos
      return response.map((item) => AccommodationModel.fromMap(item)).toList();
    } catch (e) {
      throw Exception("Failed to fetch accommodations: $e");
    }
  }

  /// Filtra alojamientos por categoría
  Future<List<AccommodationModel>> fetchAccommodationsByCategory(String categoria) async {
    if (categoria.isEmpty) {
      throw Exception("Category cannot be empty");
    }

    try {
      final response = await supabase
          .from('accommodations')
          .select()
          .eq('categoria', categoria);

      return response.map((item) => AccommodationModel.fromMap(item)).toList();
    } catch (e) {
      throw Exception("Failed to fetch accommodations by category: $e");
    }
  }

  /// Busca alojamientos por texto (nombre o dirección)
  Future<List<AccommodationModel>> searchAccommodations(String query) async {
    if (query.isEmpty) {
      throw Exception("Search query cannot be empty");
    }

    try {
      final response = await supabase.from('accommodations').select().or(
          'nombre.ilike.%$query%,direccion.ilike.%$query%'); // búsqueda parcial

      return response.map((item) => AccommodationModel.fromMap(item)).toList();
    } catch (e) {
      throw Exception("Failed to search accommodations: $e");
    }
  }

  /// Método para filtrar alojamientos por categoría o búsqueda por texto
  Future<List<AccommodationModel>> fetchFilteredAccommodations({String? query, String? category}) async {
    try {
      if ((query == null || query.isEmpty) &&
          (category == null || category.isEmpty)) {
        throw Exception("At least one filter (query or category) must be provided.");
      }

      if (query != null && query.isNotEmpty) {
        return await searchAccommodations(query);
      } else if (category != null && category.isNotEmpty) {
        return await fetchAccommodationsByCategory(category);
      } else {
        return await fetchAllAccommodations(); // Si no hay filtro, devolver todos
      }
    } catch (e) {
      throw Exception("Failed to fetch filtered accommodations: $e");
    }
  }
}
