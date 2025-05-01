import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:shimmer/shimmer.dart';
import 'package:unistay/domain/controllers/profile_controller.dart';
import 'package:unistay/domain/controllers/tenant_controller.dart';
import 'package:unistay/domain/models/accommodation_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';

class AccommodationCard extends StatefulWidget {
  final AccommodationModel accommodation;
  final Future<void> Function()? onDelete; // Cambiar a función async

  const AccommodationCard(
      {super.key, required this.accommodation, this.onDelete});

  @override
  _AccommodationCardState createState() => _AccommodationCardState();
}

class _AccommodationCardState extends State<AccommodationCard> {
  int _current = 0;

  double _scale = 1.0;
  final CarouselSliderController _controller = CarouselSliderController();
  final ProfileController _profileController = Get.find<ProfileController>();
  final TenantController _tenantController = Get.find<TenantController>();
  @override
  void initState() {
    super.initState();

    widget.accommodation.isFavorite.value = _profileController.favorites.any(
      (fav) => fav.idAlojamiento == widget.accommodation.idAlojamiento,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _tenantController.selectedAccommodation(widget.accommodation);
        Get.toNamed('/detalleAlojamiento');
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 5,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen principal con carrusel
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(15)),
              child: Stack(
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 200,
                      enableInfiniteScroll: true,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                        });
                      },
                    ),
                    carouselController: _controller,
                    items: widget.accommodation.fotos.map((foto) {
                      return Image.network(
                        foto,
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade100,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 200,
                              color: Colors.white,
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                  // Verifica si es "propietario" antes de mostrar el corazón
                  Obx(
                    () => Positioned(
                      top: 10,
                      right: 10,
                      child: GestureDetector(
                        onTapDown: (_) {
                          setState(() => _scale = 0.9); // Efecto de presión
                        },
                        onTapUp: (_) {
                          setState(() {
                            _scale = 1.0;
                            widget.accommodation.isFavorite.value =
                                !widget.accommodation.isFavorite.value;
                          });
                          if (widget.accommodation.isFavorite.value) {
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
                        onTapCancel: () {
                          setState(() => _scale = 1.0);
                        },
                        child: AnimatedScale(
                          scale: _scale,
                          duration: const Duration(milliseconds: 100),
                          curve: Curves.easeOut,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.black.withAlpha(153), // 60% opacity
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      Colors.black.withAlpha(77), // 30% opacity
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              transitionBuilder: (child, animation) =>
                                  ScaleTransition(
                                      scale: animation, child: child),
                              child: Icon(
                                widget.accommodation.isFavorite.value
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                key: ValueKey<bool>(
                                    widget.accommodation.isFavorite.value),
                                color: widget.accommodation.isFavorite.value
                                    ? Colors.pinkAccent
                                    : Colors.white,
                                size: 22,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
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
                        return GestureDetector(
                          onTap: () => _controller.animateToPage(entry.key),
                          child: Container(
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
                                    .withAlpha(
                                        _current == entry.key ? 230 : 102)),
                          ),
                        );
                      }).toList(),
                    ),
                  ))
                ],
              ),
            ),
            //Datos del alojamiento
            // Padding para el contenido del alojamiento
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título del alojamieno
                  Text(
                    widget.accommodation.nombre,
                    style: GoogleFonts.saira(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          HugeIcon(
                            icon: HugeIcons.strokeRoundedLocation01,
                            color: Colors.black,
                            size: 16,
                          ),
                          const SizedBox(width: 5),
                          Text(widget.accommodation.direccion,
                              style: GoogleFonts.saira(color: Colors.black)),
                        ],
                      ),
                      Row(
                        children: [
                          HugeIcon(
                            icon: Icons.star,
                            color: Colors.yellow,
                          ),
                          Text(
                            '${widget.accommodation.promedioPuntuacion}', // 👈 dinámico
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text('COP\$ ${widget.accommodation.price}',
                      style: GoogleFonts.saira(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Text(
                    widget.accommodation.descripcion,
                    style: GoogleFonts.saira(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
