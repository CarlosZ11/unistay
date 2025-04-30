import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unistay/ui/widgets/accommodation_card_owner.dart';
import '../../../../domain/controllers/owner_controller.dart';
import '../../../colors/colors.dart';

class PropertiesPage extends StatefulWidget {
  const PropertiesPage({super.key});

  @override
  State<PropertiesPage> createState() => _PropertiesPageState();
}

class _PropertiesPageState extends State<PropertiesPage> {
  final ownerController = Get.find<OwnerController>();
  @override
  void initState() {
    super.initState();
    ownerController.loadLandlordAccommodations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secundary,
      body: Obx(() {
        if (ownerController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (ownerController.accommodations.isEmpty) {
          return Center(
            child: Text(
              "No hay alojamientos disponibles",
              style: GoogleFonts.saira(fontSize: 18),
            ),
          );
        }

        return ListView.builder(
          itemCount: ownerController.accommodations.length,
          itemBuilder: (context, index) {
            final accommodation = ownerController.accommodations[index];
            return Column(
              children: [
                const SizedBox(height: 10),
                AccommodationOwnerCard(
                  accommodation: accommodation,
                  onDelete: () async {
                    bool confirmDelete = await Get.defaultDialog(
                      title: "Confirmación",
                      titleStyle: GoogleFonts.saira(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                      middleText:
                          "¿Estás seguro de que deseas eliminar este alojamiento?",
                      middleTextStyle: GoogleFonts.saira(
                        color: Colors.black87,
                        fontSize: 16,
                      ),
                      textConfirm: "Sí",
                      textCancel: "No",
                      confirmTextColor: Colors.white,
                      onConfirm: () => Get.back(result: true),
                      onCancel: () => Get.back(result: false),
                      buttonColor: AppColors.primary,
                      cancelTextColor: AppColors.primary,
                    );

                    if (confirmDelete) {
                      await ownerController
                          .deleteAccommodation(accommodation.idAlojamiento);
                    }
                  },
                ),
              ],
            );
          },
        );
      }),
    );
  }
}
