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
  final String? title;

  const CustomAppBar({
    super.key,
    this.title,
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
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            // color: TColor.background,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (widget.title != null)
                Text(
                  widget.title!,
                  style: TextStyle(
                    color: TColor.onSurface,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )
              else
                Obx(
                  () => Column(
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
              // Profile Avatar
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
        ),
        // Add divider only if title is shown
        if (widget.title != null)
          Divider(
            height: 1,
            color: TColor.primary.withOpacity(0.2),
          ),
      ],
    );
  }
}
