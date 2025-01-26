// // ignore_for_file: prefer_const_constructors, avoid_print, unnecessary_null_in_if_null_operators

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:studymate/view/auth_view/cover_page.dart';
// import 'package:studymate/view/professor_view/professor_main_nav_bar.dart';
// import 'package:studymate/view/student_view/student_main_nav_bar.dart';

// class AuthGate extends StatefulWidget {
//   const AuthGate({super.key});

//   @override
//   State<AuthGate> createState() => _AuthGateState();
// }

// class _AuthGateState extends State<AuthGate> {

//   Future<String?> determineUserRole(String uid) async {
//     try {
//       List<Map<String, dynamic>> allDocuments = await FirebaseFirestore.instance
//           .collection('students')
//           .doc(uid)
//           .get()
//           .then((value) => [value.data() ?? {}])
//           .then((value) async => [
//                 ...value,
//                 ...(await FirebaseFirestore.instance
//                     .collection('professors')
//                     .doc(uid)
//                     .get()
//                     .then((doc) => [doc.data() ?? {}]))
//               ]);

//       String? role = allDocuments.firstWhereOrNull(
//               (element) => element.containsKey('role'))?['role'] ??
//           null;

//       if (role == null) {
//         print('User not found in either Students or Professors collection');
//       }

//       return role;
//     } catch (e) {
//       print('Error fetching user role: $e');
//       return null;
//     }
//   }
//   //  String? userRole;
//   @override
//   Widget build(BuildContext context)  {
//     return Scaffold(
//       //this stream is going to listen to all the changes
//       //in the auth state(weather the user is logged in or not)
//       body: StreamBuilder(
//         stream: FirebaseAuth.instance.authStateChanges(),
//         builder: (context, snapshot) {
//           //if is logged in
//           if (snapshot.hasData) {
            
         
            
//           }
//           //if not logged in
//           else {
//             return CoverPage();
//           }
//         },
//       ),
//     );
//   }
// }
