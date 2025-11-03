// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../common_widgets/course_cell.dart';
import 'package:get/get.dart';
import '../../common_widgets/custom_app_bar.dart';
import '../../common_widgets/custome_text_field.dart';
import '../../common_widgets/professor_cell.dart';
import '../../controller/store_controller.dart';
import '../../theme.dart';

class ProfessorExplore extends StatefulWidget {
  const ProfessorExplore({super.key});

  @override
  State<ProfessorExplore> createState() => _ProfessorExploreState();
}

class _ProfessorExploreState extends State<ProfessorExplore> {
  final FirebaseAuth auth = FirebaseAuth.instance;
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
    final media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: TColor.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 170,
              floating: true,
              backgroundColor: TColor.background,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      FadeInDown(
                        delay: const Duration(milliseconds: 300),
                        child: Text(
                          "Explore",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: TColor.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      FadeInDown(
                        delay: const Duration(milliseconds: 400),
                        child: Text(
                          "Discover courses and connect with professors",
                          style: TextStyle(
                            fontSize: 16,
                            // color: TColor.black.withOpacity(0.6),
                            color: TColor.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
            // Search Section
            SliverToBoxAdapter(
              child: FadeInDown(
                delay: const Duration(milliseconds: 500),
                child: Padding(
                  padding:
                      const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                  child: _buildModernSearchBar(),
                ),
              ),
            ),

            // Popular Professors Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeInDown(
                      delay: const Duration(milliseconds: 600),
                      child: _buildSectionHeader(
                        "Popular Professors",
                        "Meet our expert educators",
                        Icons.school,
                      ),
                    ),
                    const SizedBox(height: 20),
                    FadeInDown(
                      delay: const Duration(milliseconds: 700),
                      child: SizedBox(
                        width: double.infinity,
                        height: media.height * 0.24,
                        child: StreamBuilder(
                            stream: controller.getProfessorStream(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Text(snapshot.error.toString());
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Text("Please Wait");
                              }
                              if (!snapshot.hasData && snapshot.data!.isEmpty) {
                                return Text("There are no profrssors yet");
                              }
                              return ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    var pro = snapshot.data![index];
                                    if (pro["email"] !=
                                        auth.currentUser!.email) {
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
                                    } else {
                                      return Container();
                                    }
                                  });
                            }),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),

            // Popular Courses Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeInDown(
                      delay: const Duration(milliseconds: 800),
                      child: _buildSectionHeader(
                        "Popular Courses",
                        "Start your learning journey",
                        Icons.book,
                      ),
                    ),
                    const SizedBox(height: 20),
                    FadeInDown(
                      delay: const Duration(milliseconds: 900),
                      child: SizedBox(
                        width: double.infinity,
                        height: media.height * 0.25,
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
                                  color: Colors.red,
                                ));
                              }

                              // if (!snapshot.hasData) {
                              //   return Text(
                              //     "There are no courses yet",
                              //     style: TextStyle(fontWeight: FontWeight.bold),
                              //   );
                              // }
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
                                          coursePrice: "200",
                                          courseTime: "3h",
                                          onTap: () {},
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
                                          courseTime: "3h",
                                          coursePrice: "200",
                                          onTap: () {},
                                        );
                                      });
                                }
                              } else {
                                return Text(
                                  "There are no courses yet",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                );
                              }
                            }),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Modern Search Bar
  Widget _buildModernSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: TColor.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: TColor.primary.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: CustomTextForm(
        hinttext: "Search courses, professors...",
        mycontroller: searchCont,
        secure: false,
        suffixIcon: Icons.search_rounded,
        color: TColor.primary,
        onChanged: (value) {
          if (value.isNotEmpty) {
            setState(() {
              haveCourseSearched = true;
            });
          } else {
            setState(() {
              haveCourseSearched = false;
            });
          }
        },
      ),
    );
  }
}

// Section Header with Icon
Widget _buildSectionHeader(String title, String subtitle, IconData icon) {
  return Row(
    children: [
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: TColor.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: TColor.primary,
          size: 24,
        ),
      ),
      const SizedBox(width: 16),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: TColor.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: TColor.black.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    ],
  );
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
            hinttext: "Search your professor or course",
            onChanged: onChanged,
            mycontroller: searchCont,
            secure: false,
            suffixIcon: Icons.search,
            color: TColor.primary,
          ),
        ),
      ],
    );
  }
}
