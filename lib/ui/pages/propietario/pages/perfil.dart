import 'package:flutter/material.dart';

import '../../../colors/colors.dart';

class PerfilPropietarioPage extends StatelessWidget {
  const PerfilPropietarioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secundary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "PERFIL PROPIETARIO"
            ),
          ],
        ),
      ),
    );
  }
}