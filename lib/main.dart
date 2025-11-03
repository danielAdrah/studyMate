// ignore_for_file: prefer_const_constructors, avoid_print, use_build_context_synchronously, unnecessary_null_in_if_null_operators

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'services/notification_service.dart';
import 'services/assignment_service.dart';
import 'view/auth_view/auth_gate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final notificationService = NotificationService();
  await notificationService.initNotifications();
  await notificationService.initLocalNotifications();

  // Initialize SharedPreferences
  await SharedPreferences.getInstance();

  // Initialize services
  Get.put(AssignmentService());

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


// Warning: SDK processing. This version only understands SDK XML versions up to 3 but an SDK XML file of version 4 was encountered. This can happen if you use versions of Android Studio and the command-line tools that were released at different times.