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
import '../auth_view/log_in.dart';
import 'notification_view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final controller = Get.put(CoursController());
  final storeController = Get.put(StoreController());
  final newName = TextEditingController();
  final newSpecailty = TextEditingController();
  final newPass = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  clearField() {
    newName.clear();
    newSpecailty.clear();
  }

  updateUserInfo(String userId, newName, newSpecailty) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'name': newName,
        'specialty': newSpecailty,
      });
      storeController.fetchUserData();
      print("done update");
    } catch (e) {
      print(e.toString());
    }
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
                Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [TColor.primary, TColor.secondary],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: TColor.primary.withOpacity(0.3),
                                blurRadius: 15,
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(4),
                            child: CircleAvatar(
                              radius: 66,
                              backgroundImage: controller.imagePath.value ==
                                      null
                                  ? AssetImage("assets/img/user.png")
                                  : FileImage(File(controller.imagePath.value!))
                                      as ImageProvider<Object>?,
                              backgroundColor: TColor.surface,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            //choose a pic
                            controller.uploadImage();
                          },
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: TColor.primary,
                              boxShadow: [
                                BoxShadow(
                                  color: TColor.primary.withOpacity(0.4),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(
                      storeController.userFullName.value.isEmpty
                          ? "User Name"
                          : storeController.userFullName.value,
                      style: TextStyle(
                        color: TColor.onSurface,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      storeController.userSpecialty.value.isEmpty
                          ? "Student"
                          : storeController.userSpecialty.value,
                      style: TextStyle(
                        color: TColor.onSurfaceVariant,
                        fontSize: 14,
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
                              color: TColor.onSurface,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 36,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                customDialog(context, newName, newSpecailty,
                                    () {
                                  updateUserInfo(auth.currentUser!.uid,
                                      newName.text, newSpecailty.text);
                                  Get.back();
                                  clearField();
                                });
                              },
                              icon: Icon(
                                Icons.edit,
                                size: 16,
                                color: TColor.primary,
                              ),
                              label: Text(
                                "Edit",
                                style: TextStyle(
                                  color: TColor.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: TColor.background,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide(
                                    color: TColor.primary.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                elevation: 0,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: TColor.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: TColor.primary.withOpacity(0.2)),
                          boxShadow: [
                            BoxShadow(
                              color: TColor.primary.withOpacity(0.1),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            InfoTile(
                              onTap: () {},
                              title: "Name",
                              child: Text(storeController.userFullName.value,
                                  style: TextStyle(
                                      color: TColor.onSurfaceVariant,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500)),
                              icon: Icons.person,
                              isLast: false,
                            ),
                            InfoTile(
                              title: "E-mail",
                              onTap: () {},
                              child: Text(storeController.userMail.value,
                                  style: TextStyle(
                                      color: TColor.onSurfaceVariant,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500)),
                              icon: Icons.mail,
                              isLast: false,
                            ),
                            InfoTile(
                              title: "Specialty",
                              onTap: () {},
                              child: Text(storeController.userSpecialty.value,
                                  style: TextStyle(
                                      color: TColor.onSurfaceVariant,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500)),
                              icon: Icons.add_chart_outlined,
                              isLast: false,
                            ),
                            InfoTile(
                              title: "Password",
                              onTap: () {},
                              child: Text("Change Password",
                                  style: TextStyle(
                                      color: TColor.primary,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500)),
                              icon: Icons.security,
                              isLast: true,
                            ),

                            // CommunityBtn(
                            //     title: "Update",
                            //     onTap: () {

                            //     }),
                          ],
                        ),
                      ),
                      SizedBox(height: 35),
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 12),
                        child: Text(
                          "Other Options",
                          style: TextStyle(
                              color: TColor.onSurface,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: TColor.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: TColor.primary.withOpacity(0.2)),
                          boxShadow: [
                            BoxShadow(
                              color: TColor.primary.withOpacity(0.1),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            InfoTile(
                              onTapGen: () async {
                                //this is for signout
                                await FirebaseAuth.instance.signOut();
                                Get.off(LogIn());
                              },
                              title: "Log Out",
                              onTap: () {},
                              child: SizedBox(),
                              icon: Icons.logout,
                              isLast: false,
                            ),
                            InfoTile(
                              onTapGen: () async {
                                Get.to(NotificationView());
                              },
                              title: "Notifications",
                              onTap: () {},
                              child: SizedBox(),
                              icon: Icons.notifications,
                              isLast: true,
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

class InfoTile extends StatelessWidget {
  InfoTile({
    super.key,
    required this.title,
    required this.icon,
    required this.child,
    required this.onTap,
    this.onTapGen,
    this.isLast = false,
  });

  final String title;
  final IconData icon;
  final Widget child;
  final VoidCallback? onTapGen;
  final VoidCallback? onTap;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: !isLast
            ? Border(bottom: BorderSide(color: TColor.primary.withOpacity(0.2)))
            : null,
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            TColor.primary.withOpacity(0.05),
            Colors.transparent,
          ],
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTapGen,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: TColor.primary.withOpacity(0.1),
                  ),
                  child: Icon(
                    icon,
                    color: TColor.primary,
                    size: 20,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: TColor.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      if (onTap != null)
                        InkWell(
                          onTap: onTap,
                          child: DefaultTextStyle(
                            style: TextStyle(
                              color: TColor.onSurfaceVariant,
                              fontSize: 14,
                            ),
                            child: child,
                          ),
                        )
                      else
                        DefaultTextStyle(
                          style: TextStyle(
                            color: TColor.onSurfaceVariant,
                            fontSize: 14,
                          ),
                          child: child,
                        ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: TColor.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//==========this is a dialog==============
Future<dynamic> customDialog(
  BuildContext context,
  TextEditingController name,
  TextEditingController specialty,
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
              CustomTextForm(
                hinttext: "New Specialty",
                mycontroller: specialty,
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
