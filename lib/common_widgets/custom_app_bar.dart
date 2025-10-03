// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors

import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/cours_controller.dart';
import '../controller/store_controller.dart';
import '../theme.dart';
import '../view/student_view/profile_view.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({
    super.key,
 
  });


  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  final controller = Get.put(CoursController());
  final storeController = Get.put(StoreController());
  final FirebaseAuth auth = FirebaseAuth.instance;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  

  @override
  void initState() {
    super.initState();
    storeController.fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
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
                Text(storeController.userFullName.value,
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
              child: CircleAvatar(
                  radius: 30,
                  backgroundImage: controller.imagePath.value == null
                      ? AssetImage("assets/img/user.png")
                      : FileImage(File(controller.imagePath.value!))
                          as ImageProvider<Object>?),
            ),
          ),
        ],
      ),
    );
  }
}
