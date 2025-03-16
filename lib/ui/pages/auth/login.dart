import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unistay/ui/widgets/email_text_field.dart';
import 'package:unistay/ui/widgets/password_text_fiel.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: const Color(0xff7886C7),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 10,),
            const Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Image(image: AssetImage('lib/assets/Logo.png')),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40), 
                    topRight: Radius.circular(40)
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xff2B0548),
                      offset: Offset(0, 3),
                      blurRadius: 15,
                      spreadRadius: 0,
                    )
                  ]
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Bienvenido',
                                style: GoogleFonts.saira(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xff0ACF83),
                                ),
                              ),
                              Text(
                                'Tu lugar, tu tranquilidad',
                                style: GoogleFonts.saira(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xff2B0548),
                                  height: 0.8
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 20,),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: <Widget>[
                              // const SizedBox(height: 20,),
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color.fromRGBO(10, 207, 131, .3),
                                      blurRadius: 20,
                                      offset: Offset(0, 10)
                                    )
                                  ]
                                ),
                                child: Column(
                                  children: <Widget>[
                                    EmailTextField(
                                      onEmailChanged: (newEmail) {
                                        setState(() {
                                          // email = newEmail;
                                        });
                                      },
                                    ),
                                    PasswordTextField(
                                      onPassChanged: (newPass) {
                                        setState(() {
                                          // password = newPass;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 15,),
                              TextButton(
                                onPressed: () {
                                  // Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPassword()));
                                },
                                child: Text(
                                  '¿Olvidaste tu contraseña?',
                                  style: GoogleFonts.saira(
                                    color: Colors.grey
                                  ),
                                ),
                              ),
                              const SizedBox(height:15,),
                              GestureDetector(
                                onTap: () async {
                                  // User? user = await emailAuth.signInWithEmailAndPassword(email, password);
                                  // if ( user != null) {
                                  //   Navigator.of(context).pushReplacementNamed('/Home');
                                  // } else {
                                  //   Get.snackbar(
                                  //     'Credenciales incorrectas',
                                  //     'Verifique que sus credenciales entén correctas',
                                  //     snackPosition: SnackPosition.BOTTOM,
                                  //     backgroundColor: const Color(0xFFff6961),
                                  //       colorText: Colors.white, 
                                  //       borderRadius: 10,
                                  //       margin: const EdgeInsets.all(10), 
                                  //       duration:
                                  //           const Duration(seconds: 3),
                                  //       isDismissible:
                                  //           true,
                                  //       dismissDirection:
                                  //           DismissDirection.vertical,
                                  //       forwardAnimationCurve:
                                  //           Curves.easeOutBack,
                                  //       reverseAnimationCurve:
                                  //           Curves.easeInOutBack, 
                                  //   );
                                  // }
                                },
                                child: Container(
                                  height: 50,
                                  margin: const EdgeInsets.symmetric(horizontal: 50),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    gradient: const RadialGradient(
                                      colors: [
                                        Color(0xff2B0548),
                                        Color(0xff0A0A0A),
                                      ],
                                      center: Alignment.center,
                                      radius: 5.0,
                                    )
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Iniciar sesión',
                                      style: GoogleFonts.saira(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white
                                      ),
                                    ),
                                  ),
                                )
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}