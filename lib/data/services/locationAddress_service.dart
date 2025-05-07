import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, double>> getCoordinatesFromGoogleMaps(String address) async {
  final apiKey = 'AIzaSyB1oS9H3xyC_LlfUubwwl1yluYnrolHKZQ';
  final uri = Uri.parse(
    'https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(address)}&key=$apiKey',
  );

  try {
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['status'] == 'OK') {
        final result = data['results'][0];
        final location = result['geometry']['location'];
        final latitude = location['lat'];
        final longitude = location['lng'];


        return {
          'latitude': latitude,
          'longitude': longitude,
        };
      } else {
        throw Exception("Google Maps no encontró resultados: ${data['status']}");
      }
    } else {
      throw Exception('Error de red: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error al obtener coordenadas de Google Maps: $e');
  }
}
