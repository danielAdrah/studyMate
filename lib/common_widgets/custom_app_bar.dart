// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors

import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
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

  final GetStorage storage = GetStorage();
  @override
  void initState() {
    super.initState();
    var img = storage.read('imagePath');
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
              Text(widget.name,
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
