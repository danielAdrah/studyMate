// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import '../theme.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
    required this.name,
    required this.avatar,
  });
  final String name;
  final String avatar;

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
              Text(name,
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
            child: Container(child: Image.asset(avatar))),
      ],
    );
  }
}
