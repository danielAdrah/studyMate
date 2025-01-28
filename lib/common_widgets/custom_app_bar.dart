// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors

import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/cours_controller.dart';
import '../theme.dart';
import '../view/student_view/profile_view.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({
    super.key,
    required this.name,
    required this.avatar,
  });
  final String name;
  final String avatar;

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  final controller = Get.put(CoursController());
  final FirebaseAuth auth = FirebaseAuth.instance;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String? userName;

  Future<void> fetchUserData() async {
    final user = auth.currentUser;
    if (user != null) {
      final docSnap = await firestore.collection('users').doc(user.uid).get();
      if (docSnap.exists) {
        setState(() {
          userName = docSnap.get('name');
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FadeInLeft(
          delay: Duration(milliseconds: 500),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Hello!",
                  style: TextStyle(
                      color: TColor.black,
                      fontSize: 22,
                      fontWeight: FontWeight.w700)),
              Text(userName ?? "noo",
                  style: TextStyle(
                      color: TColor.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        //later will change it when the user selects new image
        FadeInRight(
          delay: Duration(milliseconds: 500),
          child: InkWell(
            onTap: () {
              Get.to(ProfileView());
            },
            child: Obx(
              () => CircleAvatar(
                  radius: 30,
                  backgroundImage: controller.imagePath.value == null
                      ? AssetImage("assets/img/user.png")
                      : FileImage(File(controller.imagePath.value!))
                          as ImageProvider<Object>?),
            ),
          ),
        ),
      ],
    );
  }
}
