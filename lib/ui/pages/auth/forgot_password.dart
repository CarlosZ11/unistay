import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unistay/domain/controllers/auth_controller.dart';
import 'package:unistay/ui/colors/colors.dart';
import 'package:unistay/ui/widgets/email_text_field.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  final TextEditingController _emailController = TextEditingController();
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
                  'Restablecimiento de contraseña',
                  style: GoogleFonts.saira(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    height: 0.8
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15,),
                Text(
                  '¡Ingrese su correo electrónico!',
                  style: GoogleFonts.saira(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10,),
                EmailTextFormField(controller: _emailController),
                const SizedBox(height: 50,),
                Container(
                  height: 50,
                  width: 400,
                  margin: const EdgeInsets.symmetric(horizontal: 30,),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Color.fromARGB(255, 255, 255, 255), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      backgroundColor: AppColors.primary,
                    ),
                    onPressed: () async {
                      _authController.forgotPassword(_emailController.text.trim());
                    },
                    child: Text(
                      'Restablecer contraseña',
                      style: GoogleFonts.saira(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}