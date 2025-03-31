import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unistay/domain/models/accommodation_model.dart';
import 'package:unistay/ui/widgets/accommodation_card.dart';
import '../../colors/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      body: CustomScrollView(
        slivers: [
          // SliverAppBar con imagen de fondo
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.background,
            flexibleSpace: FlexibleSpaceBar(
              title: Text("Encuentra tu hogar ideal",
                  style: GoogleFonts.saira(
                      color: Colors.black, fontWeight: FontWeight.bold)),
              background: Image.network(
                "https://th.bing.com/th/id/OIP.h_tIBnX6AVBbVX4QOoccuwHaUS?rs=1&pid=ImgDetMain",
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Barra de búsqueda que se mantiene fija
          SliverPersistentHeader(
            pinned: true,
            floating: false,
            delegate: _SearchBarDelegate(),
          ),
          // Lista de elementos
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => Column(
                children: [
                  AccommodationCard(
                    accommodation: dummyAccommodations[index],
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
              childCount: dummyAccommodations.length,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.primary, // Fondo del BottomNavigationBar
        selectedItemColor:
            Colors.white, // Color de íconos y texto seleccionados
        unselectedItemColor:
            Colors.white, // Color de íconos y texto no seleccionados
        type: BottomNavigationBarType
            .fixed, // Para evitar efecto de desvanecimiento en los ítems
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Buscar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_rounded),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

// Delegado para la barra de búsqueda
class _SearchBarDelegate extends SliverPersistentHeaderDelegate {
  @override
  double get minExtent => 60; // Altura mínima
  @override
  double get maxExtent => 60; // Altura máxima

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(10),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(30),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            decoration: InputDecoration(
              hintText: "Buscar...",
              border: InputBorder.none,
              icon: Icon(Icons.search),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(_SearchBarDelegate oldDelegate) => false;
}
