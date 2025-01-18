// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studymate/common_widgets/custom_button.dart';

import '../../controller/academic_year_controller.dart';
import '../../theme.dart';
import 'student_main_nav_bar.dart';

class AcdemicYear extends StatefulWidget {
  const AcdemicYear({super.key});

  @override
  State<AcdemicYear> createState() => _AcdemicYearState();
}

class _AcdemicYearState extends State<AcdemicYear> {
  bool isClicked = false;
  List<String> yearOpt = [
    "1",
    "2",
    "3",
    "4",
  ];
  final academicController = Get.put(AcademicYearController());
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: TColor.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeInDown(
                      delay: Duration(milliseconds: 500),
                      child: Text(
                        "What is your academic year?",
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    FadeInDown(
                      delay: Duration(milliseconds: 600),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color(0xFFEDEDED),
                            borderRadius: BorderRadius.circular(15)),
                        width: width / 0.5,
                        child: DropdownButton<String>(
                          hint: Obx(() =>
                              academicController.firstYear.value.isEmpty
                                  ? Text(
                                      "First year",
                                      style: TextStyle(
                                          color: TColor.black.withOpacity(0.5)),
                                    )
                                  : Text(academicController.firstYear.value,
                                      style: TextStyle(color: TColor.black))),
                          items: yearOpt.map((String service) {
                            return DropdownMenuItem<String>(
                              value: service,
                              child: Row(
                                children: [
                                  Text(
                                    service,
                                    style: TextStyle(
                                        color: TColor.black.withOpacity(0.5)),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),

                          iconSize: 50,
                          icon: Icon(Icons.keyboard_arrow_down),
                          isExpanded: true,

                          padding: EdgeInsets.symmetric(horizontal: 12),
                          underline: Text(
                            "",
                            style: TextStyle(color: TColor.white),
                          ),
                          onChanged: (String? val) {
                            if (val != null) {
                              academicController.firstYear.value = val;
                            }
                          }, //o Implement your logic here when a selection changes
                        ),
                      ),
                    ),
                    SizedBox(height: 25),
                    FadeInDown(
                      delay: Duration(milliseconds: 700),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color(0xFFEDEDED),
                            borderRadius: BorderRadius.circular(15)),
                        width: width / 0.5,
                        child: DropdownButton<String>(
                          hint: Obx(() =>
                              academicController.secondYear.value.isEmpty
                                  ? Text(
                                      "Second year",
                                      style: TextStyle(
                                          color: TColor.black.withOpacity(0.5)),
                                    )
                                  : Text(academicController.secondYear.value,
                                      style: TextStyle(color: TColor.black))),
                          items: yearOpt.map((String service) {
                            return DropdownMenuItem<String>(
                              value: service,
                              child: Row(
                                children: [
                                  Text(
                                    service,
                                    style: TextStyle(
                                        color: TColor.black.withOpacity(0.5)),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),

                          iconSize: 50,
                          icon: Icon(Icons.keyboard_arrow_down),
                          isExpanded: true,

                          padding: EdgeInsets.symmetric(horizontal: 12),
                          underline: Text(
                            "",
                            style: TextStyle(color: TColor.white),
                          ),
                          onChanged: (String? val) {
                            if (val != null) {
                              academicController.secondYear.value = val;
                            }
                          }, //o Implement your logic here when a selection changes
                        ),
                      ),
                    ),
                    SizedBox(height: 25),
                    FadeInDown(
                      delay: Duration(milliseconds: 800),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color(0xFFEDEDED),
                            borderRadius: BorderRadius.circular(15)),
                        width: width / 0.5,
                        child: DropdownButton<String>(
                          hint: Obx(() =>
                              academicController.thirdYear.value.isEmpty
                                  ? Text(
                                      "Third year",
                                      style: TextStyle(
                                          color: TColor.black.withOpacity(0.5)),
                                    )
                                  : Text(academicController.thirdYear.value,
                                      style: TextStyle(color: TColor.black))),
                          items: yearOpt.map((String service) {
                            return DropdownMenuItem<String>(
                              value: service,
                              child: Row(
                                children: [
                                  Text(
                                    service,
                                    style: TextStyle(
                                        color: TColor.black.withOpacity(0.5)),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),

                          iconSize: 50,
                          icon: Icon(Icons.keyboard_arrow_down),
                          isExpanded: true,

                          padding: EdgeInsets.symmetric(horizontal: 12),
                          underline: Text(
                            "",
                            style: TextStyle(color: TColor.white),
                          ),
                          onChanged: (String? val) {
                            if (val != null) {
                              academicController.thirdYear.value = val;
                            }
                          }, //o Implement your logic here when a selection changes
                        ),
                      ),
                    ),
                    SizedBox(height: 25),
                    FadeInDown(
                      delay: Duration(milliseconds: 900),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color(0xFFEDEDED),
                            borderRadius: BorderRadius.circular(15)),
                        width: width / 0.5,
                        child: DropdownButton<String>(
                          hint: Obx(() =>
                              academicController.fourthYear.value.isEmpty
                                  ? Text(
                                      "Fourth year",
                                      style: TextStyle(
                                          color: TColor.black.withOpacity(0.5)),
                                    )
                                  : Text(academicController.fourthYear.value,
                                      style: TextStyle(color: TColor.black))),
                          items: yearOpt.map((String service) {
                            return DropdownMenuItem<String>(
                              value: service,
                              child: Row(
                                children: [
                                  Text(
                                    service,
                                    style: TextStyle(
                                        color: TColor.black.withOpacity(0.5)),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          iconSize: 50,
                          icon: Icon(Icons.keyboard_arrow_down),
                          isExpanded: true,
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          underline: Text(
                            "",
                            style: TextStyle(color: TColor.white),
                          ),
                          onChanged: (String? val) {
                            if (val != null) {
                              academicController.fourthYear.value = val;
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: height / 3),
              FadeInDown(
                delay: Duration(milliseconds: 1000),
                child: CustomButton(
                  title: "Next",
                  onTap: () {
                    Get.off(StudentMainNavBar());
                  },
                ),
              ),
              FadeInDown(
                delay: Duration(milliseconds: 1100),
                child: TextButton(
                  child: Text("Skip"),
                  onPressed: () {
                    Get.off(StudentMainNavBar());
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
