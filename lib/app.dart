import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unistay/data/services/deep_link_handler.dart';
import 'package:unistay/ui/colors/colors.dart';
import 'package:unistay/ui/pages/auth/reset_password.dart';
import 'package:unistay/ui/pages/auth/forgot_password.dart';
import 'package:unistay/ui/pages/auth/signin.dart';
import 'package:unistay/ui/pages/auth/signup.dart';
import 'package:unistay/ui/pages/home/home.dart';
import 'package:unistay/ui/pages/landlord/landlord.dart';
import 'package:unistay/ui/pages/landlord/landlord_register.dart';
import 'package:unistay/ui/pages/user/profile.dart';
import 'package:unistay/ui/pages/welcome/welcome.dart';
import 'package:unistay/ui/pages/home/accommodation_details.dart';

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
      initialRoute: '/HomePage',
      routes: {
        '/WelcomePage': (context) => const WelcomePage(),
        '/SignInPage': (context) => const LogInPage(),
        '/SignUpPage': (context) => const SignUpPage(),
        '/ForgotPasswordPage': (context) => const ForgotPassword(),
        '/ResetPasswordPage': (context) => const ResetPasswordPage(),
        '/HomePage': (context) => const HomePage(),
        '/LandlordPage': (context) => const Landlord(),
        '/LandlordPage/Register': (context) => RegisterLandlordPage(),
        '/userProfile': (context) => MyAccountBody(),
        '/AccommodationDetailsPage': (context) => const Accommodationdetails(),
      },
    );
  }
}
