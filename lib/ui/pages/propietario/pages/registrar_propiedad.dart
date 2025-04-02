import 'package:flutter/material.dart';

import '../../../colors/colors.dart';

class RegistrarPropiedadPage extends StatelessWidget {
  const RegistrarPropiedadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secundary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "REGISTRAR PROPIEDAD"
            ),
          ],
        ),
      ),
    );
  }
}