import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unistay/ui/colors/colors.dart';
import 'package:unistay/ui/widgets/email_text_field.dart';

import '../../widgets/pass_text_field.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0,),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset('lib/assets/Logo.png', width: 300,),
            const SizedBox(height: 15,),
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
                          height: 1.2
                        ),
                      ),
                      Text(
                        '¡Tu mejor opción en la busqueda de tu hogar!',
                        style: GoogleFonts.saira(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 25,),
                      EmailTextFormField(controller: emailController),
                      const SizedBox(height: 20),
                      PassTextFormField(controller: passwordController),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/ForgotPasswordPage');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.background,
                            shadowColor: AppColors.secundary,
                            overlayColor: AppColors.primary,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 5),
                          ),
                          child: Text(
                            '¿Olvidaste tu contraseña?',
                            style: GoogleFonts.saira(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            // login();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Iniciar sesión',
                            style: GoogleFonts.saira(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'No tengo una cuenta ',
                    style: GoogleFonts.saira(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/SignUpPage');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.background,
                      shadowColor: AppColors.secundary,
                      overlayColor: AppColors.primary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                    ),
                    child: Text(
                      'Regístrate',
                      style: GoogleFonts.saira(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}