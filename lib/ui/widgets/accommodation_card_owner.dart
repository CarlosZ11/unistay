import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:shimmer/shimmer.dart';
import 'package:unistay/domain/controllers/profile_controller.dart';
import 'package:unistay/domain/models/accommodation_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unistay/ui/pages/owner/pages/update_property.dart';
import '../../ui/colors/colors.dart';

class AccommodationOwnerCard extends StatefulWidget {
  final AccommodationModel accommodation;
  final Future<void> Function()? onDelete; // Cambiar a función async

  const AccommodationOwnerCard(
      {super.key, required this.accommodation, this.onDelete});

  @override
  _AccommodationOwnerCardState createState() => _AccommodationOwnerCardState();
}

class _AccommodationOwnerCardState extends State<AccommodationOwnerCard> {
  bool isDeleting = false;
  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();
  final ProfileController _profileController = Get.find<ProfileController>();

  @override
  void initState() {
    super.initState();
    if (_profileController.user.value == null) {
      _profileController.loadUserProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed('/detalleAlojamientoOwner',
            arguments: widget.accommodation);
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
                      viewportFraction: 1.0,
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
                            width: 16.0,
                            height: 16.0,
                            margin: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 4.0),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: (Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white
                                        : Colors.purple)
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
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título del alojamiento
                  Text(
                    widget.accommodation.nombre, // Mostrar el título correcto
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
                          ),
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
                  const SizedBox(height: 5),
                  // Botones de acción (Solo en LandlordPage)
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Get.to(() => UpdatePropertyPage(
                                accommodationModel: widget.accommodation));
                          },
                          label: Text('Editar',
                              style: GoogleFonts.saira(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                            ),
                          ),
                          icon: const Icon(Icons.edit, color: Colors.white),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: isDeleting
                              ? null
                              : () async {
                                  // Asegurarte de que el widget esté montado antes de intentar cambiar el estado
                                  if (mounted) {
                                    setState(() => isDeleting = true);
                                  }

                                  try {
                                    // Llamada asincrónica para eliminar
                                    await widget.onDelete?.call();
                                  } catch (e) {
                                    // Aquí puedes manejar errores si es necesario
                                  } finally {
                                    // Verifica si el widget sigue montado antes de cambiar el estado
                                    if (mounted) {
                                      setState(() => isDeleting = false);
                                    }
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                            ),
                          ),
                          label: isDeleting
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : Text('Eliminar',
                                  style:
                                      GoogleFonts.saira(color: Colors.white)),
                          icon: isDeleting
                              ? const SizedBox.shrink()
                              : const Icon(Icons.delete, color: Colors.white),
                        ),
                      ),
                    ],
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
