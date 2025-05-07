import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unistay/domain/controllers/profile_controller.dart';
import '../../../../domain/controllers/tenant_controller.dart';
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
  String selectedCategory = '';

  Future<void> _onRefresh() async {
    await tenantController.fetchAccommodations();
    await _profileController.loadUserProfile();
  }

  @override
  void initState() {
    super.initState();
    _profileController = Get.find<ProfileController>();
    _profileController.loadUserProfile().then((_) =>
        _profileController.getFavorites(_profileController.user.value!.id));
    tenantController.fetchAccommodations();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    String query = _searchController.text.trim();
    if (query.isEmpty) {
      tenantController.fetchAccommodations();
    } else {
      tenantController.fetchFilteredAccommodations(query: query);
    }
  }

  void _onCategorySelected(String category) {
    setState(() {
      selectedCategory = category;
    });
    tenantController.fetchAccommodationsByCategory(selectedCategory);
  }

  void _showRatingFilterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Elija la calificación que desea filtrar',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(5, (index) {
                    int rating = 5 - index;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          tenantController.filterAccommodationsByRating(rating);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.purple.shade50,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.primary),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.star,
                                  color: Colors.amber, size: 20),
                              const SizedBox(width: 4),
                              Text(
                                '$rating',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        );
      },
    );
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
            SliverPersistentHeader(
              pinned: true,
              floating: false,
              delegate: _SearchBarDelegate(_searchController),
            ),
            SliverPersistentHeader(
              pinned: true,
              floating: false,
              delegate: _CategoryBarDelegate(
                selectedCategory: selectedCategory,
                onCategorySelected: _onCategorySelected,
                onRatingFilterPressed: () => _showRatingFilterModal(context),
              ),
            ),
            Obx(() {
              if (tenantController.isLoading.value) {
                return const SliverFillRemaining(
                  hasScrollBody: false,
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

// Delegado para los filtros rápidos
class _CategoryBarDelegate extends SliverPersistentHeaderDelegate {
  final String selectedCategory;
  final Function(String) onCategorySelected;
  final VoidCallback onRatingFilterPressed;

  _CategoryBarDelegate({
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.onRatingFilterPressed,
  });

  @override
  double get minExtent => 60;
  @override
  double get maxExtent => 60;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildCategoryButton(Icons.apartment, "Departamento"),
            _buildCategoryButton(Icons.house, "Casa Estudio"),
            _buildCategoryButton(Icons.bed, "Habitación"),
            _buildRatingFilterButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButton(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextButton.icon(
        onPressed: () {
          onCategorySelected(label);
        },
        icon: Icon(icon, color: AppColors.primary),
        label: Text(label, style: const TextStyle(color: AppColors.primary)),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: selectedCategory == label
              ? Colors.purple.shade200
              : Colors.purple.shade50,
        ),
      ),
    );
  }

  Widget _buildRatingFilterButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextButton.icon(
        onPressed: onRatingFilterPressed,
        icon: const Icon(Icons.star, color: AppColors.primary),
        label: const Text("Calificación",
            style: TextStyle(color: AppColors.primary)),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.purple.shade50,
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
