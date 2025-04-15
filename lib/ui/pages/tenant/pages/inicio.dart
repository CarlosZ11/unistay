import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unistay/domain/controllers/ProfileController.dart';
import '../../../../domain/controllers/tenant_Controller.dart';
import '../../../colors/colors.dart';
import '../../../widgets/accommodation_card_tenant.dart';

class InicioInquilinoPage extends StatefulWidget {
  const InicioInquilinoPage({super.key});

  @override
  State<InicioInquilinoPage> createState() => _InicioInquilinoPageState();
}

class _InicioInquilinoPageState extends State<InicioInquilinoPage> {
  final TenantController tenantController = Get.put(TenantController());
  final TextEditingController _searchController = TextEditingController();
  late final ProfileController _profileController;
  Future<void> _onRefresh() async {
    await tenantController.getAccommodations(); // Recargar alojamientos
    await _profileController.loadUserProfile(); // Recargar perfil de usuario
  }

  @override
  void initState() {
    super.initState();
    _profileController = Get.find<ProfileController>();
    _profileController.loadUserProfile().then((_) =>
        _profileController.getFavorites(
            _profileController.user.value!.id)); // Cargar el usuario al iniciar
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
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              pinned: false,
              floating: false,
              delegate: _WelcomeBarDelegate(),
            ),
            // Barra de búsqueda
            SliverPersistentHeader(
              pinned: true,
              floating: false,
              delegate: _SearchBarDelegate(_searchController),
            ),
            SliverPersistentHeader(
              pinned: true,
              floating: false,
              delegate: _CategoryBarDelegate(),
            ),

            // Lista de alojamientos
            Obx(() {
              if (tenantController.isLoading.value) {
                return const SliverFillRemaining(
                  hasScrollBody:
                      false, // Para centrar correctamente el contenido
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.background),
                    ),
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
      ),
    );
  }
}

// Delegado para la bienvenida del usuario
class _WelcomeBarDelegate extends SliverPersistentHeaderDelegate {
  @override
  double get minExtent => 45;
  @override
  double get maxExtent => 45;

  final ProfileController _profileController = Get.find<ProfileController>();
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        "Hola, ${_profileController.user.value?.name} ${_profileController.user.value?.lastname} 👋",
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
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
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.only(top: 16, left: 14, right: 14),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            controller: searchController,
            decoration: const InputDecoration(
              hintText: "Buscar por nombre o direccion",
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

// Delegado para los filtros rapidos
class _CategoryBarDelegate extends SliverPersistentHeaderDelegate {
  @override
  double get minExtent => 60;
  @override
  double get maxExtent => 60;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.background, // fondo para que se vea bien sobre el scroll
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildCategoryButton(Icons.apartment, "Departamento"),
          _buildCategoryButton(Icons.house, "Casa"),
          _buildCategoryButton(Icons.bed, "Habitación"),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(IconData icon, String label) {
    return TextButton.icon(
      onPressed: () {
        // Acción del botón
      },
      icon: Icon(icon, color: AppColors.primary),
      label: Text(label, style: const TextStyle(color: AppColors.primary)),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: Colors.purple.shade50,
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
