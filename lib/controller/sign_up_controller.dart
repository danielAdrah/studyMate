// ignore_for_file: avoid_print, unused_local_variable, prefer_const_constructors, use_build_context_synchronously, empty_catches, unused_catch_clause, unnecessary_null_in_if_null_operators

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../view/auth_view/log_in.dart';
import '../view/professor_view/professor_main_nav_bar.dart';
import '../view/student_view/student_main_nav_bar.dart';

class SignUpController extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  RxString accountType = "".obs;
  RxBool logInLoading = false.obs;
  RxBool signUpLoading = false.obs;
  //========

  Future<String?> determineUserRole(String uid) async {
    try {
      List<Map<String, dynamic>> allDocuments = await FirebaseFirestore.instance
          .collection('students')
          .doc(uid)
          .get()
          .then((value) => [value.data() ?? {}])
          .then((value) async => [
                ...value,
                ...(await FirebaseFirestore.instance
                    .collection('professors')
                    .doc(uid)
                    .get()
                    .then((doc) => [doc.data() ?? {}]))
              ]);

      String? role = allDocuments.firstWhereOrNull(
              (element) => element.containsKey('role'))?['role'] ??
          null;

      if (role == null) {
        print('User not found in either Students or Professors collection');
      }

      return role;
    } catch (e) {
      print('Error fetching user role: $e');
      return null;
    }
  }

//===========
  Future logIn(String mail, passWord, BuildContext context) async {
    try {
      logInLoading.value = true;
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: mail,
        password: passWord,
      );
      logInLoading.value = false;

      if (credential.user!.emailVerified) {
        //here we check if the user has verified his account
        //if he so we will take hin to the home page
        //if he is not we will tell him to do it

        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(credential.user!.uid)
            .get();

        if (userDoc.exists) {
          Map<String, dynamic> userData =
              userDoc.data() as Map<String, dynamic>;
          String? role = userData['role'];
          print("=================$role");
          if (role == "Student") {
            Get.off(StudentMainNavBar());
          } else if (role == "Professor") {
            Get.off(ProfessorMainNavBar());
          } else {
            print("no role");
          }
        }
        // String? userRole = await determineUserRole(credential.user!.uid);

        // if (userRole == "Student") {
        //   Get.off(StudentMainNavBar());
        // } else if (userRole == "professor") {
        //   Get.off(ProfessorMainNavBar());
        // } else {
        //   print("wrong role");
        // }
      } else {
        logInLoading.value = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please Verify your account first!')),
        );
        print("please verfiy first");
      }
    } on FirebaseAuthException catch (e) {
      logInLoading.value = false;
      print("not done");
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('user-not-found')),
        );
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Wrong password provided for that user.')),
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Incorrect User credentials")),
      );
    }
  }

//===========
  Future<void> addUserToFirestore(
      User user, String accountType, nameController) async {
    DocumentReference? docRef;

    if (accountType == "Student") {
      docRef = firestore.collection("students").doc(user.uid);
    } else if (accountType == "professor") {
      docRef = firestore.collection("professors").doc(user.uid);
    }

    await docRef!.set({
      'uid': user.uid,
      'email': user.email!,
      'name': nameController,
      'role': accountType,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  //=========
  Future signUp(
      String mail, passWord, accountType, name, BuildContext context) async {
    try {
      signUpLoading.value = true;
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: mail,
        password: passWord,
      );

      //after the user creates an account a link is send to it
      FirebaseAuth.instance.currentUser!.sendEmailVerification();

      // await addUserToFirestore(credential.user!, accountType, name);
      firestore.collection("users").doc(credential.user!.uid).set({
        'uid': credential.user!.uid,
        'email': credential.user!.email,
        'name': name,
        'role': accountType,
        'createdAt': FieldValue.serverTimestamp(),
      });
      print("done after added");
      Get.to(LogIn());
      signUpLoading.value = false;
    } on FirebaseAuthException catch (e) {
      signUpLoading.value = false;
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('The password provided is too weak')),
        );
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('The account already exists for that email.')),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }
}
