// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, use_build_context_synchronously

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studymate/common_widgets/custom_button.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../common_widgets/custom_app_bar.dart';
import '../../controller/store_controller.dart';
import '../../theme.dart';

class BookedCourseDetail extends StatefulWidget {
  const BookedCourseDetail(
      {super.key, required this.courseID, required this.courseName});
  final String courseID;
  final String courseName;
  @override
  State<BookedCourseDetail> createState() => _BookedCourseDetailState();
}

class _BookedCourseDetailState extends State<BookedCourseDetail> {
  final storeController = Get.put(StoreController());
  final comment = TextEditingController();
  double rate = 0.0;
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
                SizedBox(height: 30),
                CustomAppBar(
                  name: "Ali",
                  avatar: "assets/img/avatar.png",
                ),
                SizedBox(height: 80),
                FadeInDown(
                  delay: Duration(milliseconds: 600),
                  child: Center(
                      child: CourseCell2(
                    courseName: widget.courseName,
                    onTap: () {},
                  )),
                ),
                SizedBox(height: 50),
                FadeInDown(
                  delay: Duration(milliseconds: 700),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      color: TColor.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(1, 1.5),
                          blurRadius: 0.2,
                          blurStyle: BlurStyle.outer,
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 50),
                        RatingBar.builder(
                          initialRating: 1,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            print(rating);
                            rate = rating;
                            setState(() {});
                          },
                        ),
                        SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                            controller: comment,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              hintText: "Write A Comment",
                              hintStyle:
                                  TextStyle(fontSize: 14, color: Colors.black),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 20),
                              filled: true,
                              fillColor:
                                  const Color.fromARGB(255, 236, 230, 230),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(35),
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(35),
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(31, 179, 206, 231),
                                  )),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(35),
                                borderSide: BorderSide(
                                  color: Color.fromARGB(31, 179, 206, 231),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 40),
                FadeInDown(
                  delay: Duration(milliseconds: 800),
                  child: Center(
                    child: CustomButton(
                      title: "Submit",
                      onTap: () {
                        storeController.sendFeedBack(
                            widget.courseID, comment.text, rate);
                        comment.clear();
                      },
                    ),
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

//=========the selected course cell===========
class CourseCell2 extends StatelessWidget {
  CourseCell2({
    super.key,
    required this.courseName,
    required this.onTap,

    // required this.courseImg,
  });
  void Function()? onTap;
  final String courseName;

  // final String courseImg;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: 20),
        width: 200,
        height: 200,
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
                height: 130,
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
              //here will be course rate
            ],
          ),
        ),
      ),
    );
  }
}
