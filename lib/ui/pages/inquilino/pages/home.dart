import 'package:flutter/material.dart';
import 'package:unistay/ui/pages/inquilino/pages/alojamientos.dart';
import 'package:unistay/ui/pages/inquilino/pages/favoritos.dart';
import 'package:unistay/ui/pages/inquilino/pages/inicio.dart';
import 'package:unistay/ui/pages/inquilino/pages/perfil.dart';

import '../../../../domain/models/user_role.dart';
import '../../../widgets/botton_navigation_bar.dart';

class HomeInquilinoPage extends StatefulWidget {

  final UserRole role;

  const HomeInquilinoPage({super.key, required this.role});

  @override
  State<HomeInquilinoPage> createState() => _HomeInquilinoPageState();
}

class _HomeInquilinoPageState extends State<HomeInquilinoPage> {

  int _currentIndex = 0;

  final Map<UserRole, List<Widget>> _screens = {
    UserRole.propietario: [InicioInquilinoPage(), FavoritosInquilinoPage(), AlojamientosInquilinoPage(), PerfilInquilinoPage()],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[widget.role]![_currentIndex],
      bottomNavigationBar: RoleBasedNavigationBar(
        role: widget.role,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}