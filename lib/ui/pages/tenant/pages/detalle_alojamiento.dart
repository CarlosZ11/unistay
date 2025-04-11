import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:unistay/domain/controllers/ProfileController.dart';
import 'package:unistay/domain/models/accommodation_model.dart';
import 'package:get/get.dart';
import 'package:unistay/ui/pages/tenant/pages/lista_comentarios.dart';

class DetalleAlojamiento extends StatefulWidget {
  final AccommodationModel accommodation = Get.arguments as AccommodationModel;

  DetalleAlojamiento({super.key});

  @override
  State<DetalleAlojamiento> createState() => _DetalleAlojamientoState();
}

class _DetalleAlojamientoState extends State<DetalleAlojamiento> {
  int _current = 0;
  bool isFavorite = false;
  double _scale = 1.0;
  late final ProfileController _profileController;

  


  @override
  void initState() {
    _profileController = Get.find<ProfileController>();
    if (_profileController.favorites.any(
        (fav) => fav.idAlojamiento == widget.accommodation.idAlojamiento)) {
      isFavorite = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final List<Map<String, dynamic>> dummyComentarios = [
      {
        'nombre': 'Ana Luisa',
        'rating': 4.8,
        'texto': 'Um moderno apartamento em Orlando, completo com cozinha equipada e quartos confortáveis.'
      },
      {
        'nombre': 'Carlos Mendes',
        'rating': 4.6,
        'texto': 'Apartamento bem localizado e muito limpo. Voltarei com certeza!'
      },
      // ... más comentarios
    ];

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

            // Título y botón de favoritos
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Expanded(
                    child: Text(
                      "Titulo generico",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                          widget.accommodation.idAlojamiento,
                        );
                      } else {
                        _profileController.removeFavorite(
                          _profileController.user.value!.id,
                          widget.accommodation.idAlojamiento,
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
                    child: Text(
                        "lorem ipsum dolor sit amet, consectetur adipiscing elit. "
                        "Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. "
                        "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. "
                        "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. ",
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
                    children: widget.accommodation.ventajas
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ComentariosPage()));
                    },
                    child: SizedBox(
                      height: 145,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: dummyComentarios.length,
                        itemBuilder: (context, index) {
                          final comentario = dummyComentarios[index];
                          return Container(
                            width: 250,
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE7EDFB), // fondo celeste suave como la imagen
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Nombre y calificación
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      comentario['nombre'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          comentario['rating'].toString(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(width: 3,),
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
                                  limitarTexto(comentario['texto'], 12), // Cambia 15 por el límite que prefieras
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
            // Propietario
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Propietario (a)",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    title: Text("Maria Antonieta"),
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
                    onPressed: () {},
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
