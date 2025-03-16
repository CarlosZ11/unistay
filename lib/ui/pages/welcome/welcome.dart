import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unistay/ui/colors/colors.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        // 
        color: const Color(0xff7886C7),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 60.0, left: 15.0, right: 15.0),
              child: Image(image: AssetImage('lib/assets/Logo.png')),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Bienvenido',
              style: GoogleFonts.saira(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
            ),
            Text(
              '¡Tu mejor opción en la busqueda de\ntu hogar!',
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
                height: 1.2
                
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(flex: 3,),
            Container(
              padding: const EdgeInsets.only(bottom:45, left: 30, right: 30),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/SignInPage');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff2D336B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9), // Borde menos ovalado
                    ),
                    padding: EdgeInsets.zero, // Elimina el padding interno
                  ),
                  child: Text(
                    'Inicia sesión o regístrate',
                    style: GoogleFonts.saira(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    )
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