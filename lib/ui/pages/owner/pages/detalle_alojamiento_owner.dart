import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:unistay/domain/models/accommodation_model.dart';
import 'package:get/get.dart';
import 'package:unistay/ui/pages/tenant/pages/lista_comentarios.dart';
import 'package:unistay/domain/controllers/commentcontroller.dart';

class DetalleAlojamientoOwner extends StatefulWidget {
  final AccommodationModel accommodation = Get.arguments as AccommodationModel;

  DetalleAlojamientoOwner({super.key});

  @override
  State<DetalleAlojamientoOwner> createState() => _DetalleAlojamientoState();
}

class _DetalleAlojamientoState extends State<DetalleAlojamientoOwner> {
  final CommentController _commentController = Get.put(CommentController());

  int _current = 0;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _commentController.loadComments(widget.accommodation.idAlojamiento);
    });
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
                  items: widget.accommodation.fotos.map((foto) {
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
                      children: widget.accommodation.fotos
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
            // Título
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Expanded(
                child: Text(
                  widget.accommodation.nombre,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            // Dirección
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: Row(
                children: [
                  HugeIcon(
                    icon: HugeIcons.strokeRoundedLocation01,
                    color: Colors.black,
                    size: 16,
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      widget.accommodation.direccion,
                      style: GoogleFonts.saira(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),

            // Calificación
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 13.0, vertical: 4.0),
              child: Row(
                children: [
                  Icon(Icons.star, color: Colors.yellow),
                  SizedBox(width: 5),
                  Text('4.5 (95 opiniones)',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
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
                  Text('COP\$ ${widget.accommodation.price}',
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
                    child: Text(widget.accommodation.descripcion,
                        style: GoogleFonts.saira(color: Colors.black)),
                  ),
                ],
              ),
            ),

            // Beneficios (placeholder)
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
                            idAlojamiento: widget.accommodation.idAlojamiento,
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
          ],
        ),
      ),
    );
  }
}
