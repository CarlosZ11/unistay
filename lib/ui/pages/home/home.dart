import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unistay/domain/controllers/owner_controller.dart';
import 'package:unistay/ui/colors/colors.dart';
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
  final OwnerController _controller = Get.find<OwnerController>();
  int _currentIndex = 0;

  final Map<UserRole, List<Widget>> _screens = {
    UserRole.inquilino: [
      InicioInquilinoPage(),
      FavoritosInquilinoPage(),
      PerfilInquilinoPage()
    ],
    UserRole.propietario: [
      PropertiesPage(),
      RegistryPopertyPage(),
      PerfilPropietarioPage()
    ],
  };

  final Map<UserRole, List<String>> _titles = {
    UserRole.inquilino: ["Unistay", "Favoritos", "Perfil"],
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
          // Si el usuario es propietario y está entrando a "Añadir Inmueble"
          if (widget.role == UserRole.propietario && index == 1) {
            _controller.resetAddAccommodationForm();
          }
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
