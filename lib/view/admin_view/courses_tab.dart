// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../common_widgets/custome_text_field.dart';
import '../../controller/store_controller.dart';
import '../../theme.dart';
import 'admin_appBar.dart';

class CoursesTab extends StatefulWidget {
  const CoursesTab({super.key});

  @override
  State<CoursesTab> createState() => _CoursesTabState();
}

class _CoursesTabState extends State<CoursesTab> {
  final storeController = Get.put(StoreController());
  final searchCont = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final newName = TextEditingController();
  final courseName = TextEditingController();
  final courseField = TextEditingController();

  final newField = TextEditingController();
  bool isUserSearched = false;

  clearFields() {
    newName.clear();
    newField.clear();
  }

  deleteCourse(String id) async {
    final currentUser = auth.currentUser;

    await FirebaseFirestore.instance.collection("courses").doc(id).delete();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('The course has been deleted')),
    );
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
                AdminAppbar(
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
                            isUserSearched = true; // Reset search state
                          });
                        } else {
                          setState(() {
                            isUserSearched = false; // Reset search state
                          });
                        }
                      },
                    )),
                SizedBox(height: 20),
                FadeInDown(
                  delay: Duration(milliseconds: 500),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "All Courses",
                        style: TextStyle(
                          color: TColor.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          addDialog(context, courseName, courseField, () {
                            storeController.addCourse(
                                courseName.text, courseField.text);
                            courseName.clear();
                            courseField.clear();
                            Get.back();
                          }, "Add");
                        },
                        child: Text(
                          "Add Course",
                          style: TextStyle(
                            // color: TColor.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
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
                          if (isUserSearched) {
                            snap.removeWhere((e) {
                              return !e
                                  .data()["courseName"]
                                  .toString()
                                  .toLowerCase()
                                  .startsWith(searchCont.text);
                            });
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: snap.length,
                              itemBuilder: (context, index) {
                                var course = snap[index];
                                return FadeInDown(
                                  delay: Duration(milliseconds: 650),
                                  child: CoueseTile(
                                    name: course['courseName'],
                                    field: course['courseField'],
                                    editOnPressed: () {
                                      customDialog(context, newName, newField,
                                          () {
                                        storeController.updateCourse(course.id,
                                            newName.text, newField.text);
                                        clearFields();
                                        Get.back();
                                      }, "Edit");
                                    },
                                    deleteOnPressed: () {
                                      deleteCourse(course.id);
                                    },
                                  ),
                                );
                              },
                            );
                          } else {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: snap.length,
                              itemBuilder: (context, index) {
                                var course = snap[index];
                                return FadeInDown(
                                  delay: Duration(milliseconds: 650),
                                  child: CoueseTile(
                                    name: course['courseName'],
                                    field: course['courseField'],
                                    editOnPressed: () {
                                      customDialog(context, newName, newField,
                                          () {
                                        storeController.updateCourse(course.id,
                                            newName.text, newField.text);
                                        clearFields();
                                        Get.back();
                                      }, "Edit");
                                    },
                                    deleteOnPressed: () {
                                      deleteCourse(course.id);
                                    },
                                  ),
                                );
                              },
                            );
                          }
                        } else {
                          return Center(
                            child: Text(
                              "There are no users yet",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          );
                        }
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//===============
class CoueseTile extends StatelessWidget {
  const CoueseTile({
    super.key,
    required this.name,
    required this.field,
    this.editOnPressed,
    this.deleteOnPressed,
  });
  final String name;
  final String field;
  final void Function()? editOnPressed;
  final void Function()? deleteOnPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 20),
        padding: EdgeInsets.all(30),
        // height: height / 3,
        decoration: BoxDecoration(
          color: TColor.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 80,
              width: 110,
              decoration: BoxDecoration(
                color: TColor.primary,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            SizedBox(height: 15),
            Text(
              name,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            SizedBox(height: 7),
            Text(
              field,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(onPressed: editOnPressed, child: Text("Edit")),
                TextButton(onPressed: deleteOnPressed, child: Text("Delete")),
              ],
            ),
          ],
        ));
  }
}

//================
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
            hinttext: "Search Users",
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

//================
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

//=============
Future<dynamic> addDialog(BuildContext context, TextEditingController name,
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
