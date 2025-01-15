// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import '../theme.dart';

class CustomAppbar extends StatelessWidget {
  final String name;
  final String tag;
  final IconData icon;
  final void Function()? onPressed;
  CustomAppbar({
    super.key,
    required this.name,
    required this.tag,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FadeInLeft(
          delay: Duration(milliseconds: 350),
          child: CircleAvatar(
            backgroundImage: AssetImage("assets/img/user.png"),
            radius: 40,
          ),
        ),
        SizedBox(width: 15),
        FadeInDown(
          delay: Duration(milliseconds: 500),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //the name of the owner
              Text(name,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 17)),
              Text(
                  // "The mail",
                  tag,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 13)),
            ],
          ),
        ),
        SizedBox(width: 120),
        FadeInRight(
          delay: Duration(milliseconds: 350),
          child: IconButton(
            icon: Icon(
              icon,
              color: TColor.secondary,
              size: 40,
            ),
            onPressed: onPressed,
          ),
        ),
      ],
    );
  }
}
