import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unistay/app.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://nzjcvaqyqtnvtnsrelvw.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im56amN2YXF5cXRudnRuc3JlbHZ3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDIxNDM3MDMsImV4cCI6MjA1NzcxOTcwM30.uHp81vNUDfjjUX7lxLMMnsb-GRx8ficUjUcqt-wYNjw',
  );
  runApp(const MyApp());
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}


