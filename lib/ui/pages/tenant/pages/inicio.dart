import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../domain/controllers/tenant_Controller.dart';
import '../../../colors/colors.dart';
import '../../../widgets/accommodation_card.dart';

class InicioInquilinoPage extends StatefulWidget {
  const InicioInquilinoPage({super.key});

  @override
  State<InicioInquilinoPage> createState() => _InicioInquilinoPageState();
}

class _InicioInquilinoPageState extends State<InicioInquilinoPage> {
  
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
          // Barra de búsqueda
          SliverPersistentHeader(
            pinned: true,
            floating: false,
            delegate: _SearchBarDelegate(_searchController),
          ),
          // Lista de alojamientos
          Obx(() {
            if (tenantController.isLoading.value) {
              return const SliverFillRemaining(
                hasScrollBody: false, // Para centrar correctamente el contenido
                child: Center(
                  child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.background),),
                ),
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
      padding: const EdgeInsets.only(top: 16, left: 14, right: 14),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(10),
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
