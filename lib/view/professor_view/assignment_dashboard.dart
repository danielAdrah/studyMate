// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../model/assignment.dart';
import '../../services/assignment_service.dart';
import '../../common_widgets/custom_app_bar.dart';
import '../../theme.dart';
import 'create_assignment.dart';
import 'grading_interface.dart';
import 'professor_analytics.dart';

class AssignmentDashboard extends StatefulWidget {
  const AssignmentDashboard({super.key});

  @override
  State<AssignmentDashboard> createState() => _AssignmentDashboardState();
}

class _AssignmentDashboardState extends State<AssignmentDashboard>
    with TickerProviderStateMixin {
  final AssignmentService _assignmentService = Get.find<AssignmentService>();
  late TabController _tabController;
  String? professorId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    // Get professor ID from Firebase Auth
    professorId = FirebaseAuth.instance.currentUser?.uid;

    if (professorId == null) {
      // Handle case where user is not authenticated
      Get.snackbar("Error", "User not authenticated");
      Get.back();
    }
    _assignmentService.getProfessorAssignments(professorId!);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.background,
      appBar: AppBar(
        // backgroundColor: TColor.primary,
        foregroundColor: TColor.onPrimary,
        elevation: 0,
        title: const Text(
          "Assignment Center",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                TColor.primary,
                TColor.secondary,
              ],
            ),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: TColor.onPrimary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.analytics_rounded),
              onPressed: () => Get.to(() => const ProfessorAnalytics()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 80,
            decoration: BoxDecoration(
              color: TColor.surface,
              boxShadow: [
                BoxShadow(
                  color: TColor.primary.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TabBar(
              key: const ValueKey('assignment_dashboard_tabs'),
              controller: _tabController,
              labelColor: TColor.primary,
              unselectedLabelColor: TColor.onSurfaceVariant,
              indicatorColor: TColor.primary,
              indicatorWeight: 3,
              // indicatorPadding: const EdgeInsets.symmetric(horizontal: 16),
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
              tabs: [
                Tab(
                  text: "All",
                  icon: Icon(Icons.assignment_rounded,
                      color: TColor.onSurfaceVariant),
                ),
                Tab(
                  text: "Published",
                  icon: Icon(Icons.publish_rounded,
                      color: TColor.onSurfaceVariant),
                ),
                Tab(
                  text: "Drafts",
                  icon: Icon(Icons.drafts_rounded,
                      color: TColor.onSurfaceVariant),
                ),
                Tab(
                  text: "Grading",
                  icon:
                      Icon(Icons.grade_rounded, color: TColor.onSurfaceVariant),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              key: const ValueKey('assignment_dashboard_tab_view'),
              controller: _tabController,
              children: [
                _buildAllAssignments(),
                _buildPublishedAssignments(),
                _buildDraftAssignments(),
                _buildGradingQueue(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              TColor.primary,
              TColor.secondary,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: TColor.primary.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () => Get.to(() => const CreateAssignment()),
          icon: const Icon(Icons.add_rounded),
          label: const Text(
            "New Assignment",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.transparent,
          foregroundColor: TColor.onPrimary,
          elevation: 0,
        ),
      ),
    );
  }

  Widget _buildAllAssignments() {
    return StreamBuilder<List<Assignment>>(
      stream: _assignmentService.getProfessorAssignments(professorId!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: TextStyle(color: TColor.error),
            ),
          );
        }

        final assignments = snapshot.data ?? [];

        if (assignments.isEmpty) {
          return _buildEmptyState("No assignments yet",
              "Create your first assignment to get started");
        }

        return RefreshIndicator(
          onRefresh: () async {
            setState(() {});
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: assignments.length,
            itemBuilder: (context, index) =>
                _buildAssignmentCard(assignments[index]),
          ),
        );
      },
    );
  }

  Widget _buildPublishedAssignments() {
    return StreamBuilder<List<Assignment>>(
      stream: _assignmentService.getProfessorAssignments(professorId!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final assignments = (snapshot.data ?? [])
            .where((a) => a.status == AssignmentStatus.published)
            .toList();

        if (assignments.isEmpty) {
          return _buildEmptyState("No published assignments",
              "Publish an assignment to make it available to students");
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: assignments.length,
          itemBuilder: (context, index) =>
              _buildAssignmentCard(assignments[index]),
        );
      },
    );
  }

  Widget _buildDraftAssignments() {
    return StreamBuilder<List<Assignment>>(
      stream: _assignmentService.getProfessorAssignments(professorId!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final assignments = (snapshot.data ?? [])
            .where((a) => a.status == AssignmentStatus.draft)
            .toList();

        if (assignments.isEmpty) {
          return _buildEmptyState("No draft assignments",
              "All your assignments are published or closed");
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: assignments.length,
          itemBuilder: (context, index) =>
              _buildAssignmentCard(assignments[index]),
        );
      },
    );
  }

  Widget _buildGradingQueue() {
    return StreamBuilder<List<Assignment>>(
      stream: _assignmentService.getProfessorAssignments(professorId!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final assignments = (snapshot.data ?? [])
            .where((a) => a.submissionCount > a.gradedCount)
            .toList();

        if (assignments.isEmpty) {
          return _buildEmptyState(
              "No pending grading", "All submissions are graded!");
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: assignments.length,
          itemBuilder: (context, index) =>
              _buildGradingCard(assignments[index]),
        );
      },
    );
  }

  Widget _buildAssignmentCard(Assignment assignment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: TColor.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: TColor.primary.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: TColor.primary.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showAssignmentOptions(assignment),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        assignment.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: TColor.onSurface,
                        ),
                      ),
                    ),
                    _buildStatusChip(assignment.status),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: TColor.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    assignment.courseName,
                    style: TextStyle(
                      color: TColor.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  assignment.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: TColor.onSurfaceVariant,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: TColor.background,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.schedule_rounded,
                              size: 16,
                              color: assignment.isOverdue
                                  ? TColor.error
                                  : TColor.accent),
                          const SizedBox(width: 6),
                          Text(
                            "Due: ${DateFormat('MMM dd, yyyy HH:mm').format(assignment.dueDate)}",
                            style: TextStyle(
                              color: assignment.isOverdue
                                  ? TColor.error
                                  : TColor.onSurfaceVariant,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          if (assignment.isPublished) ...[
                            Icon(Icons.people_rounded,
                                size: 16, color: TColor.accent),
                            const SizedBox(width: 4),
                            Text(
                              "${assignment.submissionCount} submissions",
                              style: TextStyle(
                                  color: TColor.onSurfaceVariant, fontSize: 12),
                            ),
                          ],
                        ],
                      ),
                      if (assignment.submissionCount > 0) ...[
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 6,
                                decoration: BoxDecoration(
                                  color:
                                      TColor.onSurfaceVariant.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: FractionallySizedBox(
                                  alignment: Alignment.centerLeft,
                                  widthFactor: assignment.gradingProgress,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: assignment.gradingProgress == 1.0
                                          ? TColor.success
                                          : TColor.warning,
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "${assignment.gradedCount}/${assignment.submissionCount}",
                              style: TextStyle(
                                color: TColor.onSurfaceVariant,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
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

  Widget _buildGradingCard(Assignment assignment) {
    final pendingCount = assignment.submissionCount - assignment.gradedCount;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      color: TColor.surface,
      child: InkWell(
        onTap: () => Get.to(() => GradingInterface(assignment: assignment)),
        borderRadius: BorderRadius.circular(8),
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
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: TColor.onSurface,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: TColor.warning.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "$pendingCount pending",
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
                style: TextStyle(color: TColor.onSurfaceVariant, fontSize: 14),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.schedule,
                      size: 16, color: TColor.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Text(
                    "Due: ${DateFormat('MMM dd').format(assignment.dueDate)}",
                    style:
                        TextStyle(color: TColor.onSurfaceVariant, fontSize: 12),
                  ),
                  const Spacer(),
                  Text(
                    "${assignment.totalPoints} points",
                    style:
                        TextStyle(color: TColor.onSurfaceVariant, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: assignment.gradingProgress,
                backgroundColor: TColor.onSurfaceVariant.withOpacity(0.3),
                valueColor: AlwaysStoppedAnimation<Color>(TColor.warning),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(AssignmentStatus status) {
    Color color = _getStatusChipColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        status.name.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getStatusChipColor(AssignmentStatus status) {
    switch (status) {
      case AssignmentStatus.draft:
        return TColor.onSurfaceVariant;
      case AssignmentStatus.published:
        return TColor.success;
      case AssignmentStatus.closed:
        return TColor.primary;
      case AssignmentStatus.graded:
        return TColor.secondary;
    }
  }

  Widget _buildEmptyState(String title, String subtitle) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(32),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: TColor.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: TColor.primary.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: TColor.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.assignment_outlined,
                size: 64,
                color: TColor.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
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
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAssignmentOptions(Assignment assignment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: TColor.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: TColor.primary.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: TColor.onSurfaceVariant.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                assignment.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: TColor.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              _buildOptionTile(
                icon: Icons.edit_rounded,
                title: "Edit Assignment",
                subtitle: "Modify assignment details",
                color: TColor.primary,
                onTap: () {
                  Navigator.pop(context);
                  Get.to(() => CreateAssignment(assignment: assignment));
                },
              ),
              _buildOptionTile(
                icon: Icons.grade_rounded,
                title: "Grade Submissions",
                subtitle: "Review and grade student work",
                color: TColor.accent,
                onTap: () {
                  Navigator.pop(context);
                  Get.to(() => GradingInterface(assignment: assignment));
                },
              ),
              if (assignment.isDraft)
                _buildOptionTile(
                  icon: Icons.publish_rounded,
                  title: "Publish Assignment",
                  subtitle: "Make available to students",
                  color: TColor.success,
                  onTap: () async {
                    Navigator.pop(context);
                    await _assignmentService.publishAssignment(assignment.id);
                    Get.snackbar("Success", "Assignment published successfully",
                        backgroundColor: TColor.success,
                        colorText: Colors.white);
                  },
                ),
              if (assignment.isPublished)
                _buildOptionTile(
                  icon: Icons.close_rounded,
                  title: "Close Assignment",
                  subtitle: "Stop accepting submissions",
                  color: TColor.warning,
                  onTap: () async {
                    Navigator.pop(context);
                    await _assignmentService.closeAssignment(assignment.id);
                    Get.snackbar("Success", "Assignment closed successfully");
                  },
                ),
              _buildOptionTile(
                icon: Icons.delete_rounded,
                title: "Delete Assignment",
                subtitle: "Permanently remove assignment",
                color: TColor.error,
                onTap: () async {
                  Navigator.pop(context);
                  final confirm = await Get.dialog<bool>(
                    AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      title: const Text("Confirm Delete"),
                      content: const Text(
                          "Are you sure you want to delete this assignment? This action cannot be undone."),
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(result: false),
                          child: const Text("Cancel"),
                        ),
                        ElevatedButton(
                          onPressed: () => Get.back(result: true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: TColor.error,
                          ),
                          child: const Text("Delete"),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    await _assignmentService.deleteAssignment(assignment.id);
                    Get.snackbar("Success", "Assignment deleted successfully");
                  }
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: TColor.onSurface,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: TColor.onSurfaceVariant,
            fontSize: 12,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
          color: color,
        ),
      ),
    );
  }
}
