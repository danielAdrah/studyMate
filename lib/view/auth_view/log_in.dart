// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, body_might_complete_normally_nullable, avoid_print, unused_local_variable

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common_widgets/custom_button.dart';
import '../../common_widgets/custome_text_field.dart';
import '../../theme.dart';
import '../main_nav_bar.dart';
import 'sign_up.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController mailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  bool isSecure = false;
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
                SizedBox(height: 40),
                FadeInDown(
                    delay: Duration(milliseconds: 500),
                    child: Image.asset("assets/img/logo.png",
                        width: 200, height: 200)),
                SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: Form(
                    key: formState,
                    child: FadeInDown(
                      delay: Duration(milliseconds: 600),
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
                    onTap: () {
                      Get.off(MainNavBar());

                      if (formState.currentState!.validate()) {
                        //here we checked if the textfields have a value
                        //if it does it will excute this block
                        //here we will add the login method
                        print("done");
                      } else {
                        //if it don't have a value it will perform this block
                        print("error");
                      }
                    },
                  ),
                ),
                Row(
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
