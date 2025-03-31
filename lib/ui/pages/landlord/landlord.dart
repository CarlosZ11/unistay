import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unistay/domain/models/accommodation_model.dart';
import 'package:unistay/ui/widgets/Accommodation_card.dart';
import '../../colors/colors.dart';

class Landlord extends StatelessWidget {
  const Landlord({super.key});

  @override
  Widget build(BuildContext context) {
    List<AccommodationModel> dummyAccommodations = [
      AccommodationModel(
        idAlojamiento: '1',
        direccion: 'Calle 123, Bogotá',
        fotos: [
          "https://th.bing.com/th/id/R.752a118fa0183c370fe39671b3b72219?rik=I307Oo5cKCRfzA&pid=ImgRaw&r=0"
        ],
        ventajas: ['WiFi gratis', 'Cerca del transporte', 'Piscina'],
        price: 150000,
        descripcion: 'Casa cómoda en la playa con vista al mar.',
        numeroHabitaciones: 3,
        disponible: true,
        categoria: 'Casa',
        idPropietario: 'prop1',
      ),
      AccommodationModel(
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
      ),
      AccommodationModel(
        idAlojamiento: '3',
        direccion: 'Calle 50, Cartagena',
        fotos: [
          "https://th.bing.com/th/id/R.752a118fa0183c370fe39671b3b72219?rik=I307Oo5cKCRfzA&pid=ImgRaw&r=0"
        ],
        ventajas: ['Frente al mar', 'Zona de BBQ', 'Aire acondicionado'],
        price: 250000,
        descripcion: 'Casa de lujo en Cartagena con acceso privado a la playa.',
        numeroHabitaciones: 4,
        disponible: true,
        categoria: 'Casa de lujo',
        idPropietario: 'prop3',
      ),
      AccommodationModel(
        idAlojamiento: '4',
        direccion: 'Av. Caracas, Bogotá',
        fotos: [
          "https://th.bing.com/th/id/R.752a118fa0183c370fe39671b3b72219?rik=I307Oo5cKCRfzA&pid=ImgRaw&r=0"
        ],
        ventajas: ['Seguridad 24/7', 'Centro comercial cercano', 'Parqueadero'],
        price: 120000,
        descripcion: 'Habitación en apartaestudio con servicios incluidos.',
        numeroHabitaciones: 1,
        disponible: true,
        categoria: 'Apartaestudio',
        idPropietario: 'prop4',
      ),
      AccommodationModel(
        idAlojamiento: '5',
        direccion: 'El Poblado, Medellín',
        fotos: [
          "https://th.bing.com/th/id/R.752a118fa0183c370fe39671b3b72219?rik=I307Oo5cKCRfzA&pid=ImgRaw&r=0"
        ],
        ventajas: ['Jacuzzi', 'Smart TV', 'Cerca de bares y restaurantes'],
        price: 180000,
        descripcion: 'Loft moderno en una de las mejores zonas de Medellín.',
        numeroHabitaciones: 1,
        disponible: true,
        categoria: 'Loft',
        idPropietario: 'prop5',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          'Alojamientos registrados',
          style: GoogleFonts.saira(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: ListView.builder(
            itemCount: dummyAccommodations.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  AccommodationCard(
                    accommodation: dummyAccommodations[index],
                  ),
                ],
              );
            }),
      ),
      bottomNavigationBar: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          BottomNavigationBar(
            backgroundColor: AppColors.primary,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.hotel, color: Colors.white),
                label: 'Alojamiento',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person, color: Colors.white),
                label: 'Perfil',
              ),
            ],
            currentIndex: 0,
            onTap: (index) {},
          ),
          Positioned(
            bottom: 10, // Ajusta la altura para que resalte más
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/LandlordPage/Register');
              },
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                backgroundColor: AppColors.background,
                padding: const EdgeInsets.all(16), // Tamaño más grande
                elevation: 6, // Sombras para resaltar
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 28),
            ),
          ),
        ],
      ),
    );
  }
}
