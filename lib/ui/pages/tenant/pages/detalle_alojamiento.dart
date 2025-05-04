import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:unistay/domain/controllers/profile_controller.dart';
import 'package:unistay/domain/controllers/auth_controller.dart';
import 'package:unistay/domain/controllers/owner_controller.dart';
import 'package:unistay/domain/controllers/tenant_controller.dart';
import 'package:get/get.dart';
import 'package:unistay/ui/pages/tenant/pages/lista_comentarios.dart';
import 'package:unistay/domain/controllers/comment_controller.dart';
import 'package:unistay/ui/pages/tenant/pages/maps.dart';

class DetalleAlojamiento extends StatefulWidget {
  DetalleAlojamiento({super.key});

  @override
  State<DetalleAlojamiento> createState() => _DetalleAlojamientoState();
}

class _DetalleAlojamientoState extends State<DetalleAlojamiento> {
  final CommentController _commentController = Get.put(CommentController());

  final TenantController _tenantController = Get.find<TenantController>();
  final AuthController _authController = Get.find<AuthController>();
  final OwnerController _ownercontroller = Get.find<OwnerController>();
  String propietarioNombre = '';

  int _current = 0;
  bool isFavorite = false;
  double _scale = 1.0;
  late final ProfileController _profileController;

  @override
  void initState() {
    super.initState();
    _profileController = Get.find<ProfileController>();

    if (_profileController.favorites.any((fav) =>
        fav.idAlojamiento ==
        _tenantController.selectedAccommodation.value!.idAlojamiento)) {
      isFavorite = true;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _commentController.loadComments(
          _tenantController.selectedAccommodation.value!.idAlojamiento);
    });

