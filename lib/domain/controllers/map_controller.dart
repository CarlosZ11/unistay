
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../../data/services/location_service.dart';
import '../models/accommodation_model.dart';

class MapaController {
  final UbicacionService _ubicacionService = UbicacionService();
  Point? ubicacion;

  Future<Point?> cargarUbicacion() async {
    final data = await _ubicacionService.obtenerUbicacionActual();
    if (data != null) {
      ubicacion = Point(
        coordinates: Position(data.longitude!, data.latitude!),
      );
    }
    return ubicacion;
  }

  Future<void> mostrarAlojamientosEnMapa({
    required List<AccommodationModel> alojamientos,
    required MapboxMap mapboxMap,
  }) async {
    final pointAnnotationManager =
        await mapboxMap.annotations.createPointAnnotationManager();

    for (var alojamiento in alojamientos) {
      await pointAnnotationManager.create(PointAnnotationOptions(
        geometry: Point(
          coordinates: Position(alojamiento.longitud, alojamiento.latitud),
        ),
        iconSize: 1.5,
        iconImage: "marker-15", // Puedes cambiar por un icono personalizado si lo agregas al estilo
        textField: alojamiento.nombre,
        textOffset: [0.0, 1.5],
      ));
    }
  }

}