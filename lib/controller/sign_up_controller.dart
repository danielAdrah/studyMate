// ignore_for_file: avoid_print, unused_local_variable, prefer_const_constructors, use_build_context_synchronously, empty_catches, unused_catch_clause, unnecessary_null_in_if_null_operators

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../view/admin_view/admin_home_page.dart';
import '../view/auth_view/log_in.dart';
import '../view/professor_view/professor_main_nav_bar.dart';
import '../view/student_view/student_main_nav_bar.dart';

class SignUpController extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  RxString accountType = "".obs;
  TextEditingController specialty = TextEditingController();
  RxBool isActive = true.obs;

  RxBool logInLoading = false.obs;
  RxBool signUpLoading = false.obs;
  //========

  Future logIn(String mail, passWord, BuildContext context) async {
    try {
      logInLoading.value = true;
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: mail,
        password: passWord,
      );

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
            logInLoading.value = false;
            Get.off(StudentMainNavBar());
          } else if (role == "Professor") {
            logInLoading.value = false;
            Get.off(ProfessorMainNavBar());
          } else if (role == "Admin") {
            logInLoading.value = false;
            Get.off(AdminHomePage());
          } else {
            logInLoading.value = false;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('User role not found. Please contact support.'),
                backgroundColor: Colors.orange,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
            print("no role");
          }
        } else {
          logInLoading.value = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('User data not found. Please contact support.'),
              backgroundColor: Colors.orange,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
      } else {
        logInLoading.value = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please verify your email address first!'),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            action: SnackBarAction(
              label: 'Resend',
              textColor: Colors.white,
              onPressed: () {
                credential.user!.sendEmailVerification();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Verification email sent!'),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              },
            ),
          ),
        );
        print("please verfiy first");
      }
    } on FirebaseAuthException catch (e) {
      logInLoading.value = false;
      String errorMessage = 'Login failed. Please try again.';

      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No account found with this email address.';
          break;
        case 'wrong-password':
          errorMessage = 'Incorrect password. Please try again.';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address format.';
          break;
        case 'user-disabled':
          errorMessage = 'This account has been disabled.';
          break;
        case 'too-many-requests':
          errorMessage = 'Too many failed attempts. Please try again later.';
          break;
        case 'invalid-credential':
          errorMessage =
              'Invalid email or password. Please check your credentials.';
          break;
        default:
          errorMessage = 'Login failed: ${e.message}';
      }

      print('FirebaseAuthException: ${e.code} - ${e.message}');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white, size: 20),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  errorMessage,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: Duration(seconds: 4),
        ),
      );
    } catch (e) {
      logInLoading.value = false;
      print('Unexpected error: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white, size: 20),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'An unexpected error occurred. Please try again.',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  //=========
  Future signUp(String mail, passWord, accountType, specialty, name,
      BuildContext context) async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
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
        'specialty': specialty,
        'createdAt': FieldValue.serverTimestamp(),
        'isActive': isActive.value,
        'token': token,
      });
      print("done after added");
      Get.off(LogIn());
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