    Future<void> cargarNombrePropietario(String id) async {
      String nombre = await _authController
          .cargarNombrePropietario(id); // Esperamos el nombre
      setState(() {
        propietarioNombre = nombre; // Actualizamos el estado con el nombre
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String limitarTexto(String texto, int maxPalabras) {
      final palabras = texto.split(' ');
      if (palabras.length <= maxPalabras) return texto;
      return palabras.sublist(0, maxPalabras).join(' ');
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Carrusel de imágenes
            Stack(
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                    height: 300,
                    enableInfiniteScroll: true,
                    onPageChanged: (index, reason) {
                      setState(() => _current = index);
                    },
                  ),
                  items: _tenantController.selectedAccommodation.value!.fotos
                      .map((foto) {
                    return Image.network(
                      foto,
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width,
                    );
                  }).toList(),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _tenantController
                          .selectedAccommodation.value!.fotos
                          .asMap()
                          .entries
                          .map((entry) {
                        return Container(
                          width: 12.0,
                          height: 12.0,
                          margin: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 4.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: (Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black)
                                .withAlpha(_current == entry.key ? 230 : 102),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),

            // Título y botón de favoritos
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      _tenantController.selectedAccommodation.value!.nombre,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  GestureDetector(
                    onTapDown: (_) => setState(() => _scale = 0.9),
                    onTapUp: (_) {
                      setState(() {
                        _scale = 1.0;
                        isFavorite = !isFavorite;
                      });
                      if (isFavorite) {
                        _profileController.setFavorite(
                          _profileController.user.value!.id,
                          _tenantController
                              .selectedAccommodation.value!.idAlojamiento,
                        );
                      } else {
                        _profileController.removeFavorite(
                          _profileController.user.value!.id,
                          _tenantController
                              .selectedAccommodation.value!.idAlojamiento,
                        );
                      }
                    },
                    onTapCancel: () => setState(() => _scale = 1.0),
                    child: AnimatedScale(
                      scale: _scale,
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.easeOut,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black.withAlpha(153),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(77),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder: (child, animation) =>
                              ScaleTransition(scale: animation, child: child),
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            key: ValueKey<bool>(isFavorite),
                            color:
                                isFavorite ? Colors.pinkAccent : Colors.white,
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Dirección
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: Row(
                children: [
                  // Primer elemento expandido
                  Expanded(
                    child: Row(
                      children: [
                        HugeIcon(
                          icon: HugeIcons.strokeRoundedLocation01,
                          color: Colors.black,
                          size: 16,
                        ),
                        const SizedBox(width: 5),
                        // Texto expandido dentro del espacio disponible
                        Expanded(
                          child: Text(
                            _tenantController
                                .selectedAccommodation.value!.direccion,
                            style: GoogleFonts.saira(color: Colors.black),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Segundo elemento: el botón
                  IconButton(
                    onPressed: () {
                      final ubicacion = LatLng(
                        _tenantController.selectedAccommodation.value!.latitud,
                        _tenantController.selectedAccommodation.value!.longitud,
                      );
                      Get.to(() => MapPage(
                            ubicacionInicial: ubicacion,
                          ));
                    },
                    icon: HugeIcon(
                      icon: HugeIcons.strokeRoundedMapsLocation01,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),

            // Calificación
            // Calificación
            Obx(
              () => Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 13.0, vertical: 4.0),
                child: Row(
                  children: [
                    const Icon(Icons.star, color: Colors.yellow),
                    const SizedBox(width: 5),
                    Text(
                      '${_tenantController.selectedAccommodation.value!.promedioPuntuacion}', // 👈 dinámico
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '(${_tenantController.selectedAccommodation.value!.cantidadComentarios})', // 👈 Mostrar la cantidad de comentarios entre paréntesis
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),

            // Precio
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Precio",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(
                      'COP\$ ${_tenantController.selectedAccommodation.value!.price}',
                      style: GoogleFonts.saira(
                        fontSize: 18,
                        color: Colors.black,
                      )),
                ],
              ),
            ),

            // Descripción
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Descripción",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                        _tenantController
                            .selectedAccommodation.value!.descripcion,
                        style: GoogleFonts.saira(color: Colors.black)),
                  ),
                ],
              ),
            ),

            // Beneficios (placeholder)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "Beneficios",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        _tenantController.selectedAccommodation.value!.ventajas
                            .take(4)
                            .map((ventaja) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.check_circle,
                                          color: Colors.green, size: 20),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          ventaja,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                ))
                            .toList(),
                  ),
                ],
              ),
            ),
            // Comentarios
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Comentarios",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ComentariosPage(
                            idAlojamiento: _tenantController
                                .selectedAccommodation.value!.idAlojamiento,
                          ),
                        ),
                      );
                    },
                    child: SizedBox(
                      height: 145,
                      child: Obx(() {
                        if (_commentController.isLoading.value) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (_commentController.comments.isEmpty) {
                          return const Center(
                              child: Text("No hay comentarios aún."));
                        }

                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount:
                              _commentController.comments.length.clamp(0, 5),
                          itemBuilder: (context, index) {
                            final comentario =
                                _commentController.comments[index];
                            return Container(
                              width: 250,
                              margin: const EdgeInsets.only(right: 10),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE7EDFB),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Nombre y puntuación
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        comentario.nombreUsuario,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            comentario.puntuacion.toString(),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(width: 3),
                                          const Icon(
                                            HugeIcons.strokeRoundedStar,
                                            color: Colors.orange,
                                            size: 16,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    limitarTexto(comentario.descripcion, 12),
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }),
                    ),
                  )
                ],
              ),
            ),
            // Propietario

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Propietario (a)",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    title: FutureBuilder<String>(
                      future: _authController.cargarNombrePropietario(
                          _tenantController.selectedAccommodation.value!
                              .idPropietario), // Llamamos al método asíncrono para obtener el nombre
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Text(
                              'Cargando...'); // Si está esperando, mostramos "Cargando..."
                        } else if (snapshot.hasError) {
                          return Text(
                              'Error: ${snapshot.error}'); // Si hay un error, lo mostramos
                        } else if (snapshot.hasData) {
                          return Text(
                            snapshot
                                .data!, // Si los datos están disponibles, mostramos el nombre
                            style: TextStyle(fontSize: 18),
                          );
                        } else {
                          return Text(
                              'No disponible'); // Si no hay datos, mostramos un mensaje predeterminado
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Entrar en contacto
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width *
                      0.8, // 80% del ancho de pantalla
                  child: ElevatedButton(
                    onPressed: () async {
                      // Obtener el número de teléfono del arrendador
                      final phone = await _authController
                          .obtenerNumeroArrendador(_tenantController
                              .selectedAccommodation.value!.idPropietario);

                      // Si el número es válido, abrir WhatsApp, si no mostrar un error
                      if (phone != null) {
                        await _ownercontroller.openChat(
                            context: context,
                            phoneNumber: phone,
                            message:
                                "¡Hola! Estoy interesad@ en el arrendamiento de la propiedad que publicaste:\n\n"
                                "Nombre:    ${_tenantController.selectedAccommodation.value!.nombre}\n"
                                "Precio:    \$${_tenantController.selectedAccommodation.value!.price}\n"
                                "Dirección: ${_tenantController.selectedAccommodation.value!.direccion}\n\n"
                                "¿Me podrías proporcionar más información? ¡Gracias!");
                      } else {
                        // Mostrar mensaje de error
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'No se pudo obtener el número del arrendador.')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(6), // Menos redondeado
                      ),
                    ),
                    child: const Text(
                      "Entrar en contacto",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
