import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:unistay/ui/colors/colors.dart';
import 'package:unistay/ui/pages/home/home.dart';
import '../../data/services/auth_service.dart';
import '../../domain/models/user_role.dart';

class Splash extends StatefulWidget {
  final String userId;
  Splash({super.key, required this.userId});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    // Mostrar el Splash Screen mientras carga el rol
    await Future.delayed(const Duration(seconds: 2));

    AuthService authService = AuthService();
    UserRole? role = await authService.getUserRole(widget.userId);

    if (role != null) {
      Get.offAll(() => HomePage(role: role)); // Ir a Home con el rol cargado
    } else {
      Get.snackbar(
        'Error',
        'No se pudo obtener el rol del usuario',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFff6961),
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: AppColors.background,
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(image: AssetImage('lib/assets/Logo1.png')),
                // SpinKitCircle(color: Colors.deepPurple, size: 60.0,),
                SpinKitThreeBounce(color: AppColors.primary, duration: Duration(seconds: 3),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}