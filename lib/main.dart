import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unistay/app.dart';
import 'package:unistay/data/services/deep_link_handler.dart';
import 'package:get/get.dart';
import 'package:unistay/domain/controllers/auth_controller.dart';
import 'package:unistay/domain/controllers/owner_controller.dart';
import 'package:unistay/domain/controllers/profile_controller.dart';
import 'package:unistay/domain/controllers/tenant_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // MapboxOptions.setAccessToken(
  //   "pk.eyJ1IjoiY21pZ3VlbHphbWJyYW5vIiwiYSI6ImNtN3Z2cnA4bDAwamcybG9vY2xyeDliYnUifQ.gQHCzZb6IHkYMNme-ezbiQ"
  // );

  await Supabase.initialize(
    url: 'https://nzjcvaqyqtnvtnsrelvw.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im56amN2YXF5cXRudnRuc3JlbHZ3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDIxNDM3MDMsImV4cCI6MjA1NzcxOTcwM30.uHp81vNUDfjjUX7lxLMMnsb-GRx8ficUjUcqt-wYNjw',
  );

// Inicializa el manejador de Deep Links
  DeepLinkHandler().initDeepLinkListener();
  Get.put(AuthController());

  runApp(const MyApp());
  Get.lazyPut(() => ProfileController());
  Get.lazyPut(() => OwnerController());
  Get.lazyPut(() => TenantController());
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}
