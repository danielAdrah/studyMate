// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common_widgets/booked_course_cell.dart';
import '../../common_widgets/custom_app_bar.dart';
import '../../controller/store_controller.dart';
import '../../theme.dart';
import 'booked_course_detail.dart';

class BookedCourses extends StatefulWidget {
  const BookedCourses({super.key});

  @override
  State<BookedCourses> createState() => _BookedCoursesState();
}

class _BookedCoursesState extends State<BookedCourses> {
  final storeController = Get.put(StoreController());

  @override
  void initState() {
    storeController.fetchBookedCoursesStream();
    super.initState();
  }

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
                    height: 150,
                    child: StreamBuilder(
                        stream: storeController.fetchBookedCoursesStream(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text(snapshot.error.toString());
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                                child: CircularProgressIndicator(
                                    color: TColor.primary));
                          }
                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return Center(
                              child: Text(
                                "You haven't booked any courses yet!",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            );
                          }
                          return ListView.builder(
                              physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                var bookedCourse = snapshot.data![index];
                                return BookedCourseCell(
                                  courseName: bookedCourse['courseName'],
                                  onTap: () {
                                    Get.to(BookedCourseDetail(
                                      courseID: bookedCourse['id'],
                                      courseName: bookedCourse['courseName'],
                                    ));
                                  },
                                );
                              });
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
