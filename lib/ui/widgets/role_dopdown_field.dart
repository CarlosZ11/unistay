import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:unistay/ui/colors/colors.dart';

class RoleDopdownField extends StatefulWidget {
  final ValueChanged<String?> onChanged;
  
  const RoleDopdownField({super.key, required this.onChanged});

  @override
  State<RoleDopdownField> createState() => _RoleDopdownFieldState();
}

class _RoleDopdownFieldState extends State<RoleDopdownField> {

  String? selectedRole;
  final List<String> roles = ["Inquilino", "Propietario"];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: DropdownButtonFormField<String>(
        value: selectedRole,
        style: GoogleFonts.montserrat(fontSize: 15, color: Colors.black),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[200],
          contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.primary),
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.primary),
            borderRadius: BorderRadius.circular(10.0),
          ),
          prefixIcon: const Icon(HugeIcons.strokeRoundedUserSwitch, color: AppColors.primary),
          labelText: "Selecciona tu rol",
          labelStyle: GoogleFonts.saira(color: AppColors.primary, fontSize: 16),
        ),
        items: roles.map((role) {
          return DropdownMenuItem<String>(
            value: role,
            child: Text(role, style: GoogleFonts.montserrat(fontSize: 15)),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedRole = value;
          });
          widget.onChanged(value);
        },
      ),
    );
  }
}