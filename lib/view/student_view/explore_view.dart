// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common_widgets/course_cell.dart';
import '../../common_widgets/custom_app_bar.dart';
import '../../common_widgets/custome_text_field.dart';
import '../../common_widgets/professor_cell.dart';
import '../../theme.dart';
import 'course_reservation.dart';

class ExploreView extends StatefulWidget {
  const ExploreView({super.key});

  @override
  State<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> {
  final searchCont = TextEditingController();
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
                    child: SearchAndFilter(searchCont: searchCont)),
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
                    height: 150,
                    child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return ProfessorCell(
                              profName:
                                  "Jalal Ahmad", //this is the name of the professor
                              profImg:
                                  "assets/img/user.png", //this is the professor image
                              profField:
                                  "DataBase", //this is the field which the professor studes in
                              onTap:
                                  () {} //this will navigate us to the selected professor detail page
                              );
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
                //list of courses
                FadeInDown(
                  delay: Duration(milliseconds: 900),
                  child: SizedBox(
                    width: double.infinity,
                    height: 150,
                    child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return CourseCell(
                            courseName: "Programming",
                            courseField: "something",
                            onTap: () {
                              Get.to(CourseReservation());
                            },
                          );
                        }),
                  ),
                ),
                SizedBox(height: 20),
                FadeInDown(
                  delay: Duration(milliseconds: 1000),
                  child: Container(
                    width: double.infinity,
                    height: 250,
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
                            color: TColor.primary,
                            borderRadius: BorderRadius.circular(20),
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
                            Row(
                              children: [
                                CommunityBtn(
                                  title: "First Year",
                                  onTap: () {},
                                ),
                                SizedBox(width: 3),
                                CommunityBtn(
                                  title: "Second Year",
                                  onTap: () {},
                                ),
                              ],
                            ),
                            SizedBox(height: 40),
                            Row(
                              children: [
                                CommunityBtn(
                                  title: "Third Year",
                                  onTap: () {},
                                ),
                                SizedBox(width: 3),
                                CommunityBtn(
                                  title: "Fourth Year",
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
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
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 9),
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
  const SearchAndFilter({
    super.key,
    required this.searchCont,
  });

  final TextEditingController searchCont;

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
            hinttext: "Search your teacher or course",
            mycontroller: searchCont,
            secure: false,
            suffixIcon: Icons.search,
            color: TColor.primary,
          ),
        ),
        SizedBox(width: 9),
        IconButton(
          //this will filter the results
          onPressed: () {},
          icon: Icon(
            Icons.filter_alt_outlined,
            size: 30,
            color: TColor.black,
          ),
        ),
      ],
    );
  }
}
