import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:unistay/ui/colors/colors.dart';
import 'package:unistay/ui/pages/user/components/my_account_menu.dart';

class MyAccountBody extends StatefulWidget {

  const MyAccountBody({Key? key}) : super(key: key);

  @override
  State<MyAccountBody> createState() => _MyAccountBodyState();
}

class _MyAccountBodyState extends State<MyAccountBody> {

  final emailController = TextEditingController();
  final namecontroller = TextEditingController();
  final identificacioncontroller = TextEditingController();
  final celularcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: PreferredSize(
      //   preferredSize: const Size.fromHeight(kToolbarHeight),
      //   child: AppBar(
      //     centerTitle: true,
      //     title: const Text('Mi Cuenta'),
      //     backgroundColor: const Color(0xFF3C3F46),
      //     titleTextStyle: MyAccountBody.titleFonts,
      //   ),
      // ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 25),
              child: SizedBox(
                height: 125,
                width: 125,
                child: Stack(
                  fit: StackFit.expand,
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.background,
                          width: 4.0,
                        ),
                      ),
                      child: const CircleAvatar(
                        child: Icon(
                          HugeIcons.strokeRoundedUser,
                          size: 75,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 50,),
            MyAccountMenu(
              labelText: "Nombre",
              prefixIcon: HugeIcons.strokeRoundedUser02,
              valueText: '',
              controller: namecontroller,
            ),
            MyAccountMenu(
              labelText: "Apellido",
              prefixIcon: HugeIcons.strokeRoundedUser02,
              valueText: '',
              controller: namecontroller,
            ),
            MyAccountMenu(
              labelText: "Identificación",
              prefixIcon: HugeIcons.strokeRoundedIdentityCard,
              valueText: '',
              controller: identificacioncontroller,
            ),
            MyAccountMenu(
              labelText: "Celular",
              prefixIcon: HugeIcons.strokeRoundedSmartPhone01,
              valueText: '',
              controller: celularcontroller,
            ),
            const SizedBox(height: 50,),
            Container(
              height: 50,
              width: 400,
              margin: const EdgeInsets.symmetric(horizontal: 30,),
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Color.fromARGB(255, 0, 0, 0), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  backgroundColor: AppColors.primary,
                ),
                onPressed: () async {
                  
                },
                child: Text(
                  'Actualizar perfil',
                  style: GoogleFonts.saira(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
