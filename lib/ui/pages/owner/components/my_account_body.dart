import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:unistay/ui/colors/colors.dart';
import 'package:unistay/ui/pages/tenant/components/my_account_menu.dart';
import 'package:unistay/domain/controllers/ProfileController.dart';

class MyAccountBody extends StatelessWidget {
  MyAccountBody({Key? key}) : super(key: key);

  final ProfileController _controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Mi Cuenta"),
        titleTextStyle: GoogleFonts.saira(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22),
        backgroundColor: AppColors.background,
      ),
      body: Obx(() {
        if (_controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = _controller.user.value;
        if (user == null) {
          return const Center(
              child: Text("No se encontró información del usuario"));
        }

        // Controladores con valores actuales
        final nameController = TextEditingController(text: user.name);
        final lastnameController = TextEditingController(text: user.lastname);
        final idController = TextEditingController(text: user.identification);
        final phoneController = TextEditingController(text: user.phone);

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: SizedBox(
                  height: 125,
                  width: 125,
                  child: Stack(
                    fit: StackFit.expand,
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.background,
                            width: 4.0,
                          ),
                        ),
                        child: const CircleAvatar(
                          child: Icon(
                            HugeIcons.strokeRoundedUserEdit01,
                            size: 75,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 50),

              // Campos de entrada
              MyAccountMenu(
                labelText: "Nombre",
                prefixIcon: HugeIcons.strokeRoundedUser02,
                valueText: user.name,
                controller: nameController,
              ),
              MyAccountMenu(
                labelText: "Apellido",
                prefixIcon: HugeIcons.strokeRoundedUser02,
                valueText: user.lastname,
                controller: lastnameController,
              ),
              MyAccountMenu(
                labelText: "Identificación",
                prefixIcon: HugeIcons.strokeRoundedIdentityCard,
                valueText: user.identification,
                controller: idController,
              ),
              MyAccountMenu(
                labelText: "Celular",
                prefixIcon: HugeIcons.strokeRoundedSmartPhone01,
                valueText: user.phone,
                controller: phoneController,
              ),

              const SizedBox(height: 50),

              // Botón de actualización
              Container(
                height: 50,
                width: 400,
                margin: const EdgeInsets.symmetric(horizontal: 30),
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    backgroundColor: AppColors.primary,
                  ),
                  onPressed: () {
                    _controller.updateProfile(
                      name: nameController.text,
                      lastname: lastnameController.text,
                      phone: phoneController.text,
                      identification: idController.text,
                    );
                  },
                  child: Text(
                    'Actualizar perfil',
                    style: GoogleFonts.saira(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
