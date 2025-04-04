import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import '../colors/colors.dart';

class PassTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText; // Nuevo parámetro

  const PassTextFormField({super.key, required this.controller, required this.labelText});

  @override
  _PassTextFormFieldState createState() => _PassTextFormFieldState();
}

class _PassTextFormFieldState extends State<PassTextFormField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: TextFormField(
        controller: widget.controller,
        style: GoogleFonts.montserrat(fontSize: 15),
        obscureText: _obscureText,
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
          prefixIcon: const Icon(HugeIcons.strokeRoundedSquareLockPassword, color: AppColors.primary),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText ? HugeIcons.strokeRoundedViewOff : HugeIcons.strokeRoundedView,
              color: _obscureText ? Colors.grey : AppColors.primary,
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
          labelText: widget.labelText, // Usa el label proporcionado
          labelStyle: GoogleFonts.saira(color: AppColors.primary, fontSize: 16),
        ),
      ),
    );
  }
}
