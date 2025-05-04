import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:location/location.dart';
import 'package:unistay/domain/controllers/tenant_controller.dart';
import '../../../../domain/controllers/map_controller.dart';
import '../../../../domain/models/accommodation_model.dart';

class MapPage extends StatefulWidget {
  final LatLng? ubicacionInicial;
  const MapPage({super.key, this.ubicacionInicial});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapaController _mapController = MapaController();
  final TenantController _tenantController = Get.find<TenantController>();
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  static const LatLng _valledupar = LatLng(10.4749, -73.2601);

  // void _onMapCreated(GoogleMapController controller) {
  //   mapController = controller;
  // }

  @override
  void initState() {
    super.initState();
    _solicitarPermisosUbicacion();
  }

  Future<void> _cargarAlojamientosYMarcadores() async {
    final marcadores = await _mapController.generarMarcadores(
      _tenantController.accommodations,
      _mostrarModalRuta, // ← pasa la función para cuando se toca un marcador
    );

    setState(() {
      _markers = marcadores;
    });
  }

  void _mostrarModalRuta(AccommodationModel alojamiento) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Text(
                alojamiento.nombre,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                "Dirección: ${alojamiento.direccion}",
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Get.toNamed('/detalleAlojamiento');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  icon: const Icon(HugeIcons.strokeRoundedFolderDetails,
                      color: Colors.white),
                  label: const Text("vista detallada",
                      style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    Navigator.of(context).pop(); // cerrar modal
                    await _trazarRutaHacia(
                        LatLng(alojamiento.latitud, alojamiento.longitud));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  icon: const Icon(HugeIcons.strokeRoundedNavigation03,
                      color: Colors.white),
                  label: const Text("Cómo llegar",
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _limpiarRuta() {
    setState(() {
      _polylines.clear();
    });
  }

  Future<void> _trazarRutaHacia(LatLng destino) async {
    final puntos = await _mapController.trazarRutaHacia(destino);

    final ruta = Polyline(
      polylineId: const PolylineId("ruta"),
      color: Colors.blue,
      width: 5,
      points: puntos,
    );

    setState(() {
      _polylines.clear();
      _polylines = {ruta};
    });

    _mapController.moverCamaraARuta(puntos); // centra en la ruta
  }

  void _solicitarPermisosUbicacion() async {
    final location = Location();

    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () {
          if (_tenantController.accommodations.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else {
            _cargarAlojamientosYMarcadores();
            return GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: _valledupar,
                zoom: 16.0,
              ),
              onMapCreated: (controller) {
                _mapController.onMapCreated(controller);
                _mapController.asignarControlador(controller);
                if (widget.ubicacionInicial != null) {
                  _mapController
                      .centrarEnUbicacionActual(widget.ubicacionInicial);
                } else {
                  _mapController.centrarEnUbicacionActual(
                      null); // centrarse en ubicación del dispositivo
                }
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              markers: _markers,
              polylines: _polylines,
              onTap: (_) => _limpiarRuta(),
            );
          }
        },
      ),
    );
  }
}
