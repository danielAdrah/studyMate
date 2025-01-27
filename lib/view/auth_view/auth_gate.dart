// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studymate/view/auth_view/cover_page.dart';
import 'package:studymate/view/professor_view/professor_main_nav_bar.dart';
import 'package:studymate/view/student_view/student_main_nav_bar.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CoverPage();
          }

          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance.collection('users').doc(snapshot.data!.uid).get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const CoverPage();
              }

              String? role = snapshot.data!['role'];

              if (role == null) {
                print('User not found or does not have a role');
                return const CoverPage();
              }

              switch (role) {
                case 'Student':
                  return const StudentMainNavBar();
                case 'Professor':
                  return const ProfessorMainNavBar();
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