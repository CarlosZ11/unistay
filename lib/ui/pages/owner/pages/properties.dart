import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../domain/controllers/landlord_controller.dart';
import '../../../colors/colors.dart';
import '../../../widgets/accommodation_card.dart';

class PropertiesPage extends StatelessWidget {
  const PropertiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final landlordController = Get.put(LandlordController());

    return Scaffold(
        backgroundColor: AppColors.secundary,
        body: Obx(() {
          if (landlordController.accommodations.isEmpty) {
            return Center(
              child: Text(
                "No hay alojamientos disponibles",
                style: GoogleFonts.saira(fontSize: 18),
              ),
            );
          }
          return ListView.builder(
            itemCount: landlordController.accommodations.length,
            itemBuilder: (context, index) {
              final accommodation = landlordController.accommodations[index];
              return Column(
                children: [
                  const SizedBox(height: 10),
                  AccommodationCard(
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
                        await landlordController
                            .deleteAccommodation(accommodation.idAlojamiento);
                      }
                    },
                  ),
                ],
              );
            },
          );
        }));
  }
}
