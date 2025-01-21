// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:studymate/common_widgets/custom_button.dart';

import '../../common_widgets/custom_app_bar.dart';
import '../../theme.dart';

class ProfessorCourseView extends StatefulWidget {
  const ProfessorCourseView({super.key});

  @override
  State<ProfessorCourseView> createState() => _ProfessorCourseViewState();
}

class _ProfessorCourseViewState extends State<ProfessorCourseView> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
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
                    height: 190,
                    child: ListView.builder(
                        //this is a list if booked course by the user
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return ProfessorCourseCell(
                            courseName: "Programming",
                            onTapDelete: () {},
                            onTapEdit: () {},
                          );
                        }),
                  ),
                ),
                SizedBox(height: height / 3),
                Center(child: CustomButton(title: "Add Course", onTap: () {})),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfessorCourseCell extends StatelessWidget {
  ProfessorCourseCell({
    super.key,
    required this.courseName,
    required this.onTapEdit,
    required this.onTapDelete,

    // required this.courseImg,
  });
  void Function()? onTapEdit;
  void Function()? onTapDelete;
  final String courseName;

  // final String courseImg;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 20),
      width: 130,
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
              // child: Center(
              //   child: Image.asset(courseImg),
              // ),
            ),
            SizedBox(height: 6),
            Text(
              courseName,
              style: TextStyle(
                  color: TColor.black,
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 18),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              InkWell(onTap: onTapEdit, child: Text("Edit")),
              InkWell(onTap: onTapDelete, child: Text("Delete")),
            ]),
          ],
        ),
      ),
    );
  }
}
