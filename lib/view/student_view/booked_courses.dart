// ignore_for_file: deprecated_member_use

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common_widgets/booked_course_cell.dart';
import '../../common_widgets/custom_app_bar.dart';
import '../../controller/store_controller.dart';
import '../../theme.dart';
import 'booked_course_detail.dart';

class BookedCourses extends StatefulWidget {
  const BookedCourses({super.key});

  @override
  State<BookedCourses> createState() => _BookedCoursesState();
}

class _BookedCoursesState extends State<BookedCourses> {
  final storeController = Get.put(StoreController());

  @override
  void initState() {
    storeController.fetchBookedCoursesStream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 120,
              floating: true,
              pinned: true,
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
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [TColor.success, TColor.accent],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: TColor.success.withOpacity(0.3),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.bookmark_added_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "My Courses",
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: TColor.black,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Continue your learning journey",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: TColor.black.withOpacity(0.6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),

            // Course Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    FadeInDown(
                      delay: const Duration(milliseconds: 500),
                      child: _buildCoursesSection(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Enhanced Courses Section
  Widget _buildCoursesSection() {
    return StreamBuilder(
      stream: storeController.fetchBookedCoursesStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _buildErrorState("Error loading your courses");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState();
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildEmptyState();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats Header
            FadeInDown(
              delay: const Duration(milliseconds: 600),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      TColor.primary.withOpacity(0.1),
                      TColor.secondary.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: TColor.primary.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        "${snapshot.data!.length}",
                        "Enrolled",
                        Icons.school_rounded,
                        TColor.primary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStatCard(
                        "${_calculateProgress(snapshot.data!.length)}%",
                        "Progress",
                        Icons.trending_up_rounded,
                        TColor.success,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStatCard(
                        "${_calculateHours(snapshot.data!.length)}h",
                        "Study Time",
                        Icons.access_time_rounded,
                        TColor.warning,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Courses Grid
            FadeInUp(
              delay: const Duration(milliseconds: 800),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  var bookedCourse = snapshot.data![index];
                  final courseId = bookedCourse['id'];

                  return SlideInUp(
                    delay: Duration(milliseconds: 100 * index),
                    child: Stack(
                      children: [
                        BookedCourseCell(
                          courseName: bookedCourse['courseName'],
                          courseField: bookedCourse['courseField'],
                          onTap: () {
                            Get.to(BookedCourseDetail(
                              courseID: bookedCourse['id'],
                              courseName: bookedCourse['courseName'],
                              courseField: bookedCourse['courseField'],
                            ));
                          },
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () async {
                              // Show confirmation dialog
                              bool? confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  icon: Icon(
                                    Icons.warning_amber_rounded,
                                    color: TColor.warning,
                                    size: 48,
                                  ),
                                  title: Text(
                                    "Remove Course",
                                    style: TextStyle(
                                      color: TColor.onSurface,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  content: Text(
                                    "Are you sure you want to remove ${bookedCourse['courseName']} from your booked courses? This action cannot be undone.",
                                    style: TextStyle(
                                        color: TColor.onSurfaceVariant),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Get.back(result: false),
                                      child: Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () => Get.back(result: true),
                                      child: Text(
                                        "Remove",
                                        style: TextStyle(color: TColor.error),
                                      ),
                                    ),
                                  ],
                                ),
                              );

                              if (confirm == true) {
                                try {
                                  await storeController
                                      .deleteBookedCourse(courseId);
                                  // Refresh the stream to update UI immediately
                                  setState(() {});
                                  Get.snackbar(
                                    "Course Removed",
                                    "${bookedCourse['courseName']} has been removed from your booked courses",
                                    backgroundColor: TColor.success,
                                    colorText: Colors.white,
                                    duration: Duration(seconds: 3),
                                    snackPosition: SnackPosition.BOTTOM,
                                    icon: Icon(Icons.check_circle,
                                        color: Colors.white),
                                  );
                                } catch (e) {
                                  Get.snackbar(
                                    "Error",
                                    "Failed to remove course: ${e.toString()}",
                                    backgroundColor: TColor.error,
                                    colorText: Colors.white,
                                    duration: Duration(seconds: 3),
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                }
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: TColor.background,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: TColor.error.withOpacity(0.3)),
                                boxShadow: [
                                  BoxShadow(
                                    color: TColor.error.withOpacity(0.2),
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.close,
                                color: TColor.error,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
          ],
        );
      },
    );
  }

  // Stat Card Widget
  Widget _buildStatCard(
      String value, String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color.withOpacity(0.8),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // Loading State
  Widget _buildLoadingState() {
    return Container(
      height: 300,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: TColor.primary,
              strokeWidth: 3,
            ),
            const SizedBox(height: 16),
            Text(
              "Loading your courses...",
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
    return Container(
      height: 300,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: TColor.error,
              size: 64,
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
  Widget _buildEmptyState() {
    return Container(
      height: 400,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    TColor.primary.withOpacity(0.1),
                    TColor.secondary.withOpacity(0.1),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.book_outlined,
                color: TColor.primary.withOpacity(0.6),
                size: 64,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "No Courses Yet",
              style: TextStyle(
                color: TColor.black.withOpacity(0.8),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Start exploring and book your first course\nto begin your learning journey!",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: TColor.black.withOpacity(0.5),
                fontSize: 16,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.explore_rounded),
              label: const Text("Explore Courses"),
              style: ElevatedButton.styleFrom(
                backgroundColor: TColor.primary,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods for calculations
  int _calculateProgress(int courseCount) {
    return courseCount > 0 ? (courseCount * 15).clamp(0, 100) : 0;
  }

  int _calculateHours(int courseCount) {
    return courseCount * 3; // Assuming 3 hours per course
  }
}
