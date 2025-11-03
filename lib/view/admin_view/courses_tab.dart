// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12),
            Text('Course deleted successfully'),
          ],
        ),
        backgroundColor: TColor.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(
      BuildContext context, String courseId, String courseName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: TColor.surface,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: TColor.error.withOpacity(0.1),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: TColor.error.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.warning_outlined,
                    size: 32,
                    color: TColor.error,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Delete Course",
                  style: TextStyle(
                    color: TColor.onSurface,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  "Are you sure you want to delete '$courseName'? This action cannot be undone.",
                  style: TextStyle(
                    color: TColor.onSurfaceVariant,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              TColor.onSurfaceVariant.withOpacity(0.1),
                          foregroundColor: TColor.onSurface,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text("Cancel"),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          HapticFeedback.heavyImpact();
                          Navigator.of(context).pop();
                          deleteCourse(courseId);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TColor.error,
                          foregroundColor: TColor.onPrimary,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: Text("Delete"),
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

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: TColor.background,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              TColor.background,
              TColor.primary.withOpacity(0.03),
              TColor.secondary.withOpacity(0.02),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  AdminAppbar(),
                  SizedBox(height: 32),

                  // Header Section with Course Stats
                  FadeInDown(
                    delay: Duration(milliseconds: 300),
                    child: Container(
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: TColor.surface,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: TColor.primary.withOpacity(0.1),
                            blurRadius: 20,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: TColor.secondary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              Icons.school,
                              color: TColor.secondary,
                              size: 32,
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Course Management",
                                  style: TextStyle(
                                    color: TColor.onSurface,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Manage courses and curriculum",
                                  style: TextStyle(
                                    color: TColor.onSurfaceVariant,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 24),

                  // Search Section
                  FadeInDown(
                    delay: Duration(milliseconds: 400),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: TColor.surface,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: TColor.primary.withOpacity(0.08),
                            blurRadius: 15,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: SearchAndFilter(
                        searchCont: searchCont,
                        onChanged: (value) {
                          HapticFeedback.lightImpact();
                          if (value.isNotEmpty) {
                            setState(() {
                              isUserSearched = true;
                            });
                          } else {
                            setState(() {
                              isUserSearched = false;
                            });
                          }
                        },
                      ),
                    ),
                  ),

                  SizedBox(height: 24),

                  // Courses List Header with Add Button
                  FadeInDown(
                    delay: Duration(milliseconds: 500),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: TColor.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.library_books,
                                color: TColor.primary,
                                size: 24,
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              "All Courses",
                              style: TextStyle(
                                color: TColor.onSurface,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacer(),
                            StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection("courses")
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  int courseCount = snapshot.data!.docs.length;
                                  return Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: TColor.secondary.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      "$courseCount courses",
                                      style: TextStyle(
                                        color: TColor.secondary,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  );
                                }
                                return SizedBox.shrink();
                              },
                            ),
                            SizedBox(width: 12),
                          ],
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: () {
                            HapticFeedback.mediumImpact();
                            addDialog(context, courseName, courseField, () {
                              storeController.addCourse(
                                  courseName.text, courseField.text);
                              courseName.clear();
                              courseField.clear();
                              Get.back();
                            }, "Add");
                          },
                          icon: Icon(Icons.add, size: 20),
                          label: Text("Add Course"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: TColor.primary,
                            foregroundColor: TColor.onPrimary,
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 4,
                            shadowColor: TColor.primary.withOpacity(0.3),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),
                  SizedBox(height: 20),

                  // Courses Grid
                  SizedBox(
                    width: double.infinity,
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("courses")
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Container(
                              padding: EdgeInsets.all(32),
                              decoration: BoxDecoration(
                                color: TColor.error.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                children: [
                                  Icon(Icons.error_outline,
                                      color: TColor.error, size: 48),
                                  SizedBox(height: 16),
                                  Text(
                                    "Error loading courses",
                                    style: TextStyle(
                                        color: TColor.error,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            );
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Container(
                              padding: EdgeInsets.all(48),
                              child: Center(
                                child: Column(
                                  children: [
                                    CircularProgressIndicator(
                                        color: TColor.primary),
                                    SizedBox(height: 16),
                                    Text(
                                      "Loading courses...",
                                      style: TextStyle(
                                        color: TColor.onSurfaceVariant,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          if (snapshot.hasData || snapshot.data != null) {
                            List snap = snapshot.data!.docs;
                            if (isUserSearched) {
                              snap.removeWhere((e) {
                                return !e
                                    .data()["courseName"]
                                    .toString()
                                    .toLowerCase()
                                    .startsWith(searchCont.text.toLowerCase());
                              });
                            }

                            if (snap.isEmpty) {
                              return Container(
                                padding: EdgeInsets.all(48),
                                decoration: BoxDecoration(
                                  color: TColor.surface,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  children: [
                                    Icon(Icons.school_outlined,
                                        color: TColor.onSurfaceVariant,
                                        size: 64),
                                    SizedBox(height: 16),
                                    Text(
                                      isUserSearched
                                          ? "No courses found"
                                          : "No courses yet",
                                      style: TextStyle(
                                        color: TColor.onSurface,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      isUserSearched
                                          ? "Try a different search term"
                                          : "Add your first course to get started",
                                      style: TextStyle(
                                        color: TColor.onSurfaceVariant,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }

                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: snap.length,
                              itemBuilder: (context, index) {
                                var course = snap[index];
                                return FadeInDown(
                                  delay: Duration(
                                      milliseconds: 600 + (index * 100)),
                                  child: CoueseTile(
                                    name: course['courseName'],
                                    field: course['courseField'],
                                    editOnPressed: () {
                                      HapticFeedback.lightImpact();
                                      customDialog(context, newName, newField,
                                          () {
                                        storeController.updateCourse(course.id,
                                            newName.text, newField.text);
                                        clearFields();
                                        Get.back();
                                      }, "Edit");
                                    },
                                    deleteOnPressed: () {
                                      HapticFeedback.heavyImpact();
                                      _showDeleteConfirmation(context,
                                          course.id, course['courseName']);
                                    },
                                  ),
                                );
                              },
                            );
                          } else {
                            return Container(
                              padding: EdgeInsets.all(48),
                              child: Center(
                                child: Text(
                                  "No data available",
                                  style: TextStyle(
                                    color: TColor.onSurfaceVariant,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            );
                          }
                        }),
                  ),

                  SizedBox(height: 32),
                ],
              ),
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
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: TColor.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: TColor.primary.withOpacity(0.08),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            // Header with Course Icon and Details
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    TColor.secondary.withOpacity(0.1),
                    TColor.primary.withOpacity(0.05),
                  ],
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [TColor.secondary, TColor.primary],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: TColor.secondary.withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.school,
                        color: TColor.onPrimary,
                        size: 28,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            color: TColor.onSurface,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: TColor.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            field,
                            style: TextStyle(
                              color: TColor.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Action Buttons
            Container(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: editOnPressed,
                      icon: Icon(Icons.edit_outlined, size: 18),
                      label: Text("Edit"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColor.secondary,
                        foregroundColor: TColor.onPrimary,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: deleteOnPressed,
                      icon: Icon(Icons.delete_outline, size: 18),
                      label: Text("Delete"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColor.error,
                        foregroundColor: TColor.onPrimary,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: TColor.primary.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: TextFormField(
              controller: searchCont,
              onChanged: onChanged,
              style: TextStyle(
                color: TColor.onSurface,
                fontSize: 16,
              ),
              decoration: InputDecoration(
                hintText: "Search courses by name...",
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: TColor.onSurfaceVariant,
                ),
                prefixIcon: Container(
                  margin: EdgeInsets.all(12),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: TColor.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.search,
                    color: TColor.secondary,
                    size: 20,
                  ),
                ),
                suffixIcon: searchCont.text.isNotEmpty
                    ? InkWell(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          searchCont.clear();
                          if (onChanged != null) onChanged!("");
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          margin: EdgeInsets.all(12),
                          padding: EdgeInsets.all(4),
                          child: Icon(
                            Icons.clear,
                            color: TColor.onSurfaceVariant,
                            size: 16,
                          ),
                        ),
                      )
                    : null,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 20,
                ),
                filled: true,
                fillColor: TColor.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: TColor.primary.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: TColor.secondary,
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 12),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: TColor.primary.withOpacity(0.1),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              // TODO: Add filter functionality
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Filter options coming soon!"),
                  backgroundColor: TColor.primary,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: TColor.primary,
              foregroundColor: TColor.onPrimary,
              padding: EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
            ),
            child: Icon(Icons.filter_list, size: 24),
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
      return Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: TColor.surface,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: TColor.primary.withOpacity(0.1),
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: TColor.secondary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  "assets/img/course.svg",
                  color: TColor.secondary,
                  width: 32,
                  height: 32,
                ),
              ),

              SizedBox(height: 20),

              Text(
                "$title Course",
                style: TextStyle(
                  color: TColor.onSurface,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 24),

              // Course Name Field
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: TColor.primary.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: name,
                  style: TextStyle(
                    color: TColor.onSurface,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    hintText: "Course Name",
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: TColor.onSurfaceVariant,
                    ),
                    prefixIcon: Container(
                      margin: EdgeInsets.all(12),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: TColor.secondary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.school_outlined,
                        color: TColor.secondary,
                        size: 20,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 20,
                    ),
                    filled: true,
                    fillColor: TColor.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: TColor.secondary,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 16),

              // Course Field
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: TColor.primary.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: field,
                  style: TextStyle(
                    color: TColor.onSurface,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    hintText: "Course Field",
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: TColor.onSurfaceVariant,
                    ),
                    prefixIcon: Container(
                      margin: EdgeInsets.all(12),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: TColor.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.category_outlined,
                        color: TColor.primary,
                        size: 20,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 20,
                    ),
                    filled: true,
                    fillColor: TColor.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: TColor.primary,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 24),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            TColor.onSurfaceVariant.withOpacity(0.1),
                        foregroundColor: TColor.onSurface,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        if (onTapCreate != null) onTapCreate();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColor.secondary,
                        foregroundColor: TColor.onPrimary,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                        shadowColor: TColor.secondary.withOpacity(0.3),
                      ),
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
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

//=============
Future<dynamic> addDialog(BuildContext context, TextEditingController name,
    TextEditingController field, void Function()? onTapCreate, String title) {
  return customDialog(context, name, field, onTapCreate, title);
}
