// ignore_for_file: deprecated_member_use

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../common_widgets/status_cell.dart';
import '../../controller/store_controller.dart';
import '../../theme.dart';
import 'admin_appBar.dart';

class ReportsTab extends StatefulWidget {
  const ReportsTab({super.key});

  @override
  State<ReportsTab> createState() => _ReportsTabState();
}

class _ReportsTabState extends State<ReportsTab> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final storeController = Get.put(StoreController());

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const AdminAppbar(),
                const SizedBox(height: 50),
                FadeInDown(
                  delay: const Duration(milliseconds: 500),
                  child: Text(
                    "App Statistics",
                    style: TextStyle(
                      color: TColor.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                statusStreamBuilder(
                  height,
                  width,
                  FirebaseFirestore.instance.collection("courses").snapshots(),
                  "Available Courses:",
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/img/online-education.png",
                        width: 120,
                        height: 120,
                      ),
                      Text(
                        "Courses",
                        style: TextStyle(
                            color: TColor.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 22),
                      )
                    ],
                  ),
                  // SvgPicture.asset(
                  //   "assets/img/course.svg",
                  //   width: 100,
                  //   height: 100,
                  //   color: TColor.white,
                  // ),
                ),
                const SizedBox(height: 20),
                statusStreamBuilder(
                  height,
                  width,
                  FirebaseFirestore.instance.collection("users").snapshots(),
                  "Total Users:",
                  Column(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/img/allUsers.png",
                        width: 130,
                        height: 130,
                      ),
                      Text(
                        "Users",
                        style: TextStyle(
                            color: TColor.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 22),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                statusStreamBuilder(
                  height,
                  width,
                  firestore
                      .collection("users")
                      .where('role', isEqualTo: 'Student')
                      .snapshots(),
                  "Total Students:",
                  Column(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/img/students.png",
                        width: 120,
                        height: 120,
                      ),
                      Text(
                        "Students",
                        style: TextStyle(
                            color: TColor.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 22),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                statusStreamBuilder(
                  height,
                  width,
                  firestore
                      .collection("users")
                      .where('role', isEqualTo: 'Professor')
                      .snapshots(),
                  "Total Professors:",
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/img/female-professor.png",
                        width: 120,
                        height: 120,
                      ),
                      Text(
                        "Professors",
                        style: TextStyle(
                            color: TColor.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 22),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

//===================
  StreamBuilder<QuerySnapshot<Map<String, dynamic>>> statusStreamBuilder(
    double height,
    double width,
    Stream<QuerySnapshot<Map<String, dynamic>>> stream,
    String cellTitle,
    Widget cellChild,
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
              ),
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
