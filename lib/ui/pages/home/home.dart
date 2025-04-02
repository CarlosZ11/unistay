import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unistay/domain/controllers/tenant_controller.dart';
import 'package:unistay/ui/widgets/accommodation_card.dart';
import '../../colors/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TenantController tenantController = Get.put(TenantController());
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    tenantController.getAccommodations(); // Cargar alojamientos al iniciar
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    String query = _searchController.text.trim();
    if (query.isEmpty) {
      tenantController.getAccommodations(); // Si no hay texto, cargar todo
    } else {
      tenantController.filterAccommodations(query);
    }
  }

  @override
  Widget build(BuildContext context) {
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
          // Barra de búsqueda
          SliverPersistentHeader(
            pinned: true,
            floating: false,
            delegate: _SearchBarDelegate(_searchController),
          ),
          // Lista de alojamientos
          Obx(() {
            if (tenantController.isLoading.value) {
              return const SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (tenantController.accommodations.isEmpty) {
              return const SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text("No se encontraron alojamientos"),
                  ),
                ),
              );
            }

            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => Column(
                  children: [
                    AccommodationCard(
                      accommodation: tenantController.accommodations[index],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
                childCount: tenantController.accommodations.length,
              ),
            );
          }),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.primary,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 2) {
            Navigator.pushNamed(context, '/userProfile');
          }
        },
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
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Alojamientos',
          ),
        ],
      ),
    );
  }
}

// Delegado para la barra de búsqueda
class _SearchBarDelegate extends SliverPersistentHeaderDelegate {
  final TextEditingController searchController;

  _SearchBarDelegate(this.searchController);

  @override
  double get minExtent => 60;
  @override
  double get maxExtent => 60;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(10),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(30),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            controller: searchController,
            decoration: const InputDecoration(
              hintText: "Buscar por dirección o categoría",
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
