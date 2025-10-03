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
                CustomAppBar(),
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
                                if (pro["email"] != auth.currentUser!.email) {
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
                //     ? Center(
                //         child: Text("There are no courses to be displayed yet!",
                //             style: TextStyle(
                //                 color: Colors.black,
                //                 fontWeight: FontWeight.bold)),
                //       )
                //     :
                //     //list of courses
                //     FadeInDown(
                //         delay: Duration(milliseconds: 900),
                //         child: SizedBox(
                //             width: double.infinity,
                //             height: 150,
                //             child: Obx(
                //               () => ListView.builder(
                //                   physics: BouncingScrollPhysics(),
                //                   scrollDirection: Axis.horizontal,
                //                   itemCount: controller.allCourse.length,
                //                   itemBuilder: (context, index) {
                //                     var course = controller.allCourse[index];
                //                     return CourseCell(
                //                       courseName: course['courseName'],
                //                       courseField: course['courseField'],
                //                       onTap: () {},
                //                     );
                //                   }),
                //             )),
                //       ),
                FadeInDown(
                  delay: Duration(milliseconds: 900),
                  child: SizedBox(
                    width: double.infinity,
                    height: 150,
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
                SizedBox(height: 20),

                SizedBox(height: 30),
              ],
            ),
          ),
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
            hinttext: "Search your teacher or course",
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
