import 'package:flutter/material.dart';
import 'package:unistay/domain/models/accommodation_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../ui/colors/colors.dart';

class AccommodationCard extends StatefulWidget {
  final AccommodationModel accommodation;
  final Future<void> Function()? onDelete; // Cambiar a función async

  const AccommodationCard({super.key, required this.accommodation, this.onDelete});

  @override
  _AccommodationCardState createState() => _AccommodationCardState();
}

class _AccommodationCardState extends State<AccommodationCard> {
  bool isDeleting = false;

  @override
  Widget build(BuildContext context) {
    bool isLandlordView = ModalRoute.of(context)?.settings.name == '/LandlordPage';

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen principal con carrusel
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child: Stack(
              children: [
                CarouselSlider(
                  options: CarouselOptions(height: 200, enableInfiniteScroll: false),
                  items: widget.accommodation.fotos.map((foto) {
                    return Image.network(
                      foto,
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width,
                    );
                  }).toList(),
                ),
                if (!isLandlordView)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.favorite_border, color: Colors.black),
                        onPressed: () {},
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título del alojamiento
                Text(
                  widget.accommodation.descripcion,
                  style: GoogleFonts.saira(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 5),
                // Ubicación
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.red, size: 16),
                    const SizedBox(width: 5),
                    Text(widget.accommodation.direccion,
                        style: GoogleFonts.saira(color: Colors.black)),
                  ],
                ),
                const SizedBox(height: 8),
                // Precio y calificación
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.monetization_on, color: Colors.green, size: 16),
                        const SizedBox(width: 5),
                        Text('\$${widget.accommodation.price}',
                            style: GoogleFonts.saira(fontWeight: FontWeight.bold, color: Colors.black)),
                      ],
                    ),
                    const Row(
                      children: [
                        Icon(Icons.star, color: Colors.orange, size: 16),
                        Text('5.6', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),

                // Botones de acción (Solo en LandlordPage)
                if (isLandlordView)
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          label: Text('Editar', style: GoogleFonts.saira(color: Colors.black)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                            ),
                          ),
                          icon: const Icon(Icons.edit, color: Colors.black),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: isDeleting
                              ? null
                              : () async {
                                  setState(() => isDeleting = true);
                                  await widget.onDelete?.call();
                                  setState(() => isDeleting = false);
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
                              ? const CircularProgressIndicator(color: Colors.white)
                              : Text('Eliminar', style: GoogleFonts.saira(color: Colors.black)),
                          icon: isDeleting
                              ? const SizedBox.shrink()
                              : const Icon(Icons.delete, color: Colors.black),
                        ),
                      ),
                    ],
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
