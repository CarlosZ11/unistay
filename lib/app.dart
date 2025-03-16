import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unistay/ui/pages/auth/forgot_password.dart';
import 'package:unistay/ui/pages/auth/signin.dart';
import 'package:unistay/ui/pages/auth/signup.dart';
import 'package:unistay/ui/pages/welcome/welcome.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UniStay-App',
      initialRoute: '/WelcomePage',
      routes: {
        '/WelcomePage':(context) => const WelcomePage(),
        '/SignInPage':(context) => const LogInPage(),
        '/SignUpPage':(context) => const SignUpPage(),
        '/ForgotPasswordPage':(context) => const ForgotPassword(),
      },
    );
  }
}

