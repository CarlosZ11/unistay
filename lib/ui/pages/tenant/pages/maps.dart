import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../../../../domain/controllers/map_controller.dart';
import '../../../../domain/models/accommodation_model.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

  final _mapaController = MapaController();
  MapboxMap? _mapboxMap;

  final List<AccommodationModel> listaAlojamientos = [
    AccommodationModel(
      idAlojamiento: '1',
      nombre: 'Iglesia',
      direccion: 'Calle 10 #12-34',
      price: 100000,
      fotos: ['https://via.placeholder.com/150'],
      ventajas: ['Wi-Fi', 'Cerca del parque', 'Agua caliente'],
      descripcion: 'Alojamiento en el centro de Valledupar',
      numeroHabitaciones: 3,
      disponible: true,
      categoria: 'Familiar',
      idPropietario: 'prop123',
      promedioPuntuacion: 4.5,
      cantidadComentarios: 12,
      latitud: 10.468730249496476,
      longitud: -73.26325620528516,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _mapaController.cargarUbicacion().then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {

    final ubicacion = _mapaController.ubicacion;

    if (ubicacion == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: MapWidget(
        key: const ValueKey("mapWidget"),
        cameraOptions: CameraOptions(
          center: Point(coordinates: ubicacion.coordinates),
          zoom: 14.0,
        ),
        onMapCreated: (MapboxMap mapboxMap) async {
          _mapboxMap = mapboxMap;
          
          await _mapaController.mostrarAlojamientosEnMapa(
            alojamientos: listaAlojamientos,
            mapboxMap: mapboxMap,
          );

          // Cambiar el estilo del mapa
          mapboxMap.loadStyleURI("mapbox://styles/mapbox/streets-v12");

          // Mostrar punto actual en el mapa
          mapboxMap.location.updateSettings(LocationComponentSettings(
            enabled: true,
            pulsingEnabled: true,
          ));
        },
      ),
    );
  }
}