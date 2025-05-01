import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RutaService {
  final String _apiKey = 'AIzaSyB1oS9H3xyC_LlfUubwwl1yluYnrolHKZQ'; // reemplaza por la tuya

  Future<List<LatLng>> obtenerRuta(LatLng origen, LatLng destino) async {
    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origen.latitude},${origen.longitude}&destination=${destino.latitude},${destino.longitude}&key=$_apiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('Error al obtener la ruta');
    }

    final data = json.decode(response.body);
    final pointsEncoded = data['routes'][0]['overview_polyline']['points'];
    return _decodificarPoly(pointsEncoded);
  }

  List<LatLng> _decodificarPoly(String poly) {
    List<LatLng> puntos = [];
    int index = 0, len = poly.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;

      do {
        b = poly.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlat = ((result & 1) != 0) ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = poly.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlng = ((result & 1) != 0) ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      puntos.add(LatLng(lat / 1e5, lng / 1e5));
    }

    return puntos;
  }
}
