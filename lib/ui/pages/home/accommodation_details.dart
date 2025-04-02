import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unistay/domain/controllers/acccommodation_details_controller.dart';
import 'package:unistay/domain/models/accommodation_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unistay/ui/colors/colors.dart';

class Accommodationdetails extends StatelessWidget {
  const Accommodationdetails({super.key});

  @override
  Widget build(BuildContext context) {
    final AccommodationModel accommodation =
        ModalRoute.of(context)?.settings.arguments as AccommodationModel;
    final AccommodationModel accommodation2 = AccommodationModel(
      idAlojamiento: '2',
      direccion: 'Carrera 45, Medellín',
      fotos: [
        "https://th.bing.com/th/id/R.752a118fa0183c370fe39671b3b72219?rik=I307Oo5cKCRfzA&pid=ImgRaw&r=0",
        "https://th.bing.com/th/id/R.752a118fa0183c370fe39671b3b72219?rik=I307Oo5cKCRfzA&pid=ImgRaw&r=0",
        "https://th.bing.com/th/id/R.752a118fa0183c370fe39671b3b72219?rik=I307Oo5cKCRfzA&pid=ImgRaw&r=0"
      ],
      ventajas: ['Desayuno incluido', 'Balcón con vista', 'Gimnasio'],
      price: 200000,
      descripcion: 'Apartamento moderno en el centro de Medellín.',
      numeroHabitaciones: 2,
      disponible: true,
      categoria: 'Apartamento',
      idPropietario: 'prop2',
    );
    final CarouselSliderController _controller = CarouselSliderController();
    final DetailsController detailsC = Get.put(DetailsController());
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, '/HomePage');
          },
        ),
        backgroundColor: AppColors.primary,
        title: Text("Alojamiento",
            style: GoogleFonts.saira(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Column(children: [
        Stack(
          children: [
            CarouselSlider(
              carouselController: _controller,
              options: CarouselOptions(
                height: 200,
                enableInfiniteScroll: true,
                onPageChanged: (index, reason) => {
                  detailsC.setCurrent(index),
                },
              ),
              items: accommodation2.fotos.map((foto) {
                return Image.network(
                  foto,
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                );
              }).toList(),
            ),
            Positioned(
              top: 160,
              right: 0,
              left: 0,
              child: Obx(
                () => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: accommodation2.fotos.asMap().entries.map((entry) {
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
                                  .withOpacity(detailsC.current == entry.key
                                      ? 0.9
                                      : 0.4)),
                        ),
                      );
                    }).toList()),
              ),
            )
          ],
        ),
      ]),
    );
  }
}
