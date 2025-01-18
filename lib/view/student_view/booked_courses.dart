// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common_widgets/booked_course_cell.dart';
import '../../common_widgets/custom_app_bar.dart';
import '../../theme.dart';
import 'booked_course_detail.dart';

class BookedCourses extends StatefulWidget {
  const BookedCourses({super.key});

  @override
  State<BookedCourses> createState() => _BookedCoursesState();
}

class _BookedCoursesState extends State<BookedCourses> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                CustomAppBar(
                  name: "Ali",
                  avatar: "assets/img/avatar.png",
                ),
                SizedBox(height: 80),
                FadeInDown(
                  delay: Duration(milliseconds: 500),
                  child: Text(
                    "Booked Courses",
                    style: TextStyle(
                      color: TColor.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                FadeInDown(
                  delay: Duration(milliseconds: 750),
                  child: SizedBox(
                    width: double.infinity,
                    height: 160,
                    child: ListView.builder(
                        //this is a list if booked course by the user
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return BookedCourseCell(
                            courseName: "Programming",
                            onTap: () {
                              Get.to(BookedCourseDetail());
                            },
                          );
                        }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
