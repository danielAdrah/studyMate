// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';

class ServiceCell extends StatelessWidget {
  ServiceCell({
    super.key,
    required this.colors,
    required this.category,
    this.width,
    required this.img, 
    required this.onTap,
  });

  final Color colors;
  final String category;
  final String img;
  double? width;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 100,
            width: width,
            decoration: BoxDecoration(
              color: colors,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Image.asset(
                img,
                color: Colors.white,
                width: 60,
                height: 60,
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            category,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }
}
