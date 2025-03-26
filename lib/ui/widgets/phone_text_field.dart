import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hugeicons/hugeicons.dart';

import '../colors/colors.dart';

class PhoneTextFormField extends StatelessWidget {
  final TextEditingController controller;
  
  const PhoneTextFormField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(fontFamily: 'Montserrat', fontSize: 15),
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[200],
          contentPadding: const EdgeInsets.symmetric(vertical: 13.0),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xffADEAD6)),
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.primary),
            borderRadius: BorderRadius.circular(10.0),
          ),
          prefixIcon: const Icon(HugeIcons.strokeRoundedCall02, color: AppColors.primary),
          labelText: "Teléfono",
          labelStyle: const TextStyle(fontFamily: 'Montserrat', color: Colors.grey, fontSize: 14),
        ),
      ),
    );
  }
}