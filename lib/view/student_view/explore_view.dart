// ignore_for_file: deprecated_member_use

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common_widgets/course_cell.dart';
import '../../common_widgets/custom_app_bar.dart';
import '../../common_widgets/custome_text_field.dart';
import '../../common_widgets/professor_cell.dart';
import '../../controller/store_controller.dart';
import '../../theme.dart';
import 'community_view/first_year.dart';
import 'community_view/fourth_year.dart';
import 'community_view/second_year.dart';
import 'community_view/third_year.dart';
import 'course_reservation.dart';

class ExploreView extends StatefulWidget {
  const ExploreView({super.key});

  @override
  State<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> {
  bool haveCourseSearched = false;
  final firebaseMessaging = FirebaseMessaging.instance;
  final searchCont = TextEditingController();
  final controller = Get.put(StoreController());

  @override
  void initState() {
    controller.getAllCourse();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: TColor.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 170,
              floating: true,
              backgroundColor: TColor.background,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      FadeInDown(
                        delay: const Duration(milliseconds: 300),
                        child: Text(
                          "Explore",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: TColor.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      FadeInDown(
                        delay: const Duration(milliseconds: 400),
                        child: Text(
                          "Discover courses and connect with professors",
                          style: TextStyle(
                            fontSize: 16,
                            // color: TColor.black.withOpacity(0.6),
                            color: TColor.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),

            // Search Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    FadeInDown(
                      delay: const Duration(milliseconds: 500),
                      child: _buildModernSearchBar(),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),

            // Popular Professors Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeInDown(
                      delay: const Duration(milliseconds: 600),
                      child: _buildSectionHeader(
                        "Popular Professors",
                        "Meet our expert educators",
                        Icons.school,
                      ),
                    ),
                    const SizedBox(height: 20),
                    FadeInDown(
                      delay: const Duration(milliseconds: 700),
                      child: _buildProfessorsList(height * 0.25),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),

            // Popular Courses Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeInDown(
                      delay: const Duration(milliseconds: 800),
                      child: _buildSectionHeader(
                        "Popular Courses",
                        "Start your learning journey",
                        Icons.book,
                      ),
                    ),
                    const SizedBox(height: 20),
                    FadeInDown(
                      delay: const Duration(milliseconds: 900),
                      child: _buildCoursesList(),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),

            // Community Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    FadeInUp(
                      delay: const Duration(milliseconds: 1000),
                      child: _buildCommunitySection(),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Modern Search Bar
  Widget _buildModernSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: TColor.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: TColor.primary.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: CustomTextForm(
        hinttext: "Search courses, professors...",
        mycontroller: searchCont,
        secure: false,
        suffixIcon: Icons.search_rounded,
        color: TColor.primary,
        onChanged: (value) {
          if (value.isNotEmpty) {
            setState(() {
              haveCourseSearched = true;
            });
          } else {
            setState(() {
              haveCourseSearched = false;
            });
          }
        },
      ),
    );
  }

  // Section Header with Icon
  Widget _buildSectionHeader(String title, String subtitle, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: TColor.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: TColor.primary,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: TColor.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: TColor.black.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Enhanced Professors List
  Widget _buildProfessorsList(double height) {
    return SizedBox(
      height: height,
      child: StreamBuilder(
        stream: controller.getProfessorStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return _buildErrorState("Error loading professors");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingState();
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildEmptyState(
              "No professors available",
              "Check back later for new professors",
              Icons.school_outlined,
            );
          }
          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var pro = snapshot.data![index];
              return SlideInLeft(
                delay: Duration(milliseconds: 100 * index),
                child: Container(
                  margin: const EdgeInsets.only(right: 16),
                  child: ProfessorCell(
                    profName: pro['name'],
                    profImg: "assets/img/woman.png",
                    profField: pro['specialty'],
                    onTap: () {},
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Enhanced Courses List
  Widget _buildCoursesList() {
    return SizedBox(
      height: 220,
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("courses").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return _buildErrorState("Error loading courses");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingState();
          }

          if (snapshot.hasData && snapshot.data != null) {
            List snap = snapshot.data!.docs;
            if (haveCourseSearched) {
              snap.removeWhere((e) {
                return !e
                    .data()["courseName"]
                    .toString()
                    .toLowerCase()
                    .startsWith(searchCont.text.toLowerCase());
              });
            }

            if (snap.isEmpty) {
              return _buildEmptyState(
                haveCourseSearched
                    ? "No courses found"
                    : "No courses available",
                haveCourseSearched
                    ? "Try a different search term"
                    : "Check back later for new courses",
                Icons.book_outlined,
              );
            }

            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              itemCount: snap.length,
              itemBuilder: (context, index) {
                var course = snap[index];
                return SlideInRight(
                  delay: Duration(milliseconds: 100 * index),
                  child: Container(
                    margin: const EdgeInsets.only(right: 16),
                    child: CourseCell(
                      courseName: course['courseName'],
                      courseField: course['courseField'],
                      courseTime: "3h 30min",
                      coursePrice: "200",
                      onTap: () {
                        Get.to(CourseReservation(
                          courseName: course['courseName'],
                          courseField: course['courseField'],
                          courseID: course.id,
                        ));
                      },
                    ),
                  ),
                );
              },
            );
          } else {
            return _buildEmptyState(
              "No courses available",
              "Check back later for new courses",
              Icons.book_outlined,
            );
          }
        },
      ),
    );
  }

  // Modern Community Section
  Widget _buildCommunitySection() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            TColor.primary.withOpacity(0.1),
            TColor.accent.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: TColor.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: TColor.accent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.groups_rounded,
                    color: TColor.accent,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Student Community",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: TColor.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Connect with peers in your year",
                        style: TextStyle(
                          fontSize: 16,
                          color: TColor.black.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 2.5,
              children: [
                _buildCommunityButton("First Year", Icons.looks_one_rounded,
                    () => Get.to(const FirstYear())),
                _buildCommunityButton("Second Year", Icons.looks_two_rounded,
                    () => Get.to(const SecondYear())),
                _buildCommunityButton("Third Year", Icons.looks_3_rounded,
                    () => Get.to(const ThirdYear())),
                _buildCommunityButton("Fourth Year", Icons.looks_4_rounded,
                    () => Get.to(const FourthYear())),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Modern Community Button
  Widget _buildCommunityButton(
      String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: TColor.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: TColor.primary.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: TColor.primary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: TColor.primary,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Loading State
  Widget _buildLoadingState() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: TColor.primary,
              strokeWidth: 3,
            ),
            const SizedBox(height: 16),
            Text(
              "Loading...",
              style: TextStyle(
                color: TColor.black.withOpacity(0.6),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Error State
  Widget _buildErrorState(String message) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: TColor.error,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(
                color: TColor.black.withOpacity(0.8),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Empty State
  Widget _buildEmptyState(String title, String subtitle, IconData icon) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: TColor.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: TColor.primary.withOpacity(0.6),
                size: 48,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                color: TColor.black.withOpacity(0.8),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
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
}
