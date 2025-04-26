import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:unistay/domain/controllers/profile_controller.dart';
import 'package:get/get.dart';
import '../../../colors/colors.dart';

class FavoritosInquilinoPage extends StatefulWidget {
  FavoritosInquilinoPage({super.key});

  @override
  State<FavoritosInquilinoPage> createState() => _FavoritosInquilinoPageState();
}

class _FavoritosInquilinoPageState extends State<FavoritosInquilinoPage> {
  final ProfileController _profileController = Get.find<ProfileController>();

  @override
  void initState() {
    super.initState();

    // Asegúrate de que el usuario esté cargado antes de hacer la llamada
    if (_profileController.user.value != null &&
        _profileController.favorites.isEmpty) {
      _profileController.getFavorites(_profileController.user.value!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(
              child: Obx(
                () {
                  // Verificar si favorites está vacío antes de mostrar la lista
                  if (_profileController.favorites.isEmpty) {
                    return const Center(
                      child: Text('No tienes favoritos guardados.'),
                    );
                  }

                  return ListView.builder(
                    itemCount: _profileController.favorites.length,
                    itemBuilder: (context, index) {
                      final apto = _profileController.favorites[index];
                      return GestureDetector(
                        onTap: () {
                          Get.toNamed('/detalleAlojamiento', arguments: apto);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 9, vertical: 7),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.only(
                                  top: 5, bottom: 5, right: 10, left: 8),
                              leading: Image.network(
                                  apto.fotos.isNotEmpty
                                      ? apto.fotos[0]
                                      : '', // Verificar que la lista de fotos no esté vacía
                                  width: 80,
                                  fit: BoxFit.cover),
                              title: Text(apto.nombre,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                          HugeIcons.strokeRoundedLocation05,
                                          size: 14,
                                          color: AppColors.primary),
                                      const SizedBox(width: 4),
                                      Text(apto.direccion),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(apto.price.toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                        HugeIcons.strokeRoundedDelete02,
                                        color: Colors.red,
                                        size: 22),
                                    onPressed: () {
                                      if (_profileController.user.value !=
                                          null) {
                                        _profileController.removeFavorite(
                                            _profileController.user.value!.id,
                                            apto.idAlojamiento);
                                        _profileController.getFavorites(
                                            _profileController.user.value!.id);
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
