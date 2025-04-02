import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unistay/ui/colors/colors.dart';

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({Key? key, required this.text, required this.icon, this.press,}) : super(key: key);

  final String text;
  final IconData icon;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary, padding: EdgeInsets.all(20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: Colors.white,
        ),
        onPressed: press,
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.primary,
              size: 27,
            ),
            SizedBox(width: 20,),
            Expanded(
              child: Text(
                text,
                style: GoogleFonts.saira(
                  fontSize: 16,
                  color: Colors.black
                ),
              
              )
            ),
            Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }
}