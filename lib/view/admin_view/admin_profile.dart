// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, avoid_print, use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studymate/controller/store_controller.dart';

import '../../common_widgets/custome_text_field.dart';
import '../../controller/cours_controller.dart';
import '../../theme.dart';
import '../auth_view/auth_gate.dart';
import '../auth_view/log_in.dart';

class AdminProfile extends StatefulWidget {
  const AdminProfile({super.key});

  @override
  State<AdminProfile> createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {
  final controller = Get.put(CoursController());
  final storeController = Get.put(StoreController());
  final newName = TextEditingController();
  final newPass = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String? userName;
  String? userEmail;

  clearField() {
    newName.clear();
  }

  updateUserInfo(String userId, newName) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'name': newName,
      });
      storeController.fetchUserData();
      print("done update");
    } catch (e) {
      print(e.toString());
    }
  }

  void deleteAccount(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Delete Account'),
              content: Text('Are you sure you want to delete your account?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    try {
                      await storeController.deleteAccount();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Account deleted successfully')));
                      // Navigate to login screen or home screen after deletion
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => AuthGate()));
                    } catch (e) {
                      print(e);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Failed to delete account: $e')));
                    }
                  },
                  child: Text('Delete'),
                ),
              ],
            ));
  }

  @override
  void initState() {
    super.initState();
    storeController.fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: TColor.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40),
                Stack(
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
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Personal Information",
                            style: TextStyle(
                                color: TColor.primary,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                          TextButton(
                            onPressed: () {
                              customDialog(context, newName, () {
                                updateUserInfo(
                                  auth.currentUser!.uid,
                                  newName.text,
                                );
                                Get.back();
                                clearField();
                              });
                            },
                            child: Text(
                              "Update",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: double.infinity,
                        height: height / 2.6,
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
                              child: Text(storeController.userFullName.value,
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
                              child: Text(storeController.userMail.value,
                                  style: TextStyle(
                                      color: const Color.fromARGB(115, 0, 0, 0),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400)),
                              icon: Icons.mail,
                            ),
                            SizedBox(height: 35),
                            InfoTile(
                              title: "Password :",
                              onTap: () {},
                              child: InkWell(
                                  onTap: () async {
                                    try {
                                      //this for sending an link to the email that the user forget its password
                                      await FirebaseAuth.instance
                                          .sendPasswordResetEmail(
                                        email: storeController.userMail.value,
                                      );

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  "A link has been send to your email")));
                                    } catch (e) {
                                      print(e.toString());
                                    }
                                  },
                                  child: Text("Change Password")),
                              icon: Icons.security,
                            ),
                            SizedBox(height: 30),
                            // CommunityBtn(
                            //     title: "Update",
                            //     onTap: () {

                            //       });
                            //     }),
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
                        height: height / 8,
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
Future<dynamic> customDialog(
  BuildContext context,
  TextEditingController name,
  void Function()? updateOnTap,
) {
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
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: updateOnTap,
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
