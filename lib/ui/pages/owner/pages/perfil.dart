import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:unistay/ui/pages/owner/components/my_account_body.dart';
import 'package:unistay/ui/pages/owner/components/profile_menu.dart';

import '../../../../domain/controllers/auth_controller.dart';
import '../../../colors/colors.dart';

class PerfilPropietarioPage extends StatelessWidget {
  const PerfilPropietarioPage({super.key});

  @override
  Widget build(BuildContext context) {

      final AuthController _authController = AuthController();

    return Scaffold(
      backgroundColor: AppColors.secundary,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
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
                          HugeIcons.strokeRoundedUser,
                          size: 75,
                        ),
                      ),
                    ),
                    
                  ],
                ),
              ),
            ),
            const SizedBox(height: 50,),
            ProfileMenu(
              text: "Mi Cuenta",
              icon: HugeIcons.strokeRoundedUser,
              press: () => {Navigator.push(context, MaterialPageRoute(builder: (context) => MyAccountBody()))},
            ),
            ProfileMenu(
              text: "Cerrar Sesión",
              icon: HugeIcons.strokeRoundedLogout03,
              press: () async {
                await _authController.logoutUser();
                // Navigator.of(context).pushReplacementNamed('/WelcomePage');
              }
            ),
          ],
        )
      ),
    );
  }
}