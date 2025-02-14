// ignore_for_file: prefer_const_constructors, must_be_immutable, prefer_const_literals_to_create_immutables, avoid_print

import 'package:flutter/material.dart';

import '../theme.dart';

class BookedCourseCell extends StatelessWidget {
  BookedCourseCell({
    super.key,
    required this.courseName,
    required this.onTap,
    required this.courseField,

    // required this.courseImg,
  });
  void Function()? onTap;
  final String courseName;
  final String courseField;

  // final String courseImg;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: 20),
        width: 150,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(1, 1.5),
              blurRadius: 0.2,
              blurStyle: BlurStyle.outer,
            )
          ],
          borderRadius: BorderRadius.circular(20),
          color: TColor.white,
        ),
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                height: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: TColor.primary,
                ),
                child: Center(
                  child: Image.asset("assets/img/online-course.png"),
                ),
              ),
              SizedBox(height: 6),
              Text(
                courseName,
                style: TextStyle(
                    color: TColor.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 5),
              Text(
                courseField,
                style: TextStyle(
                    color: TColor.black,
                    fontSize: 11,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
