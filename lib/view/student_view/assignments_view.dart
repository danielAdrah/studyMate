import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../common_widgets/custom_app_bar.dart';
import '../../model/assignment.dart';
import '../../services/assignment_service.dart';
import '../../theme.dart';
import 'assignment_detail_view.dart';

class AssignmentsView extends StatefulWidget {
  const AssignmentsView({super.key});

  @override
  State<AssignmentsView> createState() => _AssignmentsViewState();
}

class _AssignmentsViewState extends State<AssignmentsView>
    with TickerProviderStateMixin {
  final AssignmentService _assignmentService = Get.find<AssignmentService>();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
                                Icons.assignment_rounded,
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
                                    "My Assignments",
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: TColor.black,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Track your assignments and grades",
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
                    Tab(text: "Upcoming", icon: Icon(Icons.schedule)),
                    Tab(text: "In Progress", icon: Icon(Icons.edit)),
                    Tab(text: "Graded", icon: Icon(Icons.grade)),
                  ],
                ),
              ),
            ),

            // Assignments Content
            SliverToBoxAdapter(
              child: SizedBox(
                height: MediaQuery.of(context).size.height - 250,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildUpcomingAssignments(userId),
                    _buildInProgressAssignments(userId),
                    _buildGradedAssignments(userId),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingAssignments(String userId) {
    return StreamBuilder<List<Assignment>>(
      stream: _assignmentService.getStudentAssignments(userId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _buildErrorState("Error loading assignments");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState();
        }

        final now = DateTime.now();
        final upcomingAssignments = (snapshot.data ?? [])
            .where((assignment) => assignment.dueDate.isAfter(now))
            .toList();

        // Filter out assignments that have already been submitted
        return FutureBuilder<List<Assignment>>(
          future: _filterSubmittedAssignments(upcomingAssignments, userId),
          builder: (context, futureSnapshot) {
            if (futureSnapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingState();
            }

            final filteredAssignments = futureSnapshot.data ?? [];

            if (filteredAssignments.isEmpty) {
              return _buildEmptyState(
                "No upcoming assignments",
                "You're all caught up! Check back later for new assignments.",
                Icons.event_available,
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: filteredAssignments.length,
              itemBuilder: (context, index) {
                return FadeInUp(
                  delay: Duration(milliseconds: 300 + (index * 100)),
                  child:
                      _buildAssignmentCard(filteredAssignments[index], userId),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildInProgressAssignments(String userId) {
    return StreamBuilder<List<Assignment>>(
      stream: _assignmentService.getStudentAssignments(userId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _buildErrorState("Error loading assignments");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState();
        }

        final now = DateTime.now();
        final inProgressAssignments = (snapshot.data ?? [])
            .where((assignment) => assignment.dueDate.isAfter(now))
            .toList();

        // Filter to show only assignments that have been submitted but not graded
        return FutureBuilder<List<Assignment>>(
          future: _filterSubmittedButNotGradedAssignments(
              inProgressAssignments, userId),
          builder: (context, futureSnapshot) {
            if (futureSnapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingState();
            }

            final filteredAssignments = futureSnapshot.data ?? [];

            if (filteredAssignments.isEmpty) {
              return _buildEmptyState(
                "No assignments in progress",
                "Start working on your assignments to see them here.",
                Icons.edit_note,
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: filteredAssignments.length,
              itemBuilder: (context, index) {
                return FadeInUp(
                  delay: Duration(milliseconds: 300 + (index * 100)),
                  child: _buildAssignmentCard(
                      filteredAssignments[index], userId,
                      isSubmitted: true),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildGradedAssignments(String userId) {
    return StreamBuilder<List<Assignment>>(
      stream: _assignmentService.getStudentAssignments(userId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _buildErrorState("Error loading assignments");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState();
        }

        final allAssignments = snapshot.data ?? [];

        // Filter to show only assignments that have been graded
        return FutureBuilder<List<Assignment>>(
          future: _filterGradedAssignments(allAssignments, userId),
          builder: (context, futureSnapshot) {
            if (futureSnapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingState();
            }

            final filteredAssignments = futureSnapshot.data ?? [];

            if (filteredAssignments.isEmpty) {
              return _buildEmptyState(
                "No graded assignments",
                "Your submitted assignments will appear here once graded.",
                Icons.grade,
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: filteredAssignments.length,
              itemBuilder: (context, index) {
                return FadeInUp(
                  delay: Duration(milliseconds: 300 + (index * 100)),
                  child: _buildAssignmentCard(
                      filteredAssignments[index], userId,
                      isGraded: true),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildAssignmentCard(Assignment assignment, String userId,
      {bool isSubmitted = false, bool isGraded = false}) {
    final now = DateTime.now();
    final timeUntilDue = assignment.dueDate.difference(now);
    final isOverdue = timeUntilDue.isNegative;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          Get.to(() => AssignmentDetailView(assignment: assignment));
        },
        borderRadius: BorderRadius.circular(16),
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
                  if (isSubmitted)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: TColor.success.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "Submitted",
                        style: TextStyle(
                          color: TColor.success,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  else if (isGraded)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: TColor.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "Graded",
                        style: TextStyle(
                          color: TColor.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  else if (isOverdue)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: TColor.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "Overdue",
                        style: TextStyle(
                          color: TColor.error,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: TColor.warning.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _formatTimeUntilDue(timeUntilDue),
                        style: TextStyle(
                          color: TColor.warning,
                          fontSize: 12,
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
              const SizedBox(height: 8),
              Text(
                assignment.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: TColor.onSurface.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.schedule,
                    size: 16,
                    color: TColor.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "Due: ${DateFormat('MMM dd, yyyy HH:mm').format(assignment.dueDate)}",
                    style: TextStyle(
                      color: isOverdue ? TColor.error : TColor.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.bar_chart,
                    size: 16,
                    color: TColor.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "${assignment.totalPoints} pts",
                    style: TextStyle(
                      color: TColor.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (!isSubmitted && !isGraded)
                LinearProgressIndicator(
                  value: 0.0,
                  backgroundColor: TColor.navBarBackground,
                  valueColor: AlwaysStoppedAnimation<Color>(TColor.primary),
                )
              else if (isSubmitted && !isGraded)
                LinearProgressIndicator(
                  value: 1.0,
                  backgroundColor: TColor.navBarBackground,
                  valueColor: AlwaysStoppedAnimation<Color>(TColor.success),
                )
              else if (isGraded)
                LinearProgressIndicator(
                  value: 1.0,
                  backgroundColor: TColor.navBarBackground,
                  valueColor: AlwaysStoppedAnimation<Color>(TColor.primary),
                ),
            ],
          ),
        ),
      ),
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

  String _formatTimeUntilDue(Duration duration) {
    if (duration.isNegative) return "Overdue";

    if (duration.inDays > 0) {
      return "${duration.inDays}d left";
    } else if (duration.inHours > 0) {
      return "${duration.inHours}h left";
    } else if (duration.inMinutes > 0) {
      return "${duration.inMinutes}m left";
    } else {
      return "Due soon";
    }
  }

  // Helper methods to filter assignments
  Future<List<Assignment>> _filterSubmittedAssignments(
      List<Assignment> assignments, String userId) async {
    final filtered = <Assignment>[];
    for (final assignment in assignments) {
      final isSubmitted = await _assignmentService
          .hasStudentSubmittedAssignment(assignment.id, userId);
      if (!isSubmitted) {
        filtered.add(assignment);
      }
    }
    return filtered;
  }

  Future<List<Assignment>> _filterSubmittedButNotGradedAssignments(
      List<Assignment> assignments, String userId) async {
    final filtered = <Assignment>[];
    for (final assignment in assignments) {
      final isSubmitted = await _assignmentService
          .hasStudentSubmittedAssignment(assignment.id, userId);
      if (isSubmitted) {
        // Check if it's graded
        final submission = await _assignmentService.getStudentSubmission(
            assignment.id, userId);
        if (submission != null && !submission.isGraded) {
          filtered.add(assignment);
        }
      }
    }
    return filtered;
  }

  Future<List<Assignment>> _filterGradedAssignments(
      List<Assignment> assignments, String userId) async {
    final filtered = <Assignment>[];
    for (final assignment in assignments) {
      final submission =
          await _assignmentService.getStudentSubmission(assignment.id, userId);
      if (submission != null && submission.isGraded) {
        filtered.add(assignment);
      }
    }
    return filtered;
  }
}
