import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unistay/ui/colors/colors.dart';

class MyAccountMenu extends StatelessWidget {
  final String labelText;
  final IconData prefixIcon;
  final TextEditingController? controller; // Agrega el controlador aquí
  final String? valueText;
  

  const MyAccountMenu({
    Key? key,
    required this.labelText,
    required this.prefixIcon,
    this.controller,
    this.valueText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 9),
      child: TextFormField(
        controller: controller,
        style: GoogleFonts.saira(fontSize: 15),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 15.0),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.background),
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder:  OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primary),
            borderRadius: BorderRadius.circular(10.0),
          ),
          prefixIcon: Icon(
            prefixIcon,
            color: AppColors.primary,
          ),
          labelText: labelText,
          labelStyle: GoogleFonts.saira(color: Colors.grey),
        ),
      ),
    );
  }
}
