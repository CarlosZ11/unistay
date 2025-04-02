import 'package:unistay/domain/models/accommodation_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TenantService {
  final SupabaseClient supabase = Supabase.instance.client;

  /// Obtiene todos los alojamientos
  Future<List<AccommodationModel>> getAllAccommodations() async {
    final response = await supabase
        .from('accommodations')
        .select(); 

    return response.map((data) => AccommodationModel.fromMap(data)).toList();
  }

  /// Filtra alojamientos por dirección  o categoría
  Future<List<AccommodationModel>> filterAccommodations(String query) async {
    final response = await supabase
        .from('accommodations')
        .select()
        .or("direccion.ilike.%$query%,categoria.ilike.%$query%"); 

    return response.map((data) => AccommodationModel.fromMap(data)).toList();
  }
}
