import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

import '../colors/colors.dart';

class LastnameTextFormField extends StatelessWidget {
  final TextEditingController controller;
  
  const LastnameTextFormField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: TextFormField(
        controller: controller,
        style: GoogleFonts.montserrat(fontSize: 15),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[200],
          contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.primary),
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.primary),
            borderRadius: BorderRadius.circular(10.0),
          ),
          prefixIcon: const Icon(HugeIcons.strokeRoundedUser, color: AppColors.primary),
          labelText: "Apellido",
          labelStyle: GoogleFonts.saira(color: AppColors.primary, fontSize: 16),
        ),
      ),
    );
  }
}