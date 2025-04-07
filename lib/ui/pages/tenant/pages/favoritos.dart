import 'package:flutter/material.dart';

import '../../../colors/colors.dart';

class FavoritosInquilinoPage extends StatelessWidget {
  const FavoritosInquilinoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secundary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "FAVORITOS INQUILINO"
            ),
          ],
        ),
      ),
    );
  }
}