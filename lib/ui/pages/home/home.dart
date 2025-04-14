import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unistay/ui/colors/colors.dart';
import 'package:unistay/ui/pages/tenant/pages/alojamientos.dart';
import 'package:unistay/ui/pages/tenant/pages/favoritos.dart';
import 'package:unistay/ui/pages/tenant/pages/inicio.dart';
import 'package:unistay/ui/pages/tenant/pages/perfil.dart';
import 'package:unistay/ui/pages/owner/pages/perfil.dart';
import 'package:unistay/ui/pages/owner/pages/properties.dart';
import 'package:unistay/ui/pages/owner/pages/registry_poperty.dart';
import '../../../domain/models/user_role.dart';
import '../../widgets/botton_navigation_bar.dart';

class HomePage extends StatefulWidget {
  final UserRole role;

  HomePage({super.key, required this.role});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final Map<UserRole, List<Widget>> _screens = {
    UserRole.inquilino: [
      InicioInquilinoPage(),
      FavoritosInquilinoPage(),
      AlojamientosInquilinoPage(),
      PerfilInquilinoPage()
    ],
    UserRole.propietario: [
      PropertiesPage(),
      RegistryPopertyPage(),
      PerfilPropietarioPage()
    ],
  };

  final Map<UserRole, List<String>> _titles = {
    UserRole.inquilino: ["Unistay", "Favoritos", "Mi Alquiler", "Perfil"],
    UserRole.propietario: ["Inmuebles", "Añadir Inmueble", "Perfil"],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(_titles[widget.role]![_currentIndex]),
        titleTextStyle: GoogleFonts.saira(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22),
        backgroundColor: AppColors.background,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens[widget.role]!,
      ),
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
