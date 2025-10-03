// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studymate/services/user_service.dart';
import 'package:studymate/view/auth_view/cover_page.dart';
import 'package:studymate/view/professor_view/professor_main_nav_bar.dart';
import 'package:studymate/view/student_view/student_main_nav_bar.dart';

import '../admin_view/admin_home_page.dart';
import 'log_in.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
    _userService.initializeAuthListener();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CoverPage();
          }

          if (!snapshot.hasData) {
            return const LogIn();
          }

          // Use the cached service approach
          return FutureBuilder<String?>(
            future: _userService.getUserRole(),
            builder: (context, roleSnapshot) {
              if (roleSnapshot.connectionState == ConnectionState.waiting) {
                return const CoverPage();
              }

              final String? role = roleSnapshot.data;

              if (role == null) {
                print('User does not have a role');
                return const CoverPage();
              }

              switch (role) {
                case 'Student':
                  return const StudentMainNavBar();
                case 'Professor':
                  return const ProfessorMainNavBar();
                case 'Admin':
                  return const AdminHomePage();
                default:
                  print('Unknown role: $role');
                  return const CoverPage();
              }
            },
          );
        },
      ),
    );
  }
}
