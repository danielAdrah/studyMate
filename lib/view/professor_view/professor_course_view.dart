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
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: TColor.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              // Header Section with App Bar
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      TColor.primary.withOpacity(0.1),
                      TColor.background,
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      CustomAppBar(),
                      SizedBox(height: 40),

                      // Header Title with Stats
                      FadeInDown(
                        delay: Duration(milliseconds: 300),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "My Courses",
                                  style: TextStyle(
                                    color: TColor.black,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Obx(() => Text(
                                      "${controller.profrssorCourse.length} courses created",
                                      style: TextStyle(
                                        color: TColor.black.withOpacity(0.6),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )),
                              ],
                            ),
                            FadeInRight(
                              delay: Duration(milliseconds: 500),
                              child: Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: TColor.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Icon(
                                  Icons.school_rounded,
                                  color: TColor.primary,
                                  size: 30,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ),

              // Courses Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // Course List
                    SlideInUp(
                      delay: Duration(milliseconds: 600),
                      child: Container(
                        height: height * 0.32,
                        child: Obx(() {
                          if (controller.profrssorCourse.isEmpty) {
                            return FadeInUp(
                              delay: Duration(milliseconds: 800),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: TColor.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      offset: Offset(0, 5),
                                      blurRadius: 15,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.library_books_outlined,
                                      size: 60,
                                      color: TColor.primary.withOpacity(0.5),
                                    ),
                                    SizedBox(height: 15),
                                    Text(
                                      "No courses yet",
                                      style: TextStyle(
                                        color: TColor.black.withOpacity(0.7),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      "Create your first course to get started",
                                      style: TextStyle(
                                        color: TColor.black.withOpacity(0.5),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          return ListView.builder(
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: controller.profrssorCourse.length,
                            itemBuilder: (context, index) {
                              var course = controller.profrssorCourse[index];
                              return SlideInLeft(
                                delay:
                                    Duration(milliseconds: 700 + (index * 100)),
                                child: ProfessorCourseCell(
                                  courseName: course['courseName'],
                                  courseField:
                                      course['courseField'] ?? 'General',
                                  index: index,
                                  onTapDelete: () {
                                    _showDeleteConfirmation(context, () {
                                      controller.deleteCourse(course.id);
                                    });
                                  },
                                  onTapEdit: () {
                                    newCourseName.text =
                                        course['courseName'] ?? '';
                                    newCourseField.text =
                                        course['courseField'] ?? '';
                                    customDialog(
                                        context, newCourseName, newCourseField,
                                        () {
                                      if (newCourseName.text.isEmpty ||
                                          newCourseField.text.isEmpty) {
                                        Get.snackbar(
                                          "Warning",
                                          "Please fill all the fields",
                                          backgroundColor: TColor.warning,
                                          colorText: TColor.white,
                                        );
                                      } else {
                                        controller.updateCourse(
                                          course.id,
                                          newCourseName.text,
                                          newCourseField.text,
                                        );
                                        newCourseName.clear();
                                        newCourseField.clear();
                                        Get.back();
                                      }
                                    }, "Update Course");
                                  },
                                ),
                              );
                            },
                          );
                        }),
                      ),
                    ),

                    SizedBox(height: 40),

                    // Add Course Button Section
                    FadeInUp(
                      delay: Duration(milliseconds: 900),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              TColor.primary.withOpacity(0.1),
                              TColor.white,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: TColor.primary.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.add_circle_outline,
                              size: 50,
                              color: TColor.primary,
                            ),
                            SizedBox(height: 15),
                            Text(
                              "Ready to create a new course?",
                              style: TextStyle(
                                color: TColor.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Share your knowledge with students",
                              style: TextStyle(
                                color: TColor.black.withOpacity(0.6),
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 20),
                            CustomButton(
                              title: "Create New Course",
                              onTap: () {
                                if (controller.userActivaty.value == true) {
                                  customDialog(context, courseName, courseField,
                                      () {
                                    if (courseName.text.isEmpty ||
                                        courseField.text.isEmpty) {
                                      Get.snackbar(
                                        "Warning",
                                        "Please fill all the fields",
                                        backgroundColor: TColor.warning,
                                        colorText: TColor.white,
                                      );
                                    } else {
                                      controller.addCourse(
                                        courseName.text,
                                        courseField.text,
                                      );
                                      clearFields();
                                      notiService.showNotification(
                                        title: "Course Created Successfully!",
                                        body:
                                            "${courseName.text} has been added to your courses",
                                      );
                                      Get.back();
                                    }
                                  }, "Create Course");
                                } else {
                                  _showInactiveAccountDialog(context);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: TColor.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
              SizedBox(width: 10),
              Text(
                "Delete Course",
                style: TextStyle(
                  color: TColor.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(
            "Are you sure you want to delete this course? This action cannot be undone.",
            style: TextStyle(
              color: TColor.black.withOpacity(0.7),
              fontSize: 16,
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Get.back(),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side:
                            BorderSide(color: TColor.primary.withOpacity(0.3)),
                      ),
                    ),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: TColor.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      onConfirm();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Delete",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _showInactiveAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: TColor.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.lock_outline, color: Colors.orange, size: 28),
              SizedBox(width: 10),
              Text(
                "Account Inactive",
                style: TextStyle(
                  color: TColor.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(
            "Your account is currently inactive. Please contact the administrator to activate your account.",
            style: TextStyle(
              color: TColor.black.withOpacity(0.7),
              fontSize: 16,
            ),
          ),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: TColor.primary,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "OK",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class ProfessorCourseCell extends StatelessWidget {
  ProfessorCourseCell({
    super.key,
    required this.courseName,
    required this.courseField,
    required this.index,
    required this.onTapEdit,
    required this.onTapDelete,
  });

  final String courseName;
  final String courseField;
  final int index;
  final VoidCallback onTapEdit;
  final VoidCallback onTapDelete;

  @override
  Widget build(BuildContext context) {
    List<List<Color>> gradientColors = [
      [Color(0xFF667eea), Color(0xFF764ba2)],
      [Color(0xFFf093fb), Color(0xFFf5576c)],
      [Color(0xFF4facfe), Color(0xFF00f2fe)],
      [Color(0xFF43e97b), Color(0xFF38f9d7)],
      [Color(0xFFfa709a), Color(0xFFfee140)],
    ];

    Color gradientStart = gradientColors[index % gradientColors.length][0];
    Color gradientEnd = gradientColors[index % gradientColors.length][1];

    return Container(
      margin: EdgeInsets.only(right: 20),
      width: 160,
      child: Card(
        elevation: 8,
        shadowColor: gradientStart.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Colors.white.withOpacity(0.9)],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Course Icon with Gradient Background
                Container(
                  height: 80,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [gradientStart, gradientEnd],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: gradientStart.withOpacity(0.3),
                        offset: Offset(0, 4),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.menu_book_rounded,
                      color: Colors.white,
                      size: 35,
                    ),
                  ),
                ),

                SizedBox(height: 12),

                // Course Name
                Text(
                  courseName,
                  style: TextStyle(
                    color: TColor.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: 4),

                // Course Field
                Text(
                  courseField,
                  style: TextStyle(
                    color: TColor.black.withOpacity(0.6),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: 15),

                // Action Buttons
                Center(
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      GestureDetector(
                        onTap: onTapEdit,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 30, vertical: 6),
                          decoration: BoxDecoration(
                            color: gradientStart.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: gradientStart.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.edit_outlined,
                                color: gradientStart,
                                size: 14,
                              ),
                              SizedBox(width: 4),
                              Text(
                                "Edit",
                                style: TextStyle(
                                  color: gradientStart,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: onTapDelete,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 25, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.red.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                                size: 14,
                              ),
                              SizedBox(width: 4),
                              Text(
                                "Delete",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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

//========== Modern Dialog==============
Future<dynamic> customDialog(BuildContext context, TextEditingController name,
    TextEditingController field, void Function()? onTapCreate, String title) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: TColor.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: Offset(0, 10),
                blurRadius: 30,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with Icon
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      TColor.primary.withOpacity(0.1),
                      TColor.primary.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.school_rounded,
                  color: TColor.primary,
                  size: 50,
                ),
              ),

              SizedBox(height: 20),

              // Title
              Text(
                title,
                style: TextStyle(
                  color: TColor.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 8),

              Text(
                title.contains('Update')
                    ? 'Modify course details'
                    : 'Fill in the course information',
                style: TextStyle(
                  color: TColor.black.withOpacity(0.6),
                  fontSize: 14,
                ),
              ),

              SizedBox(height: 25),

              // Course Name Field
              Container(
                decoration: BoxDecoration(
                  color: TColor.background,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: TColor.primary.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: CustomTextForm(
                  hinttext: "Course Name",
                  mycontroller: name,
                  secure: false,
                ),
              ),

              SizedBox(height: 20),

              // Course Field
              Container(
                decoration: BoxDecoration(
                  color: TColor.background,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: TColor.primary.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: CustomTextForm(
                  hinttext: "Course Field",
                  mycontroller: field,
                  secure: false,
                ),
              ),

              SizedBox(height: 10),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        name.clear();
                        field.clear();
                        Get.back();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                          color: TColor.background,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: TColor.primary.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              color: TColor.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: GestureDetector(
                      onTap: onTapCreate,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              TColor.primary,
                              TColor.primary.withOpacity(0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: TColor.primary.withOpacity(0.3),
                              offset: Offset(0, 4),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            title.contains('Update') ? 'Update' : 'Create',
                            style: TextStyle(
                              color: TColor.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
