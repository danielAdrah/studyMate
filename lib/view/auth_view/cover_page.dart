// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common_widgets/custom_button.dart';
import '../../theme.dart';
import 'log_in.dart';
import 'sign_up.dart';

class CoverPage extends StatefulWidget {
  const CoverPage({super.key});

  @override
  State<CoverPage> createState() => _CoverPageState();
}

class _CoverPageState extends State<CoverPage> {
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 80),
                FadeInDown(
                  delay: Duration(milliseconds: 500),
                  child: Container(
                    width: 100,
                    height: 80,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  width: 150,
                  height: 50,
                  color: Colors.blue,
                ),
                SizedBox(height: 60),
                Text(
                  "Let us help you learn King Khalid \n University curriculum",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: TColor.black,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 35),
                Text(
                  "Please sign in to start course",
                  style: TextStyle(
                    color: TColor.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 35),
                //this button will navigate you to the signup page
                CustomButton(
                  title: "Sign up",
                  onTap: () {
                    Get.off(SignUp());
                  },
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?",
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    TextButton(
                      onPressed: () {
                        //will navigate you to the login page
                        Get.to(LogIn());
                      },
                      child: Text("Sign in"))
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
