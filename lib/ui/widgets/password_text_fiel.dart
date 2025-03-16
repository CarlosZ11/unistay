import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../domain/controllers/text_controller.dart';

class PasswordTextField extends StatefulWidget {
  final Function(String) onPassChanged;

  const PasswordTextField({required this.onPassChanged});
  @override
  _PasswordTextFieldState createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  Controladores uc = Controladores();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xff2B0548))),
      ),
      child: TextField(
        controller: uc.mailcontroller,
        style: GoogleFonts.saira(fontSize: 16),
        onChanged: (pass) {
          widget.onPassChanged(pass);
        },
        decoration: InputDecoration(
          hintText: 'Contraseña',
          hintStyle: GoogleFonts.saira(color: Colors.grey),
          border: InputBorder.none,
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
        ),
        obscureText: _obscureText,
      ),
    );
  }
}
