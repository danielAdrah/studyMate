// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, use_build_context_synchronously

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:studymate/common_widgets/custom_button.dart';

import '../../common_widgets/custom_app_bar.dart';
import '../../controller/cours_controller.dart';
import '../../controller/sign_up_controller.dart';
import '../../controller/store_controller.dart';
import '../../services/notification_service.dart';
import '../../theme.dart';

class CourseReservation extends StatefulWidget {
  const CourseReservation(
      {super.key,
      required this.courseName,
      required this.courseField,
      required this.courseID});
  final String courseName;
  final String courseField;
  final String courseID;

  @override
  State<CourseReservation> createState() => _CourseReservationState();
}

class _CourseReservationState extends State<CourseReservation> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  GetStorage storage = GetStorage();
  final notiService = NotificationService();
  final coursCont = Get.put(CoursController());
  final authController = Get.put(SignUpController());
  final storeController = Get.put(StoreController());
  final courseDate = TextEditingController();
  final courseTime = TextEditingController();
  void clearFields() {
    courseDate.clear();
    courseTime.clear();
  }
  // final String token =  notiService.getDeviceToken();

  @override
  void initState() {
    storeController.fetchUserData();
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
                    courseField: widget.courseField,
                    onTap: () {},
                  )),
                ),
                SizedBox(height: 35),
                FadeInDown(
                  delay: Duration(milliseconds: 800),
                  child: Row(
                    children: [
                      Text(
                        "Choose Professor",
                        style: TextStyle(
                          color: TColor.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 20),
                      //this a dropDown list to choose a professor
                      Expanded(
                        child: Container(
                            decoration: BoxDecoration(
                                color: TColor.white,
                                borderRadius: BorderRadius.circular(15)),
                            // width: 100,
                            child: StreamBuilder(
                                stream: storeController.getProfessorStream(),
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
                                  if (!snapshot.hasData ||
                                      snapshot.data!.isEmpty) {
                                    return Center(
                                      child: Text(
                                        "There are no profrssors yet",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    );
                                  }
                                  return DropdownButton<String>(
                                    hint: Obx(() => coursCont
                                            .professorName.value.isEmpty
                                        ? Text(
                                            " ",
                                            style: TextStyle(
                                                color: TColor.black
                                                    .withOpacity(0.5)),
                                          )
                                        : Text(coursCont.professorName.value,
                                            style: TextStyle(
                                                color: TColor.black))),
                                    items: (snapshot.data
                                            as List<Map<String, dynamic>>)
                                        .map((Map<String, dynamic> entry) {
                                      return DropdownMenuItem<String>(
                                        value: entry[
                                            'name'], // Assuming 'name' is the field containing the professor's name
                                        child: Row(
                                          children: [
                                            Text(
                                              entry['name'],
                                              style: TextStyle(
                                                color: TColor.black
                                                    .withOpacity(0.5),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),

                                    iconSize: 30,
                                    icon: Icon(Icons.keyboard_arrow_down),
                                    isExpanded: true,

                                    padding:
                                        EdgeInsets.symmetric(horizontal: 12),
                                    underline: Text(
                                      "",
                                      style: TextStyle(color: TColor.white),
                                    ),
                                    onChanged: (String? val) {
                                      if (val != null) {
                                        coursCont.professorName.value = val;
                                        print(coursCont.professorName.value);
                                      }
                                    }, //o Implement your logic here when a selection changes
                                  );
                                })),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                FadeInDown(
                  delay: Duration(milliseconds: 900),
                  child: Row(
                    children: [
                      Text(
                        "Choose Date",
                        style: TextStyle(
                          color: TColor.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 60),
                      //====to select course date
                      Expanded(
                        child: DateTextField(
                          controller: courseDate,
                          onTap: showDate,
                          width: 200,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                FadeInDown(
                  delay: Duration(milliseconds: 1000),
                  child: Row(
                    children: [
                      Text(
                        "Choose Time",
                        style: TextStyle(
                          color: TColor.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 60),
                      //====to select course time
                      Expanded(
                        child: DateTextField(
                          controller: courseTime,
                          onTap: showTimePicke,
                          width: 200,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 50),
                FadeInDown(
                  delay: Duration(milliseconds: 1100),
                  child: Center(
                    child: CustomButton(
                      title: "Book",
                      onTap: () {
                        //first we check if the user has select all the required data
                        //if he doesn't we will display for him a warring dialog
                        //if he selects everything we will proceed the booking method

                        if (storeController.userActivaty.value == true) {
                          if (courseDate.text.isEmpty ||
                              courseTime.text.isEmpty ||
                              coursCont.professorName.value.isEmpty) {
                            print("error");
                            customDialog(context);
                          } else {
                            storeController.reserveCourse(
                              widget.courseName,
                              widget.courseField,
                              coursCont.professorName.value,
                              courseDate.text,
                              courseTime.text,
                              widget.courseID,
                            );
                            notiService.sendNotifications("body", "title",
                                storeController.userToken.value);
                            print("done");
                            clearFields();
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Your account is inActive")),
                          );
                        }
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

//==========this is a dialog==============
  Future<dynamic> customDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              icon: Icon(
                Icons.info_outline,
                size: 50,
                color: TColor.primary,
              ),
              backgroundColor: TColor.background,
              title: Center(
                  child: Column(
                children: [
                  Text(
                    "Please Be Aware",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 19,
                        color: TColor.black),
                  ),
                  Text(
                    "The fields can't be empty ",
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 17,
                        color: TColor.black),
                  ),
                ],
              )),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 50, vertical: 30),
              content: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 13, horizontal: 15),
                  decoration: BoxDecoration(
                    color: TColor.primary,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "OK",
                        style: TextStyle(
                            color: TColor.white, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              )
              // actions: [
              //   CommunityBtn(
              //     title: "Ok",
              //     onTap: () {
              //       Get.back();
              //     },
              //   ),
              // ],
              );
        });
  }

  //this method to select a date
  Future<void> showDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(3000),
      barrierColor: Colors.grey,
    );
    if (picked != null) {
      courseDate.text = picked.toString().substring(0, 10);
      print(courseDate.text);
    }
  }

  //method to select a time
  Future<void> showTimePicke() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      courseTime.text = pickedTime.format(context).toString();
      print(courseTime.text);
    }
  }
}

//=========the selected course cell===========
class CourseCell2 extends StatelessWidget {
  CourseCell2({
    super.key,
    required this.courseName,
    required this.courseField,
    required this.onTap,

    // required this.courseImg,
  });
  void Function()? onTap;
  final String courseName;
  final String courseField;
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
              Text(
                courseField,
                style: TextStyle(
                    color: TColor.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//===========textField to display course date============
class DateTextField extends StatelessWidget {
  DateTextField(
      {super.key,
      required this.onTap,
      required this.controller,
      required this.width});
  void Function()? onTap;
  TextEditingController controller;
  final double width;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 2),
      height: 50,
      width: width,
      decoration: BoxDecoration(
        color: TColor.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: TextField(
          onTap: onTap,
          readOnly: true,
          style:
              TextStyle(color: TColor.black, decoration: TextDecoration.none),
          controller: controller,
          obscureText: false,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 10),
            focusedBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
