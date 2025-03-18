import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unistay/app.dart';
import 'package:unistay/data/services/deep_link_handler.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://nzjcvaqyqtnvtnsrelvw.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im56amN2YXF5cXRudnRuc3JlbHZ3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDIxNDM3MDMsImV4cCI6MjA1NzcxOTcwM30.uHp81vNUDfjjUX7lxLMMnsb-GRx8ficUjUcqt-wYNjw',
  );


// Inicializa el manejador de Deep Links
  DeepLinkHandler().initDeepLinkListener(); 

  runApp(const MyApp());
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}



