import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:unistay/ui/widgets/email_text_field.dart';
import 'package:unistay/ui/widgets/lastname_text_field.dart';
import 'package:unistay/ui/widgets/name_text_field.dart';
import 'package:unistay/ui/widgets/pass_text_field.dart';
import 'package:get/get.dart';
import 'package:unistay/domain/controllers/auth_controller.dart';
import 'package:unistay/ui/widgets/role_dopdown_field.dart';
import '../../colors/colors.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final lastnameController = TextEditingController();
  final idController = TextEditingController();
  final phoneController = TextEditingController();
  final AuthController authController = Get.put(AuthController());

  String? selectedRole; // Se almacena el rol seleccionado

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 8),
              child: Image.asset(
                'lib/assets/Logo1.png',
                width: 300,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      Text(
                        'Bienvenido',
                        style: GoogleFonts.saira(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          height: 1.2,
                        ),
                      ),
                      Text(
                        '¡Soy nuevo, registrar cuenta!',
                        style: GoogleFonts.saira(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 5),
                      NameTextFormField(controller: nameController),
                      LastnameTextFormField(controller: lastnameController),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 9),
                              child: TextFormField(
                                controller: idController,
                                style: GoogleFonts.montserrat(fontSize: 15),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 15.0),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: AppColors.primary),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: AppColors.primary),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  prefixIcon: const Icon(
                                    HugeIcons.strokeRoundedIdentityCard,
                                    color: AppColors.primary,
                                  ),
                                  labelText: "Identificación",
                                  labelStyle: GoogleFonts.saira(
                                    color: AppColors.primary,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 9),
                              child: TextFormField(
                                controller: phoneController,
                                style: GoogleFonts.montserrat(fontSize: 15),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 13.0),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: AppColors.primary),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: AppColors.primary),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  prefixIcon: const Icon(
                                    HugeIcons.strokeRoundedCall02,
                                    color: AppColors.primary,
                                  ),
                                  labelText: "Teléfono",
                                  labelStyle: GoogleFonts.saira(
                                    color: AppColors.primary,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      EmailTextFormField(controller: emailController),
                      PassTextFormField(
                        controller: passwordController,
                        labelText: "Contraseña",
                      ),
                      RoleDopdownField(
                        onChanged: (value) {
                          setState(() {
                            selectedRole = value;
                          });
                        },
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (selectedRole == null) {
                              Get.snackbar(
                                "Error",
                                "Por favor selecciona un rol",
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                              return;
                            }

                            authController.registerUser(
                              name: nameController.text.trim(),
                              lastname: lastnameController.text.trim(),
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                              phone: phoneController.text.trim(),
                              identification: idController.text.trim(),
                              role: selectedRole!,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Obx(
                            () => authController.isLoading.value
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : Text(
                                    'Crear cuenta',
                                    style: GoogleFonts.saira(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
