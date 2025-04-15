import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unistay/data/services/deep_link_handler.dart';
import 'package:unistay/ui/colors/colors.dart';
import 'package:unistay/ui/pages/auth/reset_password.dart';
import 'package:unistay/ui/pages/auth/forgot_password.dart';
import 'package:unistay/ui/pages/auth/signin.dart';
import 'package:unistay/ui/pages/auth/signup.dart';
import 'package:unistay/ui/pages/owner/pages/properties.dart';
import 'package:unistay/ui/pages/owner/pages/registry_poperty.dart';
import 'package:unistay/ui/pages/tenant/pages/detalle_alojamiento.dart';
import 'package:unistay/ui/pages/tenant/pages/lista_comentarios.dart';
import 'package:unistay/ui/pages/welcome/welcome.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    DeepLinkHandler().initDeepLinkListener();

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.secundary,
        ),
      ),
      title: 'UniStay-App',
      initialRoute: '/WelcomePage',
      routes: {
        '/WelcomePage': (context) => const WelcomePage(),
        '/SignInPage': (context) => const LogInPage(),
        '/SignUpPage': (context) => const SignUpPage(),
        '/ForgotPasswordPage': (context) => const ForgotPassword(),
        '/ResetPasswordPage': (context) => const ResetPasswordPage(),
        '/properties': (context) => const PropertiesPage(),
        '/registerProperty': (context) => const RegistryPopertyPage(),
        '/detalleAlojamiento': (context) => DetalleAlojamiento(),
        '/listaComentarios': (context) => ComentariosPage(
            idAlojamiento:
                ModalRoute.of(context)!.settings.arguments as String),
      },
    );
  }
}
