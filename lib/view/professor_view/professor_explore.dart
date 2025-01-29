// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
                                return ProfessorCell(
                                    profName: pro[
                                        'name'], //this is the name of the professor
                                    profImg:
                                        "assets/img/pro_avatar.png", //this is the professor image
                                    profField:
                                        "DataBase", //this is the field which the professor studes in
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
                //list of courses
                FadeInDown(
                  delay: Duration(milliseconds: 900),
                  child: SizedBox(
                      width: double.infinity,
                      height: 150,
                      child: Obx(
                        () => ListView.builder(
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: controller.allCourse.length,
                            itemBuilder: (context, index) {
                              var course = controller.allCourse[index];
                              return CourseCell(
                                courseName: course['courseName'],
                                courseField: course['courseField'],
                                onTap: () {},
                              );
                            }),
                      )),
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
          icon: SvgPicture.asset("assets/img/filter.svg"),
        ),
      ],
    );
  }
}
