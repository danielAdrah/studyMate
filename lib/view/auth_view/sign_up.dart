// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, body_might_complete_normally_nullable, avoid_print, unused_local_variable

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../common_widgets/custom_button.dart';
import '../../common_widgets/custome_text_field.dart';
import '../../theme.dart';
import '../main_nav_bar.dart';
import 'log_in.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isSecure = false;
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController mailController = TextEditingController();
  TextEditingController passController = TextEditingController();
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
                SizedBox(height: 50),
                FadeInDown(
                    delay: Duration(milliseconds: 500),
                    child: SvgPicture.asset(
                      "assets/img/undraw_secure-login_m11a.svg",
                      height: 200,
                      width: 250,
                      fit: BoxFit.fill,
                    )),
                SizedBox(height: 20),
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
                            "First Name",
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 10),
                          CustomTextForm(
                            secure: false,
                            hinttext: "Enter your first name",
                            mycontroller: fnameController,
                            validator: (val) {
                              if (val == "") {
                                return "Can't be empty";
                              }
                            },
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Last Name",
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 10),
                          CustomTextForm(
                            secure: false,
                            hinttext: "Enter your last name",
                            mycontroller: lnameController,
                            validator: (val) {
                              if (val == "") {
                                return "Can't be empty";
                              }
                            },
                          ),
                          SizedBox(height: 20),
                          Text(
                            "E-mail",
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
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 35),
                FadeInDown(
                  delay: Duration(milliseconds: 800),
                  child: CustomButton(
                    title: "Sign up",
                    //this method to perform the login operation
                    onTap: () {
                      Get.off(MainNavBar());
                      if (formState.currentState!.validate()) {
                      } else {
                        print("error");
                      }
                    },
                  ),
                ),
                FadeInDown(
                  delay: Duration(milliseconds: 950),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("You have an account?",
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      TextButton(
                          onPressed: () {
                            //will navigate you to the login page
                            Get.to(LogIn());
                          },
                          child: Text("Sign in"))
                    ],
                  ),
                ),
                SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
