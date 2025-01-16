// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';

import '../theme.dart';


class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key, required this.name, required this.avatar,
  });
  final String name;
  final String avatar;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
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
          //later will change it when the user selects new image
          Container(child: Image.asset(avatar)),
        ],
      ),
    );
  }
}
