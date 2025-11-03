// ignore_for_file: deprecated_member_use

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';

import '../../common_widgets/status_cell.dart';
import '../../controller/store_controller.dart';
import '../../services/pdf_api.dart';
import '../../services/pdf_service.dart';
import '../../theme.dart';
import 'admin_appBar.dart';
import '../pdf_viewer_screen.dart';

class ReportsTab extends StatefulWidget {
  const ReportsTab({super.key});

  @override
  State<ReportsTab> createState() => _ReportsTabState();
}

class _ReportsTabState extends State<ReportsTab> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final storeController = Get.put(StoreController());
  late Future<List<dynamic>> students;
  late Future<List<dynamic>> professor;
  late Future<List<dynamic>> allUser;
  List<List<dynamic>> data = [];
  List<List<dynamic>> proData = [];
  List<List<dynamic>> allUserData = [];

  @override
  void initState() {
    super.initState();
    students = storeController.getStudentList();
    students.then((value) {
      setState(() {
        data = value
            .map((student) => [student['name'], student['specialty']])
            .toList();
      });
    });
    //----
    professor = storeController.getProfessorList();
    professor.then((value) {
      setState(() {
        proData = value
            .map((professor) => [professor['name'], professor['specialty']])
            .toList();
      });
    });
    //-----
    allUser = storeController.getUserList();
    allUser.then((value) {
      setState(() {
        allUserData =
            value.map((user) => [user['name'], user['role']]).toList();
      });
    });
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
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const AdminAppbar(),
                  const SizedBox(height: 32),

                  // Header Section with Analytics Overview
                  FadeInDown(
                    delay: const Duration(milliseconds: 300),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: TColor.surface,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: TColor.primary.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: TColor.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              Icons.analytics,
                              color: TColor.primary,
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Analytics Dashboard",
                                  style: TextStyle(
                                    color: TColor.onSurface,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Real-time system statistics and insights",
                                  style: TextStyle(
                                    color: TColor.onSurfaceVariant,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: TColor.success.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: TColor.success,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  "Live",
                                  style: TextStyle(
                                    color: TColor.success,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Statistics Title with Refresh Button
                  FadeInDown(
                    delay: const Duration(milliseconds: 400),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: TColor.secondary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.bar_chart,
                            color: TColor.secondary,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          "App Statistics",
                          style: TextStyle(
                            color: TColor.onSurface,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        ElevatedButton.icon(
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            setState(() {});
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Row(
                                  children: [
                                    Icon(Icons.refresh, color: Colors.white),
                                    SizedBox(width: 12),
                                    Text("Statistics refreshed"),
                                  ],
                                ),
                                backgroundColor: TColor.success,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.refresh, size: 18),
                          label: const Text("Refresh"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: TColor.secondary,
                            foregroundColor: TColor.onPrimary,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  const SizedBox(height: 24),

                  // Statistics Grid - Enhanced Layout
                  FadeInUp(
                    delay: const Duration(milliseconds: 500),
                    child: Column(
                      children: [
                        // Row 1: Courses and Total Users
                        Row(
                          children: [
                            Expanded(
                              child: FadeInLeft(
                                delay: const Duration(milliseconds: 600),
                                child: statusStreamBuilder(
                                  height,
                                  width,
                                  FirebaseFirestore.instance
                                      .collection("courses")
                                      .snapshots(),
                                  "Available Courses",
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color:
                                              TColor.primary.withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        child: Image.asset(
                                          "assets/img/online-education.png",
                                          width: 60,
                                          height: 60,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        "Courses",
                                        style: TextStyle(
                                            color: TColor.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16),
                                      )
                                    ],
                                  ),
                                  () async {
                                    print("Generating Courses PDF...");
                                    try {
                                      final courses = await FirebaseFirestore
                                          .instance
                                          .collection("courses")
                                          .get();
                                      final courseData = courses.docs
                                          .map((doc) => [
                                                doc['courseName'] ?? 'N/A',
                                                doc['courseField'] ?? 'N/A'
                                              ])
                                          .toList();

                                      final pdfFile =
                                          await PdfApi.generateTable(
                                        ['Course Name', 'Field'],
                                        courseData,
                                        'Courses Report',
                                        "In This Report We Are Displaying Information About All Available Courses",
                                        "The Total Number of Courses Is : ",
                                      );
                                      await PdfApi.openFile(pdfFile);
                                    } catch (e) {
                                      print("Error generating PDF: $e");
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              "Failed to generate PDF: $e"),
                                          backgroundColor: TColor.error,
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: FadeInRight(
                                delay: const Duration(milliseconds: 700),
                                child: statusStreamBuilder(
                                  height,
                                  width,
                                  FirebaseFirestore.instance
                                      .collection("users")
                                      .snapshots(),
                                  "Total Users",
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color:
                                              TColor.secondary.withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        child: Image.asset(
                                          "assets/img/allUsers.png",
                                          width: 60,
                                          height: 60,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        "Users",
                                        style: TextStyle(
                                            color: TColor.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16),
                                      )
                                    ],
                                  ),
                                  () async {
                                    print("Generating Users PDF...");
                                    try {
                                      // Ensure data is loaded
                                      if (allUserData.isEmpty) {
                                        final users =
                                            await storeController.getUserList();
                                        allUserData = users
                                            .map((user) =>
                                                [user['name'], user['role']])
                                            .toList();
                                      }

                                      final pdfFile =
                                          await PdfApi.generateTable(
                                        ['User Name', 'Role'],
                                        allUserData,
                                        'Users Report',
                                        "In This Report We Are Displaying Information About All Of The Users",
                                        "The Total Number of The Users Is : ",
                                      );
                                      await PdfApi.openFile(pdfFile);
                                    } catch (e) {
                                      print("Error generating PDF: $e");
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              "Failed to generate PDF: $e"),
                                          backgroundColor: TColor.error,
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Row 2: Students and Professors
                        Row(
                          children: [
                            Expanded(
                              child: FadeInLeft(
                                delay: const Duration(milliseconds: 800),
                                child: statusStreamBuilder(
                                  height,
                                  width,
                                  firestore
                                      .collection("users")
                                      .where('role', isEqualTo: 'Student')
                                      .snapshots(),
                                  "Total Students",
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color:
                                              TColor.success.withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        child: Image.asset(
                                          "assets/img/students.png",
                                          width: 60,
                                          height: 60,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        "Students",
                                        style: TextStyle(
                                            color: TColor.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16),
                                      )
                                    ],
                                  ),
                                  () async {
                                    print("Generating Students PDF...");
                                    try {
                                      // Ensure data is loaded
                                      if (data.isEmpty) {
                                        final students = await storeController
                                            .getStudentList();
                                        data = students
                                            .map((student) => [
                                                  student['name'],
                                                  student['specialty']
                                                ])
                                            .toList();
                                      }

                                      final pdfFile =
                                          await PdfApi.generateTable(
                                        ['Student Name', 'Specialty'],
                                        data,
                                        'Students Report',
                                        "In This Report We Are Displaying Information About All Students",
                                        "The Total Number of Students Is : ",
                                      );
                                      await PdfApi.openFile(pdfFile);
                                    } catch (e) {
                                      print("Error generating PDF: $e");
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              "Failed to generate PDF: $e"),
                                          backgroundColor: TColor.error,
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: FadeInRight(
                                delay: const Duration(milliseconds: 900),
                                child: statusStreamBuilder(
                                  height,
                                  width,
                                  firestore
                                      .collection("users")
                                      .where('role', isEqualTo: 'Professor')
                                      .snapshots(),
                                  "Total Professors",
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.orange.withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        child: Image.asset(
                                          "assets/img/female-professor.png",
                                          width: 60,
                                          height: 60,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        "Professors",
                                        style: TextStyle(
                                            color: TColor.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16),
                                      )
                                    ],
                                  ),
                                  () async {
                                    print("Generating Professors PDF...");
                                    try {
                                      // Ensure data is loaded
                                      if (proData.isEmpty) {
                                        final professors = await storeController
                                            .getProfessorList();
                                        proData = professors
                                            .map((professor) => [
                                                  professor['name'],
                                                  professor['specialty']
                                                ])
                                            .toList();
                                      }

                                      final pdfFile =
                                          await PdfApi.generateTable(
                                        ['Professor Name', 'Specialty'],
                                        proData,
                                        'Professors Report',
                                        "In This Report We Are Displaying Information About All Professors",
                                        "The Total Number of Professors Is : ",
                                      );
                                      await PdfApi.openFile(pdfFile);
                                    } catch (e) {
                                      print("Error generating PDF: $e");
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              "Failed to generate PDF: $e"),
                                          backgroundColor: TColor.error,
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

//===================
  final PdfService _pdfService = PdfService();

  StreamBuilder<QuerySnapshot<Map<String, dynamic>>> statusStreamBuilder(
    double height,
    double width,
    Stream<QuerySnapshot<Map<String, dynamic>>> stream,
    String cellTitle,
    Widget cellChild,
    VoidCallback? onTapCallback,
  ) {
    return StreamBuilder(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(color: TColor.primary));
          }
          if (snapshot.hasData || snapshot.data != null) {
            List snap = snapshot.data!.docs;
            return FadeInDown(
              duration: const Duration(milliseconds: 1000),
              child: StatusCell(
                  height: height,
                  width: width,
                  title: cellTitle,
                  value: "${snap.length}",
                  child: cellChild,
                  onTap: onTapCallback),
            );
          }
          return FadeInDown(
            duration: const Duration(milliseconds: 1000),
            child: StatusCell(
              height: height,
              width: width,
              title: cellTitle,
              value: "0",
              child: cellChild,
            ),
          );
        });
  }
}
