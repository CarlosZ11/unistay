import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:unistay/domain/controllers/tenant_controller.dart';
import 'package:unistay/domain/controllers/utils/map_style.dart';
import '../../data/services/location_service.dart';
import 'package:unistay/domain/models/accommodation_model.dart';
import 'package:get/get.dart';
import '../../data/services/route_service.dart';

class MapaController {
  final UbicacionService _ubicacionService = UbicacionService();
  GoogleMapController? _mapController;
  final TenantController _tenantController = Get.find<TenantController>();
  void asignarControlador(GoogleMapController controller) {
    _mapController = controller;
  }

  Future<void> centrarEnUbicacionActual(LatLng? ubicacionInicial) async {
    if (ubicacionInicial != null) {
      final posicion =
          LatLng(ubicacionInicial.latitude, ubicacionInicial.longitude);
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(posicion, 16),
      );
    } else {
      final ubicacion = await _ubicacionService.obtenerUbicacionActual();
      if (ubicacion != null) {
        final posicion = LatLng(ubicacion.latitude!, ubicacion.longitude!);
        _mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(posicion, 16),
        );
      }
    }
  }

  void onMapCreated(GoogleMapController controller) {
    // ignore: deprecated_member_use
    controller.setMapStyle(mapStyle);
  }

  Future<Set<Marker>> generarMarcadores(
    List<AccommodationModel> alojamientos,
    Function(AccommodationModel) onMarkerTap,
  ) async {
    print("alojamientos ----------------------------------------------");
    print(alojamientos);
    return alojamientos.map((alojamiento) {
      return Marker(
        markerId: MarkerId(alojamiento.idAlojamiento),
        position: LatLng(alojamiento.latitud, alojamiento.longitud),
        infoWindow: InfoWindow(
          title: alojamiento.nombre,
          snippet: "\$${alojamiento.price}",
          onTap: () {
            _tenantController.setSelectAccommodation(alojamiento);
            onMarkerTap(alojamiento);
          }, // ahora pasas el alojamiento
        ),
      );
    }).toSet();
  }

  void moverCamaraARuta(List<LatLng> puntos) {
    final bounds = LatLngBounds(
      southwest: LatLng(
        puntos.map((p) => p.latitude).reduce((a, b) => a < b ? a : b),
        puntos.map((p) => p.longitude).reduce((a, b) => a < b ? a : b),
      ),
      northeast: LatLng(
        puntos.map((p) => p.latitude).reduce((a, b) => a > b ? a : b),
        puntos.map((p) => p.longitude).reduce((a, b) => a > b ? a : b),
      ),
    );
    _mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
  }

  Future<List<LatLng>> trazarRutaHacia(LatLng destino) async {
    final ubicacion = await _ubicacionService.obtenerUbicacionActual();
    if (ubicacion == null) throw Exception("Ubicación no disponible");

    final origen = LatLng(ubicacion.latitude!, ubicacion.longitude!);
    return await RutaService().obtenerRuta(origen, destino);
  }
}
