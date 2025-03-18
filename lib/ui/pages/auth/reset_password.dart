import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unistay/domain/controllers/auth_controller.dart';
import 'package:unistay/ui/colors/colors.dart';
import 'package:unistay/ui/widgets/pass_text_field.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final AuthController _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Restablecer Contraseña',
                style: GoogleFonts.saira(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  height: 0.8,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              Text(
                'Ingresa y confirma tu nueva contraseña',
                style: GoogleFonts.saira(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              PassTextFormField(
                controller: _passwordController,
                labelText: "Nueva Contraseña",
              ),
              const SizedBox(height: 15),

              // Campo de Confirmar Contraseña
              PassTextFormField(
                controller: _confirmPasswordController,
                labelText: "Confirmar Contraseña",
              ),
              const SizedBox(height: 50),

              SizedBox(
                width: 400,
                height: 50,
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    backgroundColor: AppColors.primary,
                  ),
                  onPressed: () {
                    _authController.updatePassword(
                      _passwordController.text.trim(),
                      _confirmPasswordController.text.trim(),
                    );
                  },
                  child: Text(
                    'Restablecer Contraseña',
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
        ),
      ),
    );
  }
}
