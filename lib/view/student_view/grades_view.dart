import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../common_widgets/custom_app_bar.dart';
import '../../model/assignment.dart';
import '../../model/grade.dart';
import '../../services/assignment_service.dart';
import '../../theme.dart';

class GradesView extends StatefulWidget {
  const GradesView({super.key});

  @override
  State<GradesView> createState() => _GradesViewState();
}

class _GradesViewState extends State<GradesView> with TickerProviderStateMixin {
  final AssignmentService _assignmentService = Get.find<AssignmentService>();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      backgroundColor: TColor.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 150,
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
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [TColor.primary, TColor.secondary],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: TColor.primary.withOpacity(0.3),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.grade_rounded,
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
                                    "My Grades",
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: TColor.black,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "View your assignment grades and feedback",
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

            // Tabs
            SliverToBoxAdapter(
              child: Container(
                color: TColor.surface,
                child: TabBar(
                  controller: _tabController,
                  labelColor: TColor.primary,
                  unselectedLabelColor: TColor.onSurfaceVariant,
                  indicatorColor: TColor.primary,
                  tabs: const [
                    Tab(text: "By Assignment", icon: Icon(Icons.assignment)),
                    Tab(text: "By Course", icon: Icon(Icons.book)),
                  ],
                ),
              ),
            ),

