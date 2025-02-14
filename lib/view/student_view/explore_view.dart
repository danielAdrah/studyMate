// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../common_widgets/course_cell.dart';
import '../../common_widgets/custom_app_bar.dart';
import '../../common_widgets/custome_text_field.dart';
import '../../common_widgets/professor_cell.dart';
import '../../controller/store_controller.dart';
import '../../theme.dart';
import 'community_view/first_year.dart';
import 'community_view/fourth_year.dart';
import 'community_view/second_year.dart';
import 'community_view/third_year.dart';
import 'course_reservation.dart';

class ExploreView extends StatefulWidget {
  const ExploreView({super.key});

  @override
  State<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> {
  bool haveCourseSearched = false;
  final searchCont = TextEditingController();
  final controller = Get.put(StoreController());

  @override
  void initState() {
    controller.getAllCourse();
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
              SizedBox(height: 20),
              FadeInDown(
                  delay: Duration(milliseconds: 600),
                  child: SearchAndFilter(
                    searchCont: searchCont,
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        setState(() {
                          haveCourseSearched = true; // Reset search state
                        });
                      } else {
                        setState(() {
                          haveCourseSearched = false; // Reset search state
                        });
                      }
                    },
                  )),
              SizedBox(height: 25),
              FadeInDown(
                delay: Duration(milliseconds: 700),
                child: Text(
                  "Popular Professors",
                  style: TextStyle(
                    color: TColor.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 30),
              //list of professors
              FadeInDown(
                delay: Duration(milliseconds: 750),
                child: SizedBox(
                  width: double.infinity,
                  height: 170,
                  child: StreamBuilder(
                      stream: controller.getProfessorStream(),
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
                              "There are no profrssors yet",
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
                              var pro = snapshot.data![index];
                              return ProfessorCell(
                                  profName: pro[
                                      'name'], //this is the name of the professor
                                  profImg:
                                      "assets/img/woman.png", //this is the professor image
                                  profField: pro[
                                      'specialty'], //this is the field which the professor studes in
                                  onTap:
                                      () {} //this will navigate us to the selected professor detail page
                                  );
                            });
                      }),
                ),
              ),

              SizedBox(height: 15),
              FadeInDown(
                delay: Duration(milliseconds: 850),
                child: Text(
                  "Popular Courses",
                  style: TextStyle(
                    color: TColor.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 30),
              // controller.allCourse.isEmpty
              //     ? FadeInDown(
              //         delay: Duration(milliseconds: 880),
              //         child: Text(
              //           "There are no courses to display yet!",
              //           textAlign: TextAlign.center,
              //           style: TextStyle(
              //               color: Colors.black,
              //               fontWeight: FontWeight.bold,
              //               fontSize: 17),
              //         ),
              //       )
              //     :
              //list of courses
              SizedBox(
                width: double.infinity,
                height: 150,
                child: FadeInDown(
                  delay: Duration(milliseconds: 900),
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("courses")
                          .snapshots(),
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

                        if (snapshot.hasData || snapshot.data != null) {
                          List snap = snapshot.data!.docs;
                          if (haveCourseSearched) {
                            snap.removeWhere((e) {
                              return !e
                                  .data()["courseName"]
                                  .toString()
                                  .toLowerCase()
                                  .startsWith(searchCont.text);
                            });
                            return ListView.builder(
                                physics: BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemCount: snap.length,
                                itemBuilder: (context, index) {
                                  var course = snap[index];
                                  return CourseCell(
                                    courseName: course['courseName'],
                                    courseField: course['courseField'],
                                    onTap: () {
                                      Get.to(CourseReservation(
                                        courseName: course['courseName'],
                                        courseField: course['courseField'],
                                        courseID: course.id,
                                      ));
                                    },
                                  );
                                });
                          } else {
                            return ListView.builder(
                                physics: BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemCount: snap.length,
                                itemBuilder: (context, index) {
                                  var course = snap[index];
                                  return CourseCell(
                                    courseName: course['courseName'],
                                    courseField: course['courseField'],
                                    onTap: () {
                                      Get.to(CourseReservation(
                                        courseName: course['courseName'],
                                        courseField: course['courseField'],
                                        courseID: course.id,
                                      ));
                                    },
                                  );
                                });
                          }
                        } else {
                          return Center(
                            child: Text(
                              "There are no courses yet",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          );
                        }
                      }),
                ),
              ),

              SizedBox(height: 30),
              FadeInDown(
                delay: Duration(milliseconds: 1000),
                child: Container(
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(1, 1.5),
                        blurRadius: 0.2,
                        blurStyle: BlurStyle.outer,
                      )
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.all(10),
                        height: 250,
                        width: 150,
                        decoration: BoxDecoration(
                          color: Color(0XFFFF9F92),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: SvgPicture.asset("assets/img/community.svg",
                              width: 120),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 15),
                          Text(
                            "Community",
                            style: TextStyle(
                              color: TColor.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 20),
                          CommunityBtn(
                              title: "First Year",
                              onTap: () {
                                Get.to(FirstYear());
                              }),
                          SizedBox(height: 10),
                          CommunityBtn(
                              title: "Second Year",
                              onTap: () {
                                Get.to(SecondYear());
                              }),
                          SizedBox(height: 10),
                          CommunityBtn(
                              title: "Third Year",
                              onTap: () {
                                Get.to(ThirdYear());
                              }),
                          SizedBox(height: 10),
                          CommunityBtn(
                              title: "Fourth Year",
                              onTap: () {
                                Get.to(FourthYear());
                              }),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        )),
      ),
    );
  }
}

//===========community button==================
class CommunityBtn extends StatelessWidget {
  CommunityBtn({
    super.key,
    required this.title,
    required this.onTap,
  });
  final String title;
  void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 6, horizontal: 20),
        decoration: BoxDecoration(
          color: TColor.primary,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          title,
          style: TextStyle(color: TColor.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

//==================search && filter===========================
class SearchAndFilter extends StatelessWidget {
  SearchAndFilter({
    super.key,
    required this.searchCont,
    this.onChanged,
  });

  final TextEditingController searchCont;
  void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 300,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(1, 1.5),
                blurRadius: 0.2,
                blurStyle: BlurStyle.outer,
              )
            ],
            borderRadius: BorderRadius.circular(30),
          ),
          child: CustomTextForm(
            hinttext: "Search your course",
            mycontroller: searchCont,
            secure: false,
            suffixIcon: Icons.search,
            color: TColor.primary,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
