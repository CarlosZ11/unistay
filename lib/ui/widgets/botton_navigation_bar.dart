import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:unistay/domain/models/user_role.dart';
import '../colors/colors.dart';

class RoleBasedNavigationBar extends StatelessWidget {
  final UserRole role;
  final int currentIndex;
  final Function(int) onTap;

  const RoleBasedNavigationBar({
    super.key,
    required this.role,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    List<NavigationDestination> getNavItems() {
      switch (role) {
        case UserRole.inquilino:
          return [
            const NavigationDestination(icon: Icon(HugeIcons.strokeRoundedHome04), label: "Inicio"),
            const NavigationDestination(icon: Icon(HugeIcons.strokeRoundedMapsSquare02), label: "Ubicaciones"),
            const NavigationDestination(icon: Icon(HugeIcons.strokeRoundedFavourite), label: "Fvoritos"),
            const NavigationDestination(icon: Icon(HugeIcons.strokeRoundedUserList), label: "Perfil"),
          ];
        case UserRole.propietario:
          return [
            const NavigationDestination(
                icon: Icon(HugeIcons.strokeRoundedPermanentJob),
                label: "Inmuebles"),
            const NavigationDestination(
                icon: Icon(HugeIcons.strokeRoundedStoreAdd02), label: "Añadir"),
            const NavigationDestination(
                icon: Icon(HugeIcons.strokeRoundedUser), label: "Usuario"),
          ];
      }
    }

    return NavigationBarTheme(
      data: NavigationBarThemeData(
        labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
          (Set<WidgetState> states) {
            return GoogleFonts.saira(
              color: states.contains(WidgetState.selected)
                  ? AppColors.primary
                  : AppColors.tertiary,
              fontWeight: states.contains(WidgetState.selected)
                  ? FontWeight.bold
                  : FontWeight.normal,
              fontSize: states.contains(WidgetState.selected) ? 14 : 12,
            );
          },
        ),
        iconTheme: WidgetStateProperty.resolveWith<IconThemeData>(
          (Set<WidgetState> states) {
            return IconThemeData(
              color: states.contains(WidgetState.selected)
                  ? AppColors.primary
                  : AppColors.tertiary,
              size: states.contains(WidgetState.selected) ? 28 : 24,
            );
          },
        ),
      ),
      child: NavigationBar(
        height: 70,
        elevation: 0,
        backgroundColor: Colors.white,
        indicatorColor: AppColors.secundary,
        selectedIndex: currentIndex,
        onDestinationSelected: onTap,
        destinations: getNavItems(),
      ),
    );
  }
}