            // Grades Content
            SliverToBoxAdapter(
              child: SizedBox(
                height: MediaQuery.of(context).size.height - 250,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildGradesByAssignment(userId),
                    _buildGradesByCourse(userId),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGradesByAssignment(String userId) {
    return StreamBuilder<List<Assignment>>(
      stream: _assignmentService.getStudentAssignments(userId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _buildErrorState("Error loading grades");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState();
        }

        final assignments = snapshot.data ?? [];

        // Filter to show only graded assignments
        return FutureBuilder<List<Map<String, dynamic>>>(
          future: _getGradedAssignmentsWithGrades(assignments, userId),
          builder: (context, futureSnapshot) {
            if (futureSnapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingState();
            }

            final gradedAssignments = futureSnapshot.data ?? [];

            if (gradedAssignments.isEmpty) {
              return _buildEmptyState(
                "No grades yet",
                "Your graded assignments will appear here.",
                Icons.grade,
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: gradedAssignments.length,
              itemBuilder: (context, index) {
                final assignment =
                    gradedAssignments[index]['assignment'] as Assignment;
                final grade = gradedAssignments[index]['grade'] as Grade;

                return FadeInUp(
                  delay: Duration(milliseconds: 300 + (index * 100)),
                  child: _buildGradeCard(assignment, grade),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildGradesByCourse(String userId) {
    return StreamBuilder<List<Assignment>>(
      stream: _assignmentService.getStudentAssignments(userId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _buildErrorState("Error loading grades");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState();
        }

        final assignments = snapshot.data ?? [];

        // Group assignments by course
        final courseGrades = <String, List<Map<String, dynamic>>>{};
        for (final assignment in assignments) {
          if (!courseGrades.containsKey(assignment.courseName)) {
            courseGrades[assignment.courseName] = [];
          }
        }

        // Get grades for each assignment
        return FutureBuilder<Map<String, List<Map<String, dynamic>>>>(
          future: _getGradesByCourse(assignments, userId, courseGrades),
          builder: (context, futureSnapshot) {
            if (futureSnapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingState();
            }

            final courseGradesData = futureSnapshot.data ?? {};

            if (courseGradesData.isEmpty) {
              return _buildEmptyState(
                "No grades yet",
                "Your graded assignments will appear here.",
                Icons.grade,
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: courseGradesData.length,
              itemBuilder: (context, index) {
                final courseName = courseGradesData.keys.elementAt(index);
                final grades = courseGradesData[courseName] ?? [];

                return FadeInUp(
                  delay: Duration(milliseconds: 300 + (index * 100)),
                  child: _buildCourseGradeCard(courseName, grades),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildGradeCard(Assignment assignment, Grade grade) {
    final percentage = grade.percentage;
    final letterGrade = grade.letterGrade;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    assignment.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getGradeColor(letterGrade).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    letterGrade,
                    style: TextStyle(
                      color: _getGradeColor(letterGrade),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              assignment.courseName,
              style: TextStyle(
                color: TColor.onSurfaceVariant,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildGradeInfoItem(
                  "Score",
                  "${grade.scoreDisplayText} (${percentage.toStringAsFixed(1)}%)",
                  TColor.primary,
                ),
                const SizedBox(width: 16),
                _buildGradeInfoItem(
                  "Status",
                  "Graded",
                  TColor.success,
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: TColor.navBarBackground,
              valueColor:
                  AlwaysStoppedAnimation<Color>(_getGradeColor(letterGrade)),
            ),
            if (grade.hasOverallFeedback) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: TColor.navBarBackground.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Feedback",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: TColor.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      grade.overallFeedback!,
                      style: TextStyle(
                        color: TColor.onSurface,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCourseGradeCard(
      String courseName, List<Map<String, dynamic>> grades) {
    // Calculate course average
    double totalPercentage = 0;
    int count = 0;

    for (final gradeData in grades) {
      final grade = gradeData['grade'] as Grade;
      totalPercentage += grade.percentage;
      count++;
    }

    final averagePercentage = count > 0 ? totalPercentage / count : 0;
    final averageLetterGrade = _getLetterGrade(averagePercentage.toDouble());

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    courseName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getGradeColor(averageLetterGrade).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    averageLetterGrade,
                    style: TextStyle(
                      color: _getGradeColor(averageLetterGrade),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildGradeInfoItem(
              "Course Average",
              "${averagePercentage.toStringAsFixed(1)}%",
              TColor.primary,
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: averagePercentage / 100,
              backgroundColor: TColor.navBarBackground,
              valueColor: AlwaysStoppedAnimation<Color>(
                  _getGradeColor(averageLetterGrade)),
            ),
            const SizedBox(height: 16),
            Text(
              "Assignments (${grades.length})",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: TColor.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: grades.length,
              itemBuilder: (context, index) {
                final assignment = grades[index]['assignment'] as Assignment;
                final grade = grades[index]['grade'] as Grade;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          assignment.title,
                          style: TextStyle(
                            color: TColor.onSurface,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Text(
                        "${grade.scoreDisplayText} (${grade.letterGrade})",
                        style: TextStyle(
                          color: _getGradeColor(grade.letterGrade),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGradeInfoItem(String label, String value, Color color) {
    return Row(
      children: [
        Icon(Icons.info, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          "$label: ",
          style: TextStyle(
            color: TColor.onSurfaceVariant,
            fontSize: 12,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: CircularProgressIndicator(
        color: TColor.primary,
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: TColor.error,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              color: TColor.error,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String title, String subtitle, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 48,
            color: TColor.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: TColor.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: TColor.onSurfaceVariant,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods
  Future<List<Map<String, dynamic>>> _getGradedAssignmentsWithGrades(
      List<Assignment> assignments, String userId) async {
    final graded = <Map<String, dynamic>>[];
    for (final assignment in assignments) {
      final submission =
          await _assignmentService.getStudentSubmission(assignment.id, userId);
      if (submission != null && submission.isGraded) {
        final grade =
            await _assignmentService.getGradeForSubmission(submission.id);
        if (grade != null) {
          graded.add({
            'assignment': assignment,
            'grade': grade,
          });
        }
      }
    }
    return graded;
  }

  Future<Map<String, List<Map<String, dynamic>>>> _getGradesByCourse(
      List<Assignment> assignments,
      String userId,
      Map<String, List<Map<String, dynamic>>> courseGrades) async {
    final result = <String, List<Map<String, dynamic>>>{};

    for (final assignment in assignments) {
      final submission =
          await _assignmentService.getStudentSubmission(assignment.id, userId);
      if (submission != null && submission.isGraded) {
        final grade =
            await _assignmentService.getGradeForSubmission(submission.id);
        if (grade != null) {
          if (!result.containsKey(assignment.courseName)) {
            result[assignment.courseName] = [];
          }
          result[assignment.courseName]!.add({
            'assignment': assignment,
            'grade': grade,
          });
        }
      }
    }

    return result;
  }

  Color _getGradeColor(String letterGrade) {
    switch (letterGrade) {
      case 'A+':
      case 'A':
      case 'A-':
        return TColor.success;
      case 'B+':
      case 'B':
      case 'B-':
        return TColor.primary;
      case 'C+':
      case 'C':
      case 'C-':
        return TColor.warning;
      default:
        return TColor.error;
    }
  }

  String _getLetterGrade(double percentage) {
    if (percentage >= 97) return 'A+';
    if (percentage >= 93) return 'A';
    if (percentage >= 90) return 'A-';
    if (percentage >= 87) return 'B+';
    if (percentage >= 83) return 'B';
    if (percentage >= 80) return 'B-';
    if (percentage >= 77) return 'C+';
    if (percentage >= 73) return 'C';
    if (percentage >= 70) return 'C-';
    if (percentage >= 67) return 'D+';
    if (percentage >= 65) return 'D';
    return 'F';
  }
}
