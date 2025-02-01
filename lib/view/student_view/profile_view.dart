// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common_widgets/custome_text_field.dart';
import '../../controller/cours_controller.dart';
import '../../theme.dart';
import '../auth_view/log_in.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final controller = Get.put(CoursController());
  final newName = TextEditingController();
  final newMail = TextEditingController();
  final newPass = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String? userName;
  String? userEmail;
  String? userSpecialty;

  Future<void> fetchUserData() async {
    final user = auth.currentUser;
    if (user != null) {
      final docSnap = await firestore.collection('users').doc(user.uid).get();
      if (docSnap.exists) {
        setState(() {
          userName = docSnap.get('name');
          userEmail = docSnap.get('email');
          userSpecialty = docSnap.get('specialty');
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 40),
              Obx(
                () => Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: TColor.primary,
                      ),
                      child: CircleAvatar(
                          radius: 70,
                          backgroundImage: controller.imagePath.value == null
                              ? AssetImage("assets/img/user.png")
                              : FileImage(File(controller.imagePath.value!))
                                  as ImageProvider<Object>?),
                    ),
                    Positioned(
                      right: 10,
                      bottom: 1,
                      child: InkWell(
                        onTap: () {
                          //choose a pic
                          controller.uploadImage();
                        },
                        child: CircleAvatar(
                          backgroundColor: TColor.white,
                          radius: 20,
                          child: Icon(
                            Icons.camera_alt,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "Personal Information",
                        style: TextStyle(
                            color: TColor.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 350,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(1, 1.5),
                            blurRadius: 0.2,
                            blurStyle: BlurStyle.outer,
                          )
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 40),
                          InfoTile(
                            onTap: () {},
                            title: "Name :",
                            child: Text(userName ?? "Not set",
                                style: TextStyle(
                                    color: const Color.fromARGB(115, 0, 0, 0),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400)),
                            icon: Icons.person,
                          ),
                          SizedBox(height: 35),
                          InfoTile(
                            title: "E-mail :",
                            onTap: () {},
                            child: Text(userEmail ?? "Not set",
                                style: TextStyle(
                                    color: const Color.fromARGB(115, 0, 0, 0),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400)),
                            icon: Icons.mail,
                          ),
                          SizedBox(height: 35),
                          InfoTile(
                            title: "Specialty :",
                            onTap: () {},
                            child: Text(userSpecialty ?? "Not set",
                                style: TextStyle(
                                    color: const Color.fromARGB(115, 0, 0, 0),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400)),
                            icon: Icons.add_chart_outlined,
                          ),
                          SizedBox(height: 35),
                          InfoTile(
                            title: "Password :",
                            onTap: () {},
                            child: InkWell(
                                onTap: () {}, child: Text("Change Password")),
                            icon: Icons.security,
                          ),
                          SizedBox(height: 25),
                          // Padding(
                          //   padding:
                          //       const EdgeInsets.symmetric(horizontal: 130),
                          //   child: InkWell(
                          //     onTap: () {
                          //       customDialog(
                          //           context, newName, newMail, newPass);
                          //     },
                          //     child: Container(
                          //       padding: EdgeInsets.symmetric(
                          //           vertical: 10, horizontal: 15),
                          //       decoration: BoxDecoration(
                          //         color: TColor.primary,
                          //         borderRadius: BorderRadius.circular(25),
                          //       ),
                          //       child: Row(
                          //         mainAxisAlignment: MainAxisAlignment.center,
                          //         children: [
                          //           Text(
                          //             "Update",
                          //             style: TextStyle(
                          //                 color: TColor.white,
                          //                 fontWeight: FontWeight.w600),
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //   ),
                          // )
                          CommunityBtn(
                              title: "Update",
                              onTap: () {
                                customDialog(
                                    context, newName, newMail, newPass);
                              }),
                        ],
                      ),
                    ),
                    SizedBox(height: 35),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "Other Options",
                        style: TextStyle(
                            color: TColor.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 170,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(1, 1.5),
                            blurRadius: 0.2,
                            blurStyle: BlurStyle.outer,
                          )
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 40),
                          InfoTile(
                            onTapGen: () async {
                              //this is for signout
                              await FirebaseAuth.instance.signOut();
                              Get.off(LogIn());
                            },
                            title: "Log Out",
                            onTap: () {},
                            child: Icon(
                              Icons.arrow_forward_ios,
                              size: 20,
                              color: Colors.white,
                            ),
                            icon: Icons.logout,
                          ),
                          SizedBox(height: 35),
                          InfoTile(
                            title: "Delete Account",
                            child: Icon(
                              Icons.arrow_forward_ios,
                              size: 20,
                              color: Colors.white,
                            ),
                            onTap: () {
                              warningDialog(context);
                            },
                            icon: Icons.delete,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 35),
            ],
          ),
        ),
      ),
    );
  }
}

//======in this widget we will display the personal info of the user========
class InfoTile extends StatelessWidget {
  InfoTile({
    super.key,
    required this.title,
    required this.icon,
    required this.child,
    required this.onTap,
    this.onTapGen,
  });
  final String title;
  final IconData icon;
  final Widget child;
  void Function()? onTapGen;

  void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: onTapGen,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Icon(icon, color: TColor.primary, size: 30),
                SizedBox(width: 8),
                Text(title,
                    style: TextStyle(
                        color: TColor.primary,
                        fontSize: 19,
                        fontWeight: FontWeight.w700)),
              ],
            ),
            SizedBox(width: width / 9),
            Expanded(
              child: InkWell(
                onTap: onTap,
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//==========this is a dialog==============
Future<dynamic> customDialog(BuildContext context, TextEditingController name,
    TextEditingController mail, TextEditingController pass) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: Icon(
            Icons.edit,
            size: 50,
            color: TColor.primary,
          ),
          backgroundColor: TColor.background,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15),
              CustomTextForm(
                hinttext: "New Name",
                mycontroller: name,
                secure: false,
              ),
              SizedBox(height: 25),
              CustomTextForm(
                hinttext: "New Mail",
                mycontroller: mail,
                secure: false,
              ),
              SizedBox(height: 25),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 13, horizontal: 30),
                    decoration: BoxDecoration(
                      color: TColor.primary,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "OK",
                          style: TextStyle(
                              color: TColor.white, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 8),
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 13, horizontal: 15),
                    decoration: BoxDecoration(
                      color: TColor.white,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Cancel",
                          style: TextStyle(
                              color: TColor.primary,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      });
}

//==========this is warning dialog==============
Future<dynamic> warningDialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: Icon(
            Icons.warning_amber,
            size: 50,
            color: TColor.primary,
          ),
          backgroundColor: TColor.background,
          title: Center(
            child: Text(
              "Are you sure you want to delete this account ?",
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 19,
                  color: TColor.black),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 13, horizontal: 30),
                    decoration: BoxDecoration(
                      color: TColor.primary,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "OK",
                          style: TextStyle(
                              color: TColor.white, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 8),
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 13, horizontal: 15),
                    decoration: BoxDecoration(
                      color: TColor.white,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Cancel",
                          style: TextStyle(
                              color: TColor.primary,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      });
}

//===========community button==================
class CommunityBtn extends StatelessWidget {
  CommunityBtn({
    super.key,
    required this.title,
    required this.onTap,
  });
  final String title;
  void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 6, horizontal: 20),
        decoration: BoxDecoration(
          color: TColor.primary,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          title,
          style: TextStyle(color: TColor.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
