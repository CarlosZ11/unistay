import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:unistay/domain/controllers/ProfileController.dart';
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
    if (_profileController.favorites.isEmpty) {
      _profileController.getFavorites(_profileController.user.value!.id);
    }

    super.initState();
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
                () => ListView.builder(
                  itemCount: _profileController.favorites.length,
                  itemBuilder: (context, index) {
                    final apto = _profileController.favorites[index];
                    return Padding(
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
                          leading: Image.network(apto.fotos[0],
                              width: 80, fit: BoxFit.cover),
                          title: const Text("titulo",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(HugeIcons.strokeRoundedLocation05,
                                      size: 14, color: AppColors.primary),
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
                                  _profileController.removeFavorite(
                                      _profileController.user.value!.id,
                                      apto.idAlojamiento);
                                  _profileController.getFavorites(
                                      _profileController.user.value!.id);
                                },
                              ),
                              // Icon(HugeIcons.strokeRoundedDelete02, color: Colors.amber, size: 22),
                              // Text(apto['rating'].toString(), style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
