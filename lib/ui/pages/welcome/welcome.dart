import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
            Container(
              padding: const EdgeInsets.only(top:20, left: 30, right: 30),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/LogInPage');
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
            const SizedBox(height: 40,),
            Text(
              'Acceso rápido con',
              style: GoogleFonts.saira(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color(0xff2B0548),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top:20, left: 30, right: 30),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9), // Borde menos ovalado
                    ),
                    padding: EdgeInsets.zero, // Elimina el padding interno
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Image(
                        image: AssetImage('lib/assets/google.png'),
                        fit: BoxFit.contain,
                        width: 30,
                        height: 30,
                      ),
                      const SizedBox(width: 18,),
                      Text(
                        'Google',
                        style: GoogleFonts.saira(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff2D336B),
                        )
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