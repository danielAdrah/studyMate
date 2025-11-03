// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, body_might_complete_normally_nullable, avoid_print, unused_local_variable, use_build_context_synchronously

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class _SignUpState extends State<SignUp> with TickerProviderStateMixin {
  List<String> accountType = ["Student", "Professor", "Admin"];
  List<String> studentSpecailty = [
    "Programing Model",
    "Machine Learning",
    "Design",
    "Analysis Algorithms"
  ];
  bool isSecure = true;
  bool _isFormValid = false;
  final signController = Get.put(SignUpController());
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController mailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    fnameController.addListener(_validateForm);
    lnameController.addListener(_validateForm);
    mailController.addListener(_validateForm);
    passController.addListener(_validateForm);
  }

  @override
  void dispose() {
    fnameController.dispose();
    lnameController.dispose();
    mailController.dispose();
    passController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      _isFormValid = fnameController.text.isNotEmpty &&
          lnameController.text.isNotEmpty &&
          mailController.text.isNotEmpty &&
          passController.text.isNotEmpty &&
          signController.accountType.value.isNotEmpty &&
          RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
              .hasMatch(mailController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: TColor.background,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              TColor.background,
              TColor.primary.withOpacity(0.05),
              TColor.secondary.withOpacity(0.03),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: height * 0.02),

                    // Header Section
                    FadeInDown(
                      delay: Duration(milliseconds: 300),
                      child: Container(
                        padding: EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: TColor.surface,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: TColor.primary.withOpacity(0.1),
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: TColor.secondary.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: SvgPicture.asset(
                                "assets/img/Main img.svg",
                                height: 120,
                                width: 120,
                                fit: BoxFit.contain,
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              "Create Account",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: TColor.onSurface,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Join our learning community today!",
                              style: TextStyle(
                                fontSize: 16,
                                color: TColor.onSurfaceVariant,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 32),

                    // Sign Up Form
                    FadeInDown(
                      delay: Duration(milliseconds: 500),
                      child: Container(
                        padding: EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: TColor.surface,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: TColor.primary.withOpacity(0.08),
                              blurRadius: 25,
                              offset: Offset(0, 15),
                            ),
                          ],
                        ),
                        child: Form(
                          key: formState,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Name Fields Row
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("First Name",
                                            style: TextStyle(
                                                color: TColor.onSurface,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600)),
                                        SizedBox(height: 12),
                                        TextFormField(
                                          controller: fnameController,
                                          decoration: InputDecoration(
                                            hintText: "First name",
                                            prefixIcon: Icon(
                                                Icons.person_outline,
                                                color: TColor.primary),
                                            filled: true,
                                            fillColor: TColor.background,
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                borderSide: BorderSide.none),
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                borderSide: BorderSide(
                                                    color: TColor.primary,
                                                    width: 2)),
                                          ),
                                          validator: (val) => val == ""
                                              ? "Can't be empty"
                                              : null,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Last Name",
                                            style: TextStyle(
                                                color: TColor.onSurface,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600)),
                                        SizedBox(height: 12),
                                        TextFormField(
                                          controller: lnameController,
                                          decoration: InputDecoration(
                                            hintText: "Last name",
                                            prefixIcon: Icon(
                                                Icons.person_outline,
                                                color: TColor.primary),
                                            filled: true,
                                            fillColor: TColor.background,
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                borderSide: BorderSide.none),
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                borderSide: BorderSide(
                                                    color: TColor.primary,
                                                    width: 2)),
                                          ),
                                          validator: (val) => val == ""
                                              ? "Can't be empty"
                                              : null,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 24),

                              // Email Field
                              Text("E-mail",
                                  style: TextStyle(
                                      color: TColor.onSurface,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
                              SizedBox(height: 12),
                              TextFormField(
                                controller: mailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  hintText: "Enter your email address",
                                  prefixIcon: Icon(Icons.email_outlined,
                                      color: TColor.primary),
                                  filled: true,
                                  fillColor: TColor.background,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide.none),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                          color: TColor.primary, width: 2)),
                                ),
                                validator: (val) =>
                                    val == "" ? "Can't be empty" : null,
                              ),

                              SizedBox(height: 24),

                              // Password Field
                              Text("Password",
                                  style: TextStyle(
                                      color: TColor.onSurface,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
                              SizedBox(height: 12),
                              TextFormField(
                                controller: passController,
                                obscureText: isSecure,
                                decoration: InputDecoration(
                                  hintText: "Enter your password",
                                  prefixIcon: Icon(Icons.lock_outline,
                                      color: TColor.primary),
                                  suffixIcon: InkWell(
                                    onTap: () {
                                      HapticFeedback.lightImpact();
                                      setState(() {
                                        isSecure = !isSecure;
                                      });
                                    },
                                    child: Icon(isSecure
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined),
                                  ),
                                  filled: true,
                                  fillColor: TColor.background,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide.none),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                          color: TColor.primary, width: 2)),
                                ),
                                validator: (val) =>
                                    val == "" ? "Can't be empty" : null,
                              ),

                              SizedBox(height: 24),

                              // Account Type Dropdown
                              Text("Account Type",
                                  style: TextStyle(
                                      color: TColor.onSurface,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
                              SizedBox(height: 12),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 4),
                                decoration: BoxDecoration(
                                  color: TColor.background,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                      color: TColor.primary.withOpacity(0.1)),
                                ),
                                child: DropdownButton<String>(
                                  hint: Obx(() => signController
                                          .accountType.value.isEmpty
                                      ? Text("Choose your Account Type",
                                          style: TextStyle(
                                              color: TColor.onSurfaceVariant))
                                      : Text(signController.accountType.value,
                                          style: TextStyle(
                                              color: TColor.onSurface))),
                                  items: accountType.map((String service) {
                                    return DropdownMenuItem<String>(
                                      value: service,
                                      child: Text(service,
                                          style: TextStyle(
                                              color: TColor.onSurface)),
                                    );
                                  }).toList(),
                                  icon: Icon(Icons.keyboard_arrow_down,
                                      color: TColor.onSurfaceVariant),
                                  isExpanded: true,
                                  underline: SizedBox.shrink(),
                                  onChanged: (String? val) {
                                    if (val != null) {
                                      HapticFeedback.lightImpact();
                                      signController.accountType.value = val;
                                      signController.specialty.clear();
                                      print(signController.accountType.value);
                                    }
                                  },
                                ),
                              ),

                              // Specialty Fields
                              signController.accountType.value == 'Student'
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 24),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: TColor.background,
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            border: Border.all(
                                                color: TColor.primary
                                                    .withOpacity(0.1)),
                                          ),
                                          child: DropdownButton<String>(
                                            hint: Text("Choose your Specialty",
                                                style: TextStyle(
                                                    color: TColor
                                                        .onSurfaceVariant)),
                                            items: studentSpecailty
                                                .map((String service) {
                                              return DropdownMenuItem<String>(
                                                value: service,
                                                child: Text(service,
                                                    style: TextStyle(
                                                        color:
                                                            TColor.onSurface)),
                                              );
                                            }).toList(),
                                            icon: Icon(
                                                Icons.keyboard_arrow_down,
                                                color: TColor.onSurfaceVariant),
                                            isExpanded: true,
                                            underline: SizedBox.shrink(),
                                            onChanged: (String? val) {
                                              if (val != null) {
                                                HapticFeedback.lightImpact();
                                                signController.specialty.text =
                                                    val;
                                                print(signController
                                                    .specialty.text);
                                              }
                                            },
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        CustomTextForm(
                                          secure: false,
                                          hinttext: "Your Specailty",
                                          mycontroller:
                                              signController.specialty,
                                          validator: (val) {
                                            if (val == null || val.isEmpty) {
                                              return "Please choose an account type";
                                            }
                                            return null;
                                          },
                                        ),
                                      ],
                                    )
                                  : signController.accountType.value ==
                                          'Professor'
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(top: 25),
                                          child: CustomTextForm(
                                            secure: false,
                                            hinttext: "Enter your specialty",
                                            mycontroller:
                                                signController.specialty,
                                            validator: (val) {
                                              if (val == "") {
                                                return "Can't be empty";
                                              }
                                              return null;
                                            },
                                          ),
                                        )
                                      : Container(),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 32),

                    // Sign Up Button
                    FadeInDown(
                      delay: Duration(milliseconds: 700),
                      child: signController.signUpLoading.value
                          ? Container(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: TColor.primary.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: CircularProgressIndicator(
                                        color: TColor.primary, strokeWidth: 3),
                                  ),
                                  SizedBox(height: 16),
                                  Text("Creating your account...",
                                      style: TextStyle(
                                          color: TColor.onSurfaceVariant,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                            )
                          : AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _isFormValid
                                    ? () async {
                                        HapticFeedback.mediumImpact();
                                        if (formState.currentState!
                                            .validate()) {
                                          signController.signUp(
                                              mailController.text,
                                              passController.text,
                                              signController.accountType.value,
                                              signController.specialty.text,
                                              fnameController.text,
                                              context);
                                        } else {
                                          print("noooo");
                                        }
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _isFormValid
                                      ? TColor.primary
                                      : TColor.onSurfaceVariant
                                          .withOpacity(0.3),
                                  foregroundColor: TColor.onPrimary,
                                  padding: EdgeInsets.symmetric(vertical: 18),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                  elevation: _isFormValid ? 8 : 0,
                                  shadowColor: TColor.primary.withOpacity(0.3),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.person_add, size: 20),
                                    SizedBox(width: 12),
                                    Text("Sign Up",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                            ),
                    ),

                    SizedBox(height: 24),

                    // Sign In Section
                    FadeInDown(
                      delay: Duration(milliseconds: 800),
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: TColor.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: TColor.primary.withOpacity(0.1)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("You have an account?",
                                style: TextStyle(
                                    color: TColor.onSurface,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500)),
                            SizedBox(width: 8),
                            GestureDetector(
                              onTap: () {
                                HapticFeedback.lightImpact();
                                Get.to(() => LogIn(),
                                    transition: Transition.leftToRight);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: TColor.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text("Sign In",
                                    style: TextStyle(
                                        color: TColor.primary,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
