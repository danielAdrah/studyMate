// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, body_might_complete_normally_nullable, avoid_print, unused_local_variable, use_build_context_synchronously

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../common_widgets/custom_button.dart';
import '../../common_widgets/custome_text_field.dart';
import '../../controller/sign_up_controller.dart';
import '../../theme.dart';
import 'log_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  List<String> accountType = ["Student", "professor"];
  bool isSecure = false;
  final signController = Get.put(SignUpController());
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController mailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

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

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
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
                      "assets/img/Main img.svg",
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
                          Text(
                            "Account Type",
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                                color: TColor.white,
                                borderRadius: BorderRadius.circular(15)),
                            width: width / 0.5,
                            child: DropdownButton<String>(
                              hint: Obx(() => signController
                                      .accountType.value.isEmpty
                                  ? Text(
                                      " Choose your Account Type",
                                      style: TextStyle(
                                          color: TColor.black.withOpacity(0.5)),
                                    )
                                  : Text(signController.accountType.value,
                                      style: TextStyle(color: TColor.black))),
                              items: accountType.map((String service) {
                                return DropdownMenuItem<String>(
                                  value: service,
                                  child: Row(
                                    children: [
                                      Text(
                                        service,
                                        style: TextStyle(
                                            color:
                                                TColor.black.withOpacity(0.5)),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                              iconSize: 30,
                              icon: Icon(Icons.keyboard_arrow_down),
                              isExpanded: true,
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              underline: Text(
                                "",
                                style: TextStyle(color: TColor.white),
                              ),
                              onChanged: (String? val) {
                                if (val != null) {
                                  signController.accountType.value = val;
                                  print(signController.accountType.value);
                                }
                              },
                            ),
                          ),
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
                    onTap: () async {
                      if (formState.currentState!.validate()) {
                        try {
                          final credential = await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                            email: mailController.text,
                            password: passController.text,
                          );

                          //after the user creates an account a link is send to it
                          FirebaseAuth.instance.currentUser!
                              .sendEmailVerification();

                          await addUserToFirestore(
                              credential.user!,
                              signController.accountType.value,
                              fnameController.text);

                          Get.to(LogIn());
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'weak-password') {
                            print('The password provided is too weak.');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'The password provided is too weak')),
                            );
                          } else if (e.code == 'email-already-in-use') {
                            print('The account already exists for that email.');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'The account already exists for that email.')),
                            );
                          }
                        } catch (e) {
                          print(e);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())),
                          );
                        }
                      } else {
                        print("noooo");
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
