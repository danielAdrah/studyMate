// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, body_might_complete_normally_nullable, avoid_print, unused_local_variable, use_build_context_synchronously, unnecessary_null_comparison, unnecessary_null_in_if_null_operators, unused_import

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common_widgets/custom_button.dart';
import '../../common_widgets/custome_text_field.dart';
import '../../controller/sign_up_controller.dart';
import '../../theme.dart';
import '../professor_view/professor_main_nav_bar.dart';
import '../student_view/student_main_nav_bar.dart';
import 'sign_up.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final controller = Get.put(SignUpController());
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController mailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  bool isSecure = false;

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

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: TColor.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 10),

                FadeInDown(
                  delay: Duration(milliseconds: 500),
                  child: Image.asset("assets/img/uniCourse.png",
                      height: 80, width: 80, fit: BoxFit.fill),
                ),
                FadeInDown(
                    delay: Duration(milliseconds: 600),
                    child: Image.asset("assets/img/logo2.png",
                        width: 320, height: 320)),
                SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: Form(
                    key: formState,
                    child: FadeInDown(
                      delay: Duration(milliseconds: 700),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Email address",
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 10),
                          CustomTextForm(
                            secure: false,
                            hinttext: "Enter your e-mail",
                            mycontroller: mailController,
                            validator: (val) {
                              if (val == "") {
                                return "Can't be empty";
                              }
                            },
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Password",
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 10),
                          CustomTextForm(
                            secure: isSecure,
                            hinttext: "Enter your password",
                            mycontroller: passController,
                            onTap: () {
                              setState(() {
                                isSecure = !isSecure;
                              });
                            },
                            suffixIcon: isSecure
                                ? Icons.visibility_off
                                : Icons.visibility,
                            validator: (val) {
                              if (val == "") {
                                return "Can't be empty";
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // FadeInDown(
                //   delay: Duration(milliseconds: 700),
                //   child: Padding(
                //     padding: const EdgeInsets.only(left: 220),
                //     child: TextButton(
                //       //this method to change the password
                //       onPressed: () {},
                //       child: Text(
                //         "Forget password?",
                //         style: TextStyle(
                //           fontSize: 12,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),

                SizedBox(height: 35),
                FadeInDown(
                  delay: Duration(milliseconds: 800),
                  child: CustomButton(
                    title: "Sign In",
                    //this method to perform the login operation
                    onTap: () async {
                      if (formState.currentState!.validate()) {
                        //here we checked if the textfields have a value
                        //if it does it will excute this block
                        //here we will add the login method

                        controller.logIn(
                            mailController.text, passController.text, context);

                        // try {
                        //   final credential = await FirebaseAuth.instance
                        //       .signInWithEmailAndPassword(
                        //     email: mailController.text,
                        //     password: passController.text,
                        //   );
                        //   if (credential.user!.emailVerified) {
                        //     //here we check if the user has verified his account
                        //     //if he so we will take hin to the home page
                        //     //if he is not we will tell him to do it

                        //     String? userRole =
                        //         await determineUserRole(credential.user!.uid);

                        //     if (userRole == "Student") {
                        //       Get.off(StudentMainNavBar());
                        //     } else if (userRole == "professor") {
                        //       Get.off(ProfessorMainNavBar());
                        //     } else {
                        //       print("wrong role");
                        //     }
                        //   } else {
                        //     ScaffoldMessenger.of(context).showSnackBar(
                        //       SnackBar(
                        //           content: Text(
                        //               'Please Verify your account first!')),
                        //     );
                        //     print("please verfiy first");
                        //   }
                        // } on FirebaseAuthException catch (e) {
                        //   if (e.code == 'user-not-found') {
                        //     print('No user found for that email.');
                        //     ScaffoldMessenger.of(context).showSnackBar(
                        //       SnackBar(content: Text('user-not-found')),
                        //     );
                        //   } else if (e.code == 'wrong-password') {
                        //     print('Wrong password provided for that user.');
                        //     ScaffoldMessenger.of(context).showSnackBar(
                        //       SnackBar(
                        //           content: Text(
                        //               'Wrong password provided for that user.')),
                        //     );
                        //   }

                        //   ScaffoldMessenger.of(context).showSnackBar(
                        //     SnackBar(
                        //         content: Text("Incorrect User credentials")),
                        //   );
                        // }
                      } else {
                        //if it don't have a value it will perform this block
                        print("error");
                      }
                    },
                  ),
                ),
                FadeInDown(
                  delay: Duration(milliseconds: 900),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account?",
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      TextButton(
                          onPressed: () {
                            //will navigate you to the login page
                            Get.to(SignUp());
                          },
                          child: Text("Sign up"))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
