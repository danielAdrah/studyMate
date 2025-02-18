// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, deprecated_member_use

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:studymate/common_widgets/custom_button.dart';

import '../../common_widgets/custom_app_bar.dart';
import '../../common_widgets/custome_text_field.dart';
import '../../controller/store_controller.dart';
import '../../services/notification_service.dart';
import '../../theme.dart';

class ProfessorCourseView extends StatefulWidget {
  const ProfessorCourseView({super.key});

  @override
  State<ProfessorCourseView> createState() => _ProfessorCourseViewState();
}

class _ProfessorCourseViewState extends State<ProfessorCourseView> {
  final controller = Get.put(StoreController());
  final courseName = TextEditingController();
  final courseField = TextEditingController();
  final newCourseName = TextEditingController();
  final newCourseField = TextEditingController();
  final notiService = NotificationService();

  void clearFields() {
    courseName.clear();
    courseField.clear();
  }

  @override
  void initState() {
    controller.getProfessorCourse();
    controller.fetchUserData();
    super.initState();
  }

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
                    "My Courses",
                    style: TextStyle(
                      color: TColor.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                ZoomIn(
                    delay: Duration(milliseconds: 700),
                    child: FadeInDown(
                      delay: Duration(milliseconds: 750),
                      child: SizedBox(
                          width: double.infinity,
                          height: 190,
                          child: Obx(
                            () => ListView.builder(
                                //this is a list if booked course by the user
                                physics: BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemCount: controller.profrssorCourse.length,
                                itemBuilder: (context, index) {
                                  var course =
                                      controller.profrssorCourse[index];
                                  return ProfessorCourseCell(
                                    courseName: course['courseName'],
                                    onTapDelete: () {
                                      controller.deleteCourse(course.id);
                                    },
                                    onTapEdit: () {
                                      customDialog(context, newCourseName,
                                          newCourseField, () {
                                        controller.updateCourse(
                                          course.id,
                                          newCourseName.text,
                                          newCourseField.text,
                                        );
                                        newCourseName.clear();
                                        newCourseField.clear();
                                        Get.back();
                                      }, "Edit");
                                    },
                                  );
                                }),
                          )),
                    )),
                SizedBox(height: height / 3),
                FadeInDown(
                    delay: Duration(milliseconds: 600),
                    child: Center(
                        child: CustomButton(
                            title: "Add Course",
                            onTap: () {
                              if (controller.userActivaty.value == true) {
                                customDialog(context, courseName, courseField,
                                    () {
                                  notiService.showNotification(
                                    title: "You have added a course",
                                    body: "",
                                  );
                                  controller.addCourse(
                                      courseName.text, courseField.text);
                                  clearFields();
                                  Get.back();
                                }, "Create");
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text("This account is anActive")),
                                );
                              }
                            }))),
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

//==========this is a dialog==============
Future<dynamic> customDialog(BuildContext context, TextEditingController name,
    TextEditingController field, void Function()? onTapCreate, String title) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: SvgPicture.asset(
            "assets/img/course.svg",
            color: TColor.primary,
            width: 70,
            height: 70,
          ),
          backgroundColor: TColor.background,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15),
              CustomTextForm(
                hinttext: "Course Name",
                mycontroller: name,
                secure: false,
              ),
              SizedBox(height: 25),
              CustomTextForm(
                hinttext: "Course Field",
                mycontroller: field,
                secure: false,
              ),
              SizedBox(height: 25),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: onTapCreate,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 13, horizontal: 30),
                    decoration: BoxDecoration(
                      color: TColor.primary,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                              color: TColor.white, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 8),
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 13, horizontal: 15),
                    decoration: BoxDecoration(
                      color: TColor.white,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Cancel",
                          style: TextStyle(
                              color: TColor.primary,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      });
}
