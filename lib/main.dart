// ignore_for_file: prefer_const_constructors, avoid_print, use_build_context_synchronously, unnecessary_null_in_if_null_operators

import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';
import 'view/auth_view/auth_gate.dart';
 
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthGate(),
    );
  }
}
