import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../domain/controllers/text_controller.dart';

class EmailTextField extends StatefulWidget {
  final Function(String) onEmailChanged;

  const EmailTextField({super.key, required this.onEmailChanged});
  @override
  State<EmailTextField> createState() => _EmailTextFieldState();
}

class _EmailTextFieldState extends State<EmailTextField> {
  Controladores uc = Controladores();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xff2B0548))),
      ),
      child: TextFormField(
        controller: uc.mailcontroller,
        style: GoogleFonts.saira(fontSize: 16),
        onChanged: (email) {
          widget.onEmailChanged(email);
        },
        decoration: InputDecoration(
          hintText: 'Correo electrónico',
          hintStyle: GoogleFonts.saira(color: Colors.grey),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
