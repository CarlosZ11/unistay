import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unistay/domain/controllers/landlord_controller.dart';
import 'package:unistay/ui/colors/colors.dart';
import 'package:unistay/ui/widgets/accommodation_card.dart';

class Landlord extends StatelessWidget {
  const Landlord({super.key});

  @override
  Widget build(BuildContext context) {
    final landlordController = Get.put(LandlordController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          'Alojamientos registrados',
          style: GoogleFonts.saira(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Obx(() {
        if (landlordController.accommodations.isEmpty) {
          return const Center(
            child: Text(
              "No hay alojamientos disponibles",
              style: TextStyle(fontSize: 18),
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
      }),
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
            bottom: 10,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/LandlordPage/Register');
              },
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                backgroundColor: AppColors.background,
                padding: const EdgeInsets.all(16),
                elevation: 6,
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 28),
            ),
          ),
        ],
      ),
    );
  }
}
